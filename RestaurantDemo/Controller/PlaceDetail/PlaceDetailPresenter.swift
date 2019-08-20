
import Foundation

class PlaceDetailPresenter {
    
    private var repository: PlaceDetailReposistary
    private weak var delegate: PlaceDetailDelegate?
    var placeDataArray: PlaceDetailModel?
    
    init(repository: PlaceDetailReposistary, delegate: PlaceDetailDelegate) {
        self.repository = repository
        self.delegate = delegate
    }
    
    func getPlacedetail(placeId: String){
        self.delegate?.showLoader()
        repository.searchPlacedetail(placeid: placeId, completion:{ [weak self] (success, result, errorMessage) in
            if let error = errorMessage {
                self?.delegate?.showError(withMessage: error)
            }
            else if success, let restaurantData = result as? PlaceDetailModel {
                self?.placeDataArray = restaurantData
                self?.delegate?.placePostedSuccessfully()
            } else {
                if let errorString = result as? String {
                    self?.delegate?.showError(withMessage: errorString)
                }
            }
            self?.delegate?.hideLoader()
        })
    }
    
}

