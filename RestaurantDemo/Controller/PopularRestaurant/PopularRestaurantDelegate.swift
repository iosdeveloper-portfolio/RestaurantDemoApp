
import Foundation

protocol PopularRestaurantDelegate: class {
    func showLoader()
    func hideLoader()
    func showError(withMessage messge: String)
    func restaurantResultPostedSuccessfully()
}
