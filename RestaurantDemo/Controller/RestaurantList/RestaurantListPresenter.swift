

import Foundation
import CoreLocation
class RestaurantListPresenter {
    
    private var repository: RestaurnatListReposistary
    private weak var delegate: RestaurantListDelegate?
    var restaurantArray = [RestaurantListModel]()
    
    var isApiInRuning: Bool = false
    var isApiFailer: Bool = false
    var nextPageToken: String = ""
    
    init(repository: RestaurnatListReposistary, delegate: RestaurantListDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    func getRestaurantListFromServer(location: String, radius: String,type:String){
        
        if isApiFailer || isApiInRuning { return }
        if nextPageToken.isEmpty && restaurantArray.count != 0 { return }
        
        self.delegate?.showLoader()
        isApiInRuning = true
        repository.searchRestaurant(location: location, radius: radius, type: type, token: nextPageToken, completion:{ [weak self] (success, result, errorMessage) in
            if let error = errorMessage {
                self?.delegate?.showError(withMessage: error)
                self?.isApiFailer = true
            }
            
            if success, let restaurantData = result as? ([RestaurantListModel], String) {
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
    
    
}

