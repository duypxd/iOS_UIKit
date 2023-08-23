//
//  APIService.swift
//  Gespage
//
//  Created by duy.pham on 23/08/2023.
//

import UIKit
import RxSwift

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

enum APIError: Error {
    case networkError(Error)
    case httpError(Int, String)
    case decodingError(Error)
}

struct APIErrorResponse: Codable {
    let path: String
    let error: String
    let message: String
    let status: Int
}

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = URL(string: "https://mobile-app.gespage.com:8443")!
    private let session = URLSession.shared
    private var authToken: String?
    
    func setAuthToken(token: String) {
        authToken = token
    }
    
    func performRequest<T: Decodable>(for path: String, method: HTTPMethod, parameters: [String: Any]?, responseType: T.Type) -> Observable<Result<T, APIError>> {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return Observable.just(.failure(.networkError(NSError(domain: "APIManager", code: -1, userInfo: nil))))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let authToken = authToken {
            request.setValue("Bearer \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let parameters = parameters {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        }
        
        return Observable.create { observer in
            let task = self.session.dataTask(with: request) { data, response, error in
                if let error = error {
                    observer.onNext(.failure(.networkError(error)))
                    observer.onCompleted()
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onNext(.failure(.networkError(NSError(domain: "APIManager", code: -1, userInfo: nil))))
                    observer.onCompleted()
                    return
                }
                
                let statusCode = httpResponse.statusCode
                if (200..<300).contains(statusCode), let data = data {
                    do {
                        let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                        observer.onNext(.success(decodedResponse))
                        observer.onCompleted()
                    } catch {
                        observer.onNext(.failure(.decodingError(error)))
                        observer.onCompleted()
                    }
                } else if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
                    if let apiErrorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                        let customError = APIError.httpError(apiErrorResponse.status, errorMessage)
                        observer.onNext(.failure(customError))
                    } else {
                        let defaultErrorMessage = "Request failed with status code: \(statusCode)"
                        let customError = APIError.httpError(statusCode, defaultErrorMessage)
                        observer.onNext(.failure(customError))
                    }
                    observer.onCompleted()
                } else {
                    let defaultErrorMessage = "Request failed with status code: \(statusCode)"
                    let customError = APIError.httpError(statusCode, defaultErrorMessage)
                    observer.onNext(.failure(customError))
                    observer.onCompleted()
                }
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}