

import Foundation
struct PopularRestaurantReposistary {
    
    func searchRestaurant(location:String ,radius:String,type:String,key:String,completion: @escaping CompletionBlock){
        let router: RestaurantRouter = .searchRestaurantwithkey(location: location, radius: radius, type: type, key: key)
        RestaurantListManager.shared.searchRestaurantWithkey(router: router, completion: completion)
    }
    
    func searchRestaurant(location: String, radius: String, type: String, token: String, completion: @escaping CompletionBlock){
        let router: RestaurantRouter = .searchRestaurant(location: location, radius: radius, type: type, token: token)
        RestaurantListManager.shared.searchRestaurant(router: router, completion: completion)
    }
}
