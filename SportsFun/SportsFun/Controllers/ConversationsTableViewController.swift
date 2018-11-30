  import UIKit
  import os.log
  import SocketIO
  import SwiftyJSON

  struct Snippet {
    var id: String
    var photoURL: String
    var firstName: String
    var lastName: String
    var content: String
  }

  class ConversationsTableViewController: UITableViewController {
    var manager: SocketManager!
    var socket: SocketIOClient!
    var snippets = [Snippet]()

    override func viewDidLoad() {
      super.viewDidLoad()

      manager = SocketManager(socketURL: URL(string: "http://api.sportsfun.shr.ovh:8080")!, config: [.compress])
      socket = manager.defaultSocket
      socket.on(clientEvent: .connect) {data, ack in
        let networking = Networking(token: "")
        do {
          if let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = documentDirectory.appendingPathComponent("token.txt")
            let token = try String(contentsOf: fileURL)
            networking.token = token
            self.socket.on("registerMessages") {data, ack in
              self.loadSnippets()
            }
            self.socket.emit("registerMessages", ["token": token])
          }
        } catch {
          print("error:", error)
        }
      }
      socket.connect()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return snippets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cellIdentifier = "ConversationTableViewCell"

      guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConversationTableViewCell else {
        fatalError("The dequeued cell is not an instance of ConversationTableViewCell.")
      }

      let snippet = snippets[indexPath.row]

      var photo = UIImage(named: "defaultPhoto")
      do {
        if let url = URL(string: snippet.photoURL) {
          let data = try Data(contentsOf: url)
          photo = UIImage(data: data)
        }
      } catch {
        print(error)
      }
      cell.photoImageView.image = photo
      cell.fullNameLabel.text = snippet.firstName + " " + snippet.lastName
      cell.contentLabel.text = snippet.content

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

      switch (segue.identifier ?? "") {
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

        let selectedConversation = snippets[indexPath.row]
        conversationViewController.conversationId = selectedConversation.id
      default:
        fatalError("Unexpected Segue Identifier; \(segue.identifier)")
      }
    }

    // MARK: Private Methods

    private func loadSnippets() {
      socket.on("snippets") {data, ack in
        data.forEach({ item in
          let data = JSON(item)
          let id = data["id"].stringValue
          let message = data["message"]
          let recipient = message["to"]["_id"].stringValue == id ? message["to"] : message["author"]
          let snippet = Snippet(id: id, photoURL: recipient["profilePic"].stringValue, firstName: recipient["firstName"].stringValue, lastName: recipient["lastName"].stringValue, content: message["content"].stringValue)
          self.snippets.append(snippet)
          self.tableView.reloadData()
        })
      }
      socket.emit("snippets")
    }

  }
