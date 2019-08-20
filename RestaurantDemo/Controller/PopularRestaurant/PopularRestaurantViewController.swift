

import UIKit
import NVActivityIndicatorView

class PopularRestaurantViewController: UIViewController,NVActivityIndicatorViewable{

    @IBOutlet weak var closeButton: UIControl!
    @IBOutlet weak var categoryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchTextfield: UITextField!
    @IBOutlet weak var popularTableView: UITableView!
    
    var categoryName : String = "restaurant"
    var appendLatLong :String = ""
    
    lazy var presenter = PopularRestaurantPresenter(repository: PopularRestaurantReposistary(), delegate: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI()  {
        popularTableView.estimatedRowHeight = 100
        popularTableView.rowHeight = UITableView.automaticDimension
        let latitude = AppDelegate.shared.currentStoreLocation.latitude
        let longitude = AppDelegate.shared.currentStoreLocation.longitude
        appendLatLong = "\(latitude),\(longitude)"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    //MARK: IUButton action methods
    @IBAction func desertsClicked(_ sender: Any) {
        categoryName = "desert"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func bakeriesClicked(_ sender: Any) {
        categoryName = "bakeries"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func cafeClicked(_ sender: Any) {
        categoryName = "cafe"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func fastFoodClicked(_ sender: Any) {
        categoryName = "fastfood"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func groceryClicked(_ sender: Any) {
        categoryName = "groceries"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func restaurantClicked(_ sender: Any) {
        categoryName = "restaurant"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func polularClicked(_ sender: Any) {
        categoryName = "popular"
        presenter.getRestaurantListFromServer(location:appendLatLong, radius:"1500", type: categoryName)
    }
    
    @IBAction func closeClicked(_ sender: Any) {
        categoryViewHeightConstraint.constant = 0 ;
    }
    
    @IBAction func backClicked(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PopularRestaurantViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.restaurantArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == presenter.restaurantArray.count - 5 {
            let location = AppDelegate.shared.currentStoreLocation
            let appendLatLong = "\(location.latitude),\(location.longitude)"
            presenter.getRestaurantListFromServer(location: appendLatLong, radius: "1500", type: categoryName)
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PopularRestaurantCell", for: indexPath)
            as? PopularRestaurantCell {
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
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension PopularRestaurantViewController: PopularRestaurantDelegate {
    
    func showLoader() {
        self.startAnimating()
    }
    
    func hideLoader() {
        stopAnimating()
    }
    
    func showError(withMessage messge: String) {
        Constant.showAlert(title:  Constant.alertTitle, message: messge, viewController: self)
    }
    
    func restaurantResultPostedSuccessfully() {
        popularTableView.reloadData()
    }
}

extension PopularRestaurantViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        startAnimating()
        presenter.getRestaurantListFromServerwithkey(location: appendLatLong, radius:"1500", type: categoryName, key: searchTextfield.text!)
        return true
    }
}
