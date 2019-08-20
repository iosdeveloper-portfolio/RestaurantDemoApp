
import Foundation
protocol PlaceDetailDelegate: class {
    func showLoader()
    func hideLoader()
    func showError(withMessage messge: String)
    func placePostedSuccessfully()
}
