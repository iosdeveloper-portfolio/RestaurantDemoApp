
import Foundation

struct PlaceDetailReposistary {
    
    func searchPlacedetail(placeid:String ,completion: @escaping CompletionBlock){
        let route = RestaurantRouter.searchPlaces(placeid: placeid)
        PlaceManager.shared.searchPlacedetail(route: route, completion: completion)
    }

}
