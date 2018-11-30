import UIKit

class ConversationTableViewCell: UITableViewCell {

  // MARK: Properties

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var contentLabel: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.width / 2
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
