
import Foundation

class PlaceDetailModel {
    
    var name: String?
    var address: String?
    var rating: Double?
    var phoneNumber: Double?
    var placePhotos: [URL] = []
    
    init(jsonData: [String:Any]) {
        
        if let name = jsonData["name"] as? String {
            self.name = name
        }
        if let address = jsonData["formatted_address"] as? String {
            self.address = address
        }
        if let rating = jsonData["rating"] as? Double {
            self.rating = rating
        }
        if let phoneNumber = jsonData["formatted_phone_number"] as? Double {
            self.phoneNumber = phoneNumber
        }
        
        if let imageData = jsonData["photos"] as? [[String:Any]] {
            for imageRef in imageData {
                if let urlString = imageRef["photo_reference"] as? String,
                    let url = URL(string: "https://maps.googleapis.com/maps/api/place/photo?maxwidth=800&photoreference=\(urlString)&key=\(Constant.kGoogleDirectionAPI)"){
                    self.placePhotos.append(url)
                }
            }
        }
    }
}
