
import Foundation

class RestaurantListModel {
    
    var name: String?
    var description: String?
    var rating: Double?
    var restaurantImageurl: String?
    var placeId: String?
    var compoundCode: String?
    var types: String?
    var priceLevel: Float?
    var lat: Double?
    var long: Double?
    var userRatingsTotal: Float?
    var errorMessage: String?

    init(jsonData: [String:Any]) {
        
        if let name = jsonData["name"] as? String {
            self.name = name
        }
        
        if let imageData = jsonData["photos"] as? [[String:Any]] {
            if let url = imageData[0]["photo_reference"] as? String {
                self.restaurantImageurl = "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=\(url)&key=\(Constant.kGoogleDirectionAPI)"
            }
        }
        
        if let plusCode = jsonData["plus_code"] as? [String:Any] {
            if let compound_code = plusCode["compound_code"] as? String {
                self.compoundCode = compound_code
            }
        }
        
        if let geometry = jsonData["geometry"] as? [String:Any] {
            if let location = geometry["location"] as? [String:Any] {
                if let lat = location["lat"] as? Double {
                    self.lat = lat
                }
                if let long = location["lng"] as? Double {
                    self.long = long
                }
            }
        }
        
        if let types = jsonData["types"] as? [String] {
            print(types)
            self.types = types[1]
        }
        
        if let priceLevel = jsonData["price_level"] as? Float {
            self.priceLevel = priceLevel
        }
        
        if let rating = jsonData["rating"] as? Double {
            self.rating = rating
        }
        
        if let userRatingsTotal = jsonData["user_ratings_total"] as? Float {
            self.userRatingsTotal = userRatingsTotal
        }
        
        if let description = jsonData["vicinity"] as? String {
            self.description = description
        }
        if let placeId = jsonData["place_id"] as? String {
            self.placeId = placeId
        }
        
        if let errorMessage = jsonData["error_message"] as? String {
            self.errorMessage = errorMessage
        }
    }
}
