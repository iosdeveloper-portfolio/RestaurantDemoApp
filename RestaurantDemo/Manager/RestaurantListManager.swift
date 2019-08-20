    
import Foundation

    typealias CompletionBlock = (_ success: Bool, _ response: Any?, _ errorMessage: String?) -> Void

class RestaurantListManager {
        
    static let shared = RestaurantListManager()
    
    func searchRestaurant(router: RestaurantRouter, completion: @escaping CompletionBlock) {
        NetworkManager.makeRequest(router) { (result) in
            switch result {
            case .success(let value):
                var restaurantModels: [RestaurantListModel] = []
                var nextPageToken: String = ""
                var errorMessage: String? = nil
                
                if let jsonResult = value as? [String : Any] {
                    if let objects = jsonResult["results"] as? [[String: Any]] {
                        for object in objects {
                            let giphyobject = RestaurantListModel(jsonData: object)
                            restaurantModels.append(giphyobject)
                        }
                    }
                
                    if let token = jsonResult["next_page_token"] as? String {
                        nextPageToken = token
                    }
                    if let error = jsonResult["error_message"] as? String {
                        errorMessage = error
                    }
                }
                completion(true, (restaurantModels, nextPageToken), errorMessage)
                
            case .failure(let error):
                completion(false, error, error.description)
            }
        }
    }
    
    func searchRestaurantWithkey(router: RestaurantRouter, completion: @escaping CompletionBlock) {
        NetworkManager.makeRequest(router) { (result) in
            switch result {
            case .success(let value):
                var restaurantModels: [RestaurantListModel] = []
                var nextPageToken: String = ""
                var errorMessage: String? = nil

                if let jsonResult = value as? [String : Any] {
                    if let objects = jsonResult["results"] as? [[String: Any]] {
                        for object in objects {
                            let giphyobject = RestaurantListModel(jsonData: object)
                            restaurantModels.append(giphyobject)
                        }
                    }
                    
                    if let token = jsonResult["next_page_token"] as? String {
                        nextPageToken = token
                    }
                    
                    if let error = jsonResult["error_message"] as? String {
                        errorMessage = error
                    }
                }
                completion(true, (restaurantModels, nextPageToken), errorMessage)
                
            case .failure(let error):
                completion(false, error, error.description)
            }
        }
    }
}
