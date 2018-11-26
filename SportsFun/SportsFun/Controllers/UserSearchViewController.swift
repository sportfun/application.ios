import UIKit

class UserSearchViewController: UIViewController {

  // MARK: Properties

  let showSearchResultsSegueIdentifier = "ShowSearchResults"
  var results = [User]()

  @IBOutlet weak var searchTextField: UITextField!

  // MARK: Navigation

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

  // MARK: Actions

  @IBAction func searchButtonTapped(_ sender: UIButton) {
    if let username = searchTextField.text, username.count > 2 {
      self.results.removeAll()
      do {
        try SessionNetworking.get(url: SportsFunAPI.userSearch(username: username), completionHandler: {
          (jsonObject: [String: Any]) -> Void in
          if let results = jsonObject["data"] as? [[String: Any]] {
            for result in results {
              do {
                var photo = UIImage(named: "defaultPhoto")
                if let photoURLString = result["profilePic"] as? String, photoURLString.count > 2 {
                  if (photoURLString.hasPrefix("/")) {
                    let photoData = try Data(contentsOf: SportsFunAPI.baseURL!.appendingPathComponent(photoURLString))
                    photo = UIImage(data: photoData)
                  } else {
                    let photoData = try Data(contentsOf: URL(string: photoURLString)!)
                    photo = UIImage(data: photoData)
                  }
                }
                guard let user = User(id: result["_id"] as! String, firstName: result["firstName"] as! String, lastName: result["lastName"] as! String, username: result["username"] as! String, photo: photo) else {
                  fatalError("Unable to instantiate user")
                }
                self.results.append(user)
              } catch {
                print(error)
              }
            }
            DispatchQueue.main.async {
              self.performSegue(withIdentifier: self.showSearchResultsSegueIdentifier, sender: sender)
            }
          }
        }, withToken: true)
      } catch {
        print(error)
      }
    }
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    if segue.identifier == showSearchResultsSegueIdentifier {
      guard let userSearchResultsTableViewController = segue.destination as? UserSearchResultsTableViewController else {
        fatalError("Unexpected destination: \(segue.destination)")
      }

      userSearchResultsTableViewController.users = results
    }
  }

}
