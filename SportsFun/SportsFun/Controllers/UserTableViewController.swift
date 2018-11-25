import UIKit
import os.log

class UserTableViewController: UITableViewController {

  // MARK: - Properties

  var users = [User]()

  // MARK: - View Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    checkUsers()
    tableView.reloadData()
  }

  // MARK: - Table View Data Source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "UserTableViewCell"

    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell else {
      fatalError("The dequeued cell is not an instance of UserTableViewCell.")
    }

    let user = users[indexPath.row]

    cell.photoImageView.image = user.photo
    cell.fullNameLabel.text = user.firstName + " " + user.lastName
    cell.usernameLabel.text = user.username

    return cell
  }

  func checkUsers() {
    if (users.count == 0) {
      let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
      let messageLabel = UILabel(frame: rect)
      messageLabel.text = "Aucun résultat"
      messageLabel.textColor = .black
      messageLabel.numberOfLines = 0;
      messageLabel.textAlignment = .center;
      messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
      messageLabel.sizeToFit()

      tableView.backgroundView = messageLabel;
      tableView.separatorStyle = .none;
    } else {
      tableView.backgroundView = .none;
    }
  }

  // MARK: Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    guard let userProfileViewController = segue.destination as? UserProfileViewController else {
      fatalError("Unexpected destination: \(segue.destination)")
    }

    guard let selectedUserCell = sender as? UserTableViewCell else {
      fatalError("Unexpected sender: \(sender)")
    }

    guard let indexPath = tableView.indexPath(for: selectedUserCell) else {
      fatalError("The selected cell is not being displayed by the table")
    }

    let selectedUser = users[indexPath.row]
    userProfileViewController.user = selectedUser
  }

}
