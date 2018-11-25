import UIKit

class UserProfileViewController: UIViewController {

  var user: User!

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()

    photoImageView.image = user.photo
    fullNameLabel.text = user.firstName + " " + user.lastName
    usernameLabel.text = user.username
  }

}
