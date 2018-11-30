import UIKit

class ConversationViewController: UIViewController {

  var conversationId: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let id = conversationId {
      navigationItem.title = id
    }
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

