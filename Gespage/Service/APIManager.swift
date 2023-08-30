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
    private let sessionDelegate = SessionDelegate()
    
    let baseURL = URL(string: "https://mobile-app.gespage.com:8443")!
    
    // Lấy accessToken từ Local Storage
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    // Lưu accessToken vào Local Storage
    private func saveAccessToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "accessToken")
    }
    
    private func deleteAccessToken() {
        UserDefaults.standard.removeObject(forKey: "accessToken")
        UserDefaults.standard.synchronize()
    }
    
    func deleteCookies() {
        let storage = HTTPCookieStorage.shared
        
        if let cookies = storage.cookies {
            for cookie in cookies {
                storage.deleteCookie(cookie)
            }
        }
        deleteAccessToken()
    }
    
    func performRequest<T: Decodable>(
        for path: String,
        method: HTTPMethod,
        requestModel: Encodable? = nil,
        responseType: T.Type
    ) -> Observable<Result<T, APIError>> {
        guard let url = URL(string: path, relativeTo: baseURL) else {
            return Observable.just(.failure(.networkError(NSError(domain: "APIManager", code: -1, userInfo: nil))))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let accessToken = accessToken {
            request.setValue(accessToken, forHTTPHeaderField: "cookie")
        }
        
        if let requestModel = requestModel {
            // Sử dụng JSONEncoder để mã hóa requestModel thành JSON data
            let encoder = JSONEncoder()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try? encoder.encode(requestModel)
        }
        
        return Observable.create { observer in
            let session = URLSession(configuration: .default, delegate: self.sessionDelegate, delegateQueue: nil)
            let task = session.dataTask(with: request) { data, response, error in
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
                
                if let cookieHeader = httpResponse.allHeaderFields["Set-Cookie"] as? String {
                    if let accessToken = cookieHeader.components(separatedBy: "; ").first {
                        self.saveAccessToken(accessToken)
                    } else {
                        self.deleteCookies()
                    }
                }
                
                let statusCode = httpResponse.statusCode
                if (200..<300).contains(statusCode), let data = data {
                    do {
                        if let responseDataString = String(data: data, encoding: .utf8), T.self == String.self {
                            observer.onNext(.success(responseDataString as! T))
                        } else {
                            let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                            observer.onNext(.success(decodedResponse))
                        }
                    } catch {
                        observer.onNext(.failure(.decodingError(error)))
                    }
                    observer.onCompleted()
                }
                else if let data = data, let errorMessage = String(data: data, encoding: .utf8) {
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

    func showError(
        in viewController: UIViewController,
        title: String? = "Error",
        msg: String? = nil,
        error: APIError
    ) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .alert)
                
        switch error {
        case .networkError(let underlyingError):
            alertController.message = "Network error: \(underlyingError.localizedDescription)"
            
        case .httpError(_, let message):
            if let apiErrorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: message.data(using: .utf8)!) {
                alertController.message = msg ?? apiErrorResponse.message
            } else {
                alertController.message = "HTTP error: \(message)"
            }
            
        case .decodingError(let decodingError):
            alertController.message = "Decoding error: \(decodingError.localizedDescription)"
        }
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func logError(error: APIError) {
        if case .httpError(_, let message) = error,
           let apiErrorResponse = try? JSONDecoder().decode(APIErrorResponse.self, from: message.data(using: .utf8)!) {
            print("API Error Message: \(apiErrorResponse.message)")
        } else if case .decodingError(let decodingError) = error {
            print("Decoding error: \(decodingError.localizedDescription)")
        } else {
            print("Network error: \(error.localizedDescription)")
        }
    }
}

class SessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            if let serverTrust = challenge.protectionSpace.serverTrust {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
            }
        } else {
            completionHandler(.performDefaultHandling, nil)
        }
    }
}
