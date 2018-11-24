import UIKit
import os.log

class UserTableViewController: UITableViewController {

  var users = [User]()

  override func viewDidLoad() {
    super.viewDidLoad()

    loadUsers()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    tableView.reloadData()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "UserTableViewCell"
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserTableViewCell  else {
      fatalError("The dequeued cell is not an instance of UserTableViewCell.")
    }

    let user = users[indexPath.row]

    cell.photoImageView.image = user.photo
    cell.fullNameLabel.text = user.firstName + " " + user.lastName
    cell.usernameLabel.text = user.username

    return cell
  }

  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */

  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */

  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

   }
   */

  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

  // MARK: Private Methods

  private func loadUsers() {
    let photo1 = UIImage(named: "defaultPhoto")
    let photo2 = UIImage(named: "defaultPhoto")

    guard let user1 = User(firstName: "Anthony", lastName: "Riquet", username: "antho", photo: photo1) else {
      fatalError("Unable to instantiate conversation1")
    }

    guard let user2 = User(firstName: "Marie", lastName: "Rivière", username: "marie974", photo: photo2) else {
      fatalError("Unable to instantiate conversation1")
    }

    users += [user1, user2]
  }
}
