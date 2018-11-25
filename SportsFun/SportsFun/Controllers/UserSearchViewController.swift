import UIKit

class UserSearchViewController: UIViewController {

  // MARK: Properties

  var showSearchResultsSegueIdentifier = "ShowSearchResults"

  @IBOutlet weak var searchTextField: UITextField!

  // MARK: Navigation

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: Actions

  @IBAction func searchButtonTapped(_ sender: UIButton) {
    if let username = searchTextField.text, username.count > 3 {
      performSegue(withIdentifier: showSearchResultsSegueIdentifier, sender: sender)
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == showSearchResultsSegueIdentifier {
      if let username = searchTextField.text, username.count > 2 {
        guard let userSearchResultsTableViewController = segue.destination as? UserSearchResultsTableViewController else {
          fatalError("Unexpected destination: \(segue.destination)")
        }

        var users = [User]()

        // TODO: Do that in the segue action
        do {
          try SessionNetworking.get(url: SportsFunAPI.userSearch(username: username), completionHandler: {
            (jsonObject: Any) -> Void in
            if let results = jsonObject as? [[String: Any]] {
              for result in results {
                do {
                  let photoUrl = (result["profilePic"] as! String).hasPrefix("/") ? SportsFunAPI.baseURL?.appendingPathComponent(result["profilePic"] as! String) : URL(string: result["profilePic"] as! String)
                  let photoData = try Data(contentsOf: photoUrl!)
                  guard let user = User(firstName: result["firstName"] as! String, lastName: result["lastName"] as! String, username: result["username"] as! String, photo: UIImage(data: photoData)) else {
                    fatalError("Unable to instantiate user")
                  }
                  users.append(user)
                } catch {
                  print(error)
                }
              }
            }
            userSearchResultsTableViewController.users = users
          }, withToken: true)
        } catch {
          print(error)
          userSearchResultsTableViewController.users = []
        }
      }
    }
  }

}
