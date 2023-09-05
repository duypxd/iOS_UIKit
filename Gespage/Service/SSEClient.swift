import RxSwift
import RxCocoa

struct SSEData: Codable {
    let id: String?
    let data: String?
    let event: String?
    let retry: Int?
}

enum SSEError: Error {
    case networkError(Error)
    case decodingError(Error)
    case invalidSSEData
}

class SSEClient {
    static let shared = SSEClient()
    
    let disposed = DisposeBag()
    private let session: URLSession
    private let sessionDelegate = SessionDelegate()
    private var cancellables: [Disposable] = []
    private let sseEventSubject = PublishRelay<Result<SSEData, SSEError>>()

    var sseEventObservable: Observable<Result<SSEData, SSEError>> {
        return sseEventSubject.asObservable()
    }

    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "accessToken")
    }
    
    init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.requestCachePolicy = .useProtocolCachePolicy
        
        self.session = URLSession(configuration: sessionConfiguration, delegate: self.sessionDelegate, delegateQueue: nil)
    }

    func startListening(for path: String) {
        guard let url = URL(string: path, relativeTo: APIManager.shared.baseURL) else {
            return
        }

        var request = URLRequest(url: url)
        
        if let accessToken = accessToken {
            request.setValue(accessToken, forHTTPHeaderField: "cookie")
        }
        
        let disposable = session.rx
            .response(request: request)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] response, data in
                guard let self = self else { return }

                if let sseData = self.parseSSEData(from: data) {
                    self.sseEventSubject.accept(.success(sseData))
                }
            }, onError: { [weak self] error in
                guard let self = self else { return }

                self.sseEventSubject.accept(.failure(.networkError(error)))
            })

        disposable.disposed(by: disposed)
        cancellables.append(disposable)
    }

    func stopListening() {
        for disposable in cancellables {
            disposable.dispose()
        }
        cancellables.removeAll()
    }

    private func parseSSEData(from data: Data) -> SSEData? {
        if let sseString = String(data: data, encoding: .utf8) {
            var id: String?
            var data: String?
            var event: String?
            var retry: Int?

            for line in sseString.components(separatedBy: "\n") {
                let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)

                if trimmedLine.isEmpty {
                    // Ignore empty lines
                    continue
                }

                if trimmedLine.hasPrefix("id:") {
                    id = String(trimmedLine.dropFirst(3))
                } else if trimmedLine.hasPrefix("data:") {
                    data = String(trimmedLine.dropFirst(5))
                } else if trimmedLine.hasPrefix("event:") {
                    event = String(trimmedLine.dropFirst(6))
                } else if trimmedLine.hasPrefix("retry:") {
                    retry = Int(String(trimmedLine.dropFirst(6)))
                }
            }

            return SSEData(id: id, data: data, event: event, retry: retry)
        }

        return nil
    }
}
