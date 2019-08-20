
import UIKit
import HCSStarRatingView

class PopularRestaurantCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var ratingView: HCSStarRatingView!
    @IBOutlet weak var imageRestaurant: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureData(forIndex index: Int, data: RestaurantListModel) {
        nameLabel.text = (data.name ?? "")
        if let url = data.restaurantImageurl {
            imageRestaurant.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "ic-Placeholder"))
        }
        priceLabel.text = (data.types ?? "") + " \(data.priceLevel?.description ?? "") $"
        ratingView.isUserInteractionEnabled = false
        ratingView.value = CGFloat(data.rating ?? 0)
        ratingLabel.text = (data.userRatingsTotal?.description ?? "") + " review on Google"
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
