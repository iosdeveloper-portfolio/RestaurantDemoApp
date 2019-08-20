

import Foundation
import Alamofire

public enum RestaurantRouter: URLRequestConvertible {
    
    case searchRestaurant(location: String, radius: String, type: String, token: String)
    case searchRestaurantwithkey(location: String, radius: String,type: String,key:String)
    case searchPlaces(placeid: String)
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .searchRestaurant, .searchRestaurantwithkey, .searchPlaces:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .searchRestaurant(let location, let radius,let type, let token):
            if token.isEmpty {
                return "location=\(location)&radius=\(radius)&type=\(type)&key=\(Constant.kGoogleDirectionAPI)"
            }
            else {
                return "location=\(location)&radius=\(radius)&type=\(type)&key=\(Constant.kGoogleDirectionAPI)&pagetoken=\(token)"
            }
        case .searchRestaurantwithkey(let location, let radius, let type, let key):
            if let urlKey = key.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) {
                return "location=\(location)&radius=\(radius)&type=\(type)&key=\(Constant.kGoogleDirectionAPI)&keyword=\(urlKey)"
            }
            return "location=\(location)&radius=\(radius)&type=\(type)&key=\(Constant.kGoogleDirectionAPI)"
        case .searchPlaces(let placeid):
            return "placeid=\(placeid)&key=\(Constant.kGoogleDirectionAPI)"
        }
    }
    
    var jsonParameters: [String: Any]? {
        switch self {
        case .searchRestaurant, .searchPlaces:
            return nil
        case .searchRestaurantwithkey:
            return nil
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        
        var url:URL?
        
        switch self {
        case .searchRestaurant, .searchRestaurantwithkey:
            url = URL(string: "https://maps.googleapis.com/maps/api/place/nearbysearch/json?" + self.path)
        case .searchPlaces:
            url = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?" + self.path)
        }
        var urlRequest = URLRequest(url: url!)
        
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        switch self {
        case .searchRestaurant, .searchRestaurantwithkey, .searchPlaces:
            return try URLEncoding.queryString.encode(urlRequest, with: self.jsonParameters)
        }
    }
}
