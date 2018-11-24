import UIKit
import os.log

class ConversationTableViewController: UITableViewController {

  var conversations = [Conversation]()

  override func viewDidLoad() {
    super.viewDidLoad()

    loadConversations()
  }

  // MARK: - Table view data source

  override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return conversations.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "ConversationTableViewCell"

    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationTableViewCell  else {
      fatalError("The dequeued cell is not an instance of ConversationTableViewCell.")
    }

    let conversation = conversations[indexPath.row]

    cell.nameLabel.text = conversation.recipient.firstName
    cell.photoImageView.image = conversation.recipient.photo
    cell.messages = conversation.messages

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

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)

    switch(segue.identifier ?? "") {
    case "CreateConversation":
      os_log("Adding a new conversation.", log: OSLog.default, type: .debug)
    case "ShowConversation":
      guard let conversationViewController = segue.destination as? ConversationViewController else {
        fatalError("Unexpected destination: \(segue.destination)")
      }

      guard let selectedConversationCell = sender as? ConversationTableViewCell else {
        fatalError("Unexpected sender: \(sender)")
      }

      guard let indexPath = tableView.indexPath(for: selectedConversationCell) else {
        fatalError("The selected cell is not being displayed by the table")
      }

      let selectedConversation = conversations[indexPath.row]
      conversationViewController.conversation = selectedConversation
    default:
      fatalError("Unexpected Segue Identifier; \(segue.identifier)")
    }
  }

  // MARK: Private Methods

  private func loadConversations() {
    let photo1 = UIImage(named: "defaultPhoto")
    let photo2 = UIImage(named: "defaultPhoto")

    let user1 = User(firstName: "Anthony", lastName: "Riquet", username: "antho", photo: photo1)
    let user2 = User(firstName: "Marie", lastName: "Rivière", username: "marie974", photo: photo2)

    guard let conversation1 = Conversation(recipient: user1!, messages: [Message]()) else {
      fatalError("Unable to instantiate conversation1")
    }

    guard let conversation2 = Conversation(recipient: user2!, messages: [Message]()) else {
      fatalError("Unable to instantiate conversation2")
    }

    conversations += [conversation1, conversation2]
  }

}
