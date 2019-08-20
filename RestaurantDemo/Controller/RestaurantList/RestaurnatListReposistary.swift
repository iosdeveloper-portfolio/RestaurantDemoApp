

import Foundation
struct RestaurnatListReposistary {
    
    func searchRestaurant(location: String, radius: String, type: String, token: String, completion: @escaping CompletionBlock){
        let router: RestaurantRouter = .searchRestaurant(location: location, radius: radius, type: type, token: token)
        RestaurantListManager.shared.searchRestaurant(router: router, completion: completion)
    }
    
}
