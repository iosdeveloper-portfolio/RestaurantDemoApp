
import UIKit
import KSImageCarousel
import DKPhotoGallery
import NVActivityIndicatorView
import HCSStarRatingView

class PlaceDetailViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var totalRatingLabel: UILabel!
    @IBOutlet weak var caroselView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    
    var getPlaceid : String = ""
    lazy var presenter = PlaceDetailPresenter(repository: PlaceDetailReposistary(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getPlacedetail(placeId: getPlaceid)
    }
    
    @IBAction func backButtonClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func bind() {
        placeNameLabel.text = presenter.placeDataArray?.name
        addressLabel.text = presenter.placeDataArray?.address
        totalRatingLabel.text = presenter.placeDataArray?.rating?.description
        phoneNumberLabel.text = presenter.placeDataArray?.phoneNumber?.description
        ratingView.isUserInteractionEnabled = false
        ratingView.value = CGFloat(presenter.placeDataArray?.rating ?? 0.0)
        
        if let coordinator = try? KSICFiniteCoordinator(with: presenter.placeDataArray?.placePhotos ?? [], placeholderImage: UIImage(named: "ic-Placeholder"), initialPage: 0) {
            coordinator.activityIndicatorStyle = .white
            coordinator.showCarousel(inside: caroselView, of: self)
            coordinator.delegate = self
        }
    }
}

extension PlaceDetailViewController :PlaceDetailDelegate {
    
    func showLoader() {
        startAnimating()
    }
    
    func hideLoader() {
        stopAnimating()
    }
    
    func showError(withMessage messge: String) {
        Constant.showAlert(title: Constant.alertTitle, message: messge, viewController: self)
    }
    
    func placePostedSuccessfully() {
        stopAnimating()
        self.bind()
    }
}

extension PlaceDetailViewController: KSICCoordinatorDelegate {
    func carouselDidTappedImage(at index: Int, coordinator: KSICCoordinator) {
        self.openFullGalaryView(index: index)
    }
    
    func openFullGalaryView(index: Int) {
        let gallery = DKPhotoGallery()
        gallery.singleTapMode = .dismiss
        gallery.items = (presenter.placeDataArray?.placePhotos ?? []).map {
            DKPhotoGalleryItem(imageURL: $0)
        }
        gallery.presentationIndex = index
        
        self.present(photoGallery: gallery)
    }
}
