import UIKit

class UserProfileViewController: UIViewController {

  var user: User!

  @IBOutlet weak var photoImageView: UIImageView!
  @IBOutlet weak var fullNameLabel: UILabel!
  @IBOutlet weak var usernameLabel: UILabel!
  @IBOutlet weak var followButton: UIButton!

  @IBAction func followButtonTapped(_ sender: Any) {
    do {
      followButton.isEnabled = false
      try SessionNetworking.put(url: SportsFunAPI.userFollow(id: user.id), jsonObject: [:], completionHandler: {
        (jsonObject: [String: Any]) -> Void in
        print(jsonObject)
        if let success = jsonObject["Success"] as? Bool, !success {
          DispatchQueue.main.async {
            self.followButton.isEnabled = true
          }
        } else if let success = jsonObject["success"] as? Bool, success {
          DispatchQueue.main.async {
            if self.followButton.title(for: .normal) == "Suivre" {
              self.followButton.setTitle("Ne plus suivre", for: .normal)
            } else {
              self.followButton.setTitle("Suivre", for: .normal)
            }
          }
        }
        DispatchQueue.main.async {
          self.followButton.isEnabled = true
        }
      }, withToken: true)
    } catch {
      print(error)
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    photoImageView.image = user.photo
    fullNameLabel.text = user.firstName + " " + user.lastName
    usernameLabel.text = user.username
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    let destinationNavigationController = segue.destination as! UINavigationController

    guard let newConversationTableViewController = destinationNavigationController.topViewController as? NewConversationViewController else {
      fatalError("Unexpected destination: \(segue.destination)")
    }

    newConversationTableViewController.userId = user.id
  }

}
