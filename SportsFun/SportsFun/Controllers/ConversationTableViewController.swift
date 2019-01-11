import UIKit
import SocketIO
import SwiftyJSON

class ConversationTableViewController: UITableViewController {

  var manager: SocketManager!
  var socket: SocketIOClient!
  var conversationId: String?
  var messages: [(String)] = []

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
              self.loadConversation()
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

  func addMessage(data: JSON) {
    messages.append(data["content"].string ?? "")
    self.tableView.reloadData()
  }

  func loadConversation() {
    socket.on("message") {data, ack in
      let newMessage = JSON(data)
      print(newMessage)
      self.addMessage(data: newMessage)
    }
    socket.on("conversation") {data, ack in
      let data = JSON(data)
      let newMessages = data[0]["messages"]
      for (_,subJson):(String, JSON) in newMessages {
        self.addMessage(data: subJson)
      }
    }
    socket.emit("conversation", ["id": conversationId])
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return messages.count
    }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cellIdentifier = "MessageTableViewCell"

    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MessageTableViewCell else {
      fatalError("The dequeued cell is not an instance of ConversationTableViewCell.")
    }

    let message = messages[indexPath.row]
    //cell.fullNameLabel.text = snippet.firstName + " " + snippet.lastName
    cell.contentLabel.text = message

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

}
