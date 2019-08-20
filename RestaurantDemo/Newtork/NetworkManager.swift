
import Foundation
import Alamofire

struct NetworkManager {
    static func makeRequest(_ urlRequest: URLRequestConvertible, showLog: Bool = true, completion: @escaping (Result) -> ()) {
        Alamofire.request(urlRequest).responseJSON { responseObject in
            switch responseObject.result {
            case .success(let value):
                debugPrint("URL: \(urlRequest.urlRequest?.url?.absoluteString ?? "")")
                if (showLog) {
                    debugPrint("Request: \(urlRequest)")
                    debugPrint("Response: \(value)")
                }
                
                if let statusCode = responseObject.response?.statusCode {
                    switch statusCode {
                    case 200...300:
                        completion(.success(value))
                        return
                    default:
                        if let result = responseObject.result.value as? [String: Any],
                            let errorMessage = result["message"] as? String {
                         completion(.failure(errorMessage))
                        }
                    }
                }
            case .failure(let error):
                completion(.failure(error.localizedDescription))
            }
        }
    }
}

enum Result {
    case success(Any)
    case failure(String)
    
    var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    var isFailure: Bool {
        return !isSuccess
    }
    
    var value: Any? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    var error: String? {
        switch self {
        case .success:
            return nil
        case .failure(let error):
            return error
        }
    }
}
