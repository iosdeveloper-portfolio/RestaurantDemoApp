
import Foundation

typealias CompletionBlockPlaceManager = (_ success: Bool, _ response: Any?, _ errorMessage: String?) -> Void

class PlaceManager {
    
    static let shared = PlaceManager()
    
    func searchPlacedetail(route: RestaurantRouter, completion: @escaping CompletionBlockPlaceManager) {
        NetworkManager.makeRequest(route) { (result) in
            switch result {
            case .success(let value):
                var placeDetailModel: PlaceDetailModel?
                var errorMessage: String? = nil
                
                if let jsonResult = value as? [String : Any], let objects = jsonResult["result"] as? [String: Any] {
                    placeDetailModel = PlaceDetailModel(jsonData: objects)
                }
                
                if let jsonResult = value as? [String : Any], let error = jsonResult["error_message"] as? String {
                    errorMessage = error
                }

                completion(true, placeDetailModel, errorMessage)
                
            case .failure(let error):
                completion(false, error, error.description)
            }
        }
    }
}

