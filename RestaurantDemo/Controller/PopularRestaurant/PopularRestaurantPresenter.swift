

import Foundation
import CoreLocation
class PopularRestaurantPresenter {
    
    private var repository: PopularRestaurantReposistary
    private weak var delegate: PopularRestaurantDelegate?
    
    var restaurantArray = [RestaurantListModel]()
    
    var isApiInRuning: Bool = false
    var isApiFailer: Bool = false
    var isTokenExpire:Bool = false
    var nextPageToken: String = ""
    var category: String = ""
    
    init(repository: PopularRestaurantReposistary, delegate: PopularRestaurantDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    func getRestaurantListFromServerwithkey(location: String, radius: String,type:String,key:String) {
        self.clearAllDetails(category: type)
        if !key.isEmpty { self.clearAllDetails(category: "")}
        
        if isApiFailer || isApiInRuning {
            return
        }
        if nextPageToken.isEmpty && restaurantArray.count != 0 { return }
        
        self.delegate?.showLoader()
        isApiInRuning = true
        
        repository.searchRestaurant(location: location, radius: radius, type: type, key: key, completion:{ [weak self] (success, result, errorMessage) in
            if let error = errorMessage {
                self?.delegate?.showError(withMessage: error)
                self?.isTokenExpire = true
            }
            else if success, let restaurantData = result as? ([RestaurantListModel], String) {
                self?.restaurantArray.append(contentsOf: restaurantData.0)
                self?.delegate?.restaurantResultPostedSuccessfully()
                self?.nextPageToken = restaurantData.1
            } else {
                if let errorString = result as? String {
                    self?.delegate?.showError(withMessage: errorString)
                }
                self?.isApiFailer = true
            }
            self?.delegate?.hideLoader()
            self?.isApiInRuning = false
        })
    }
    
    func getRestaurantListFromServer(location: String, radius: String,type:String) {
        self.clearAllDetails(category: type)
        
        if isTokenExpire || isApiInRuning { return }
        if nextPageToken.isEmpty && restaurantArray.count != 0 { return }
        
        self.delegate?.showLoader()
        isApiInRuning = true
        
        repository.searchRestaurant(location: location, radius: radius, type: type, token: self.nextPageToken, completion:{ [weak self] (success, result, errorMessage) in
            if let error = errorMessage {
                self?.delegate?.showError(withMessage: error)
                self?.isTokenExpire = true
            }
            else if success, let restaurantData = result as? ([RestaurantListModel], String) {
                self?.restaurantArray.append(contentsOf: restaurantData.0)
                self?.delegate?.restaurantResultPostedSuccessfully()
                self?.nextPageToken = restaurantData.1
            } else {
                if let errorString = result as? String {
                    self?.delegate?.showError(withMessage: errorString)
                }
                self?.isTokenExpire = true
            }
            self?.delegate?.hideLoader()
            self?.isApiInRuning = false
        })
    }
    
    private func clearAllDetails(category: String) {
        if self.category != category || category.isEmpty {
            isApiInRuning = false
            isApiFailer = false
            nextPageToken = ""
            restaurantArray.removeAll()
        }
        if !category.isEmpty {
            self.category = category
        }
    }
}

