import UIKit
import SocketIO

class NewConversationViewController: UIViewController {

  var manager: SocketManager!
  var socket: SocketIOClient!
  var userId: String = ""

  @IBAction func sendMessage(_ sender: UIBarButtonItem) {
    if let message = messageTextField.text, message.count > 0 {
      print("sent")
      socket.emit("message", [
        "to": userId,
        "content": message,
      ])
      dismiss(animated: true, completion: nil)
    }
  }

  @IBOutlet weak var messageTextField: UITextField!

  // MARK: Navigation

  @IBAction func cancel(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }

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
          self.socket.emit("registerMessages", ["token": token])
        }
      } catch {
        print("error:", error)
      }
    }
    socket.connect()
  }

  /*
   // MARK: - Navigation

   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */

}
