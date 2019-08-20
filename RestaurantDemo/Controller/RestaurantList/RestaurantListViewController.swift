

import UIKit
import CoreLocation
import NVActivityIndicatorView

class RestaurantListViewController: UIViewController, NVActivityIndicatorViewable {
    
    @IBOutlet weak var restaurantTable: UITableView!
    
    var locationManager = CLLocationManager()
    
    lazy var presenter = RestaurantListPresenter(repository: RestaurnatListReposistary(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getlocation()
    }
    
    func setupUI()  {
        self.navigationController?.navigationBar.isHidden = true
        restaurantTable.estimatedRowHeight = 300
        restaurantTable.rowHeight = UITableView.automaticDimension
    }
    
    func getlocation(){
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
    }
    
    //MARK: UIButton action methods
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchButton(_ sender: Any) {
        let objHome = self.storyboard?.instantiateViewController(withIdentifier: "PopularRestaurantViewController") as! PopularRestaurantViewController
        self.navigationController?.pushViewController(objHome, animated: true)
    }
}

extension RestaurantListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.restaurantArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //Pagination
        if indexPath.row == presenter.restaurantArray.count - 5 {
            let location = AppDelegate.shared.currentStoreLocation
            let appendLatLong = "\(location.latitude),\(location.longitude)"
            presenter.getRestaurantListFromServer(location: appendLatLong, radius: "1500", type: "restaurant")
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantListCell", for: indexPath)
            as? RestaurantListCell {
            cell.ratingView.isUserInteractionEnabled = false
            cell.ratingView.allowsHalfStars = true
            cell.ratingView.accurateHalfStars = true
            cell.configureData(forIndex: indexPath.row, data: presenter.restaurantArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let restaurantDetail = presenter.restaurantArray[indexPath.row]
        let placeDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "PlaceDetailViewController") as! PlaceDetailViewController
        placeDetailViewController.getPlaceid = (restaurantDetail.placeId ?? "")
        self.navigationController?.pushViewController(placeDetailViewController, animated: true)
        restaurantTable.deselectRow(at: indexPath, animated: true)
    }
}

extension RestaurantListViewController :RestaurantListDelegate {
    
    func showLoader() {
        startAnimating()
    }
    
    func hideLoader() {
        stopAnimating()
    }
    
    func showError(withMessage messge: String) {
        Constant.showAlert(title:  Constant.alertTitle, message: messge, viewController: self)
    }
    
    func restaurantResultPostedSuccessfully() {
        restaurantTable.reloadData()
    }
}

extension RestaurantListViewController: CLLocationManagerDelegate {

    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location: CLLocation = locations.last {
            AppDelegate.shared.currentStoreLocation = location.coordinate
            let appendLatLong = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
            presenter.getRestaurantListFromServer(location: appendLatLong, radius: "1500", type: "restaurant")
            restaurantTable.reloadData()
        }
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
        // Display the map using the default location.
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        @unknown default:
            break
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
}

