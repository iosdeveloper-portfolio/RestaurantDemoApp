

import UIKit
import HCSStarRatingView
import SDWebImage
import CoreLocation

class RestaurantListCell: UITableViewCell {
    
    @IBOutlet weak var restaurantImageView: UIImageView!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var smallDescLabel: UILabel!
    @IBOutlet weak var amountButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(forIndex index: Int, data: RestaurantListModel) {
        nameLabel.text = (data.name ?? "")
        if let url = data.restaurantImageurl {
            restaurantImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic-Placeholder"))
        }
        descriptionLabel.text = (data.description ?? "")
        ratingView.value = CGFloat(data.rating ?? 0)
        ratingLabel.text = data.rating?.description
        let userLocation = CLLocation(latitude: AppDelegate.shared.currentStoreLocation.latitude, longitude: AppDelegate.shared.currentStoreLocation.longitude)
        if let lat = data.lat, let long = data.long {
            let coordinate₁ = CLLocation(latitude: lat, longitude: long)
            distanceLabel.text = String(format: "%.2f km", userLocation.distance(from: coordinate₁)/1000)
        }
        else {
            distanceLabel.text = ""
        }
        
         if let priceLevel = data.priceLevel {
            amountButton.isHidden = false
            amountButton.setTitle(priceLevel.description + " $", for:.normal)
        }
        smallDescLabel.text = (data.compoundCode ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
