
import Foundation

protocol RestaurantListDelegate: class {
    func showLoader()
    func hideLoader()
    func showError(withMessage messge: String)
    func restaurantResultPostedSuccessfully()
}
