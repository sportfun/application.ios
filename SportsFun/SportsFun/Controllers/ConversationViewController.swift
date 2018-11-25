import UIKit

class ConversationViewController: UIViewController {

  var conversation: Conversation?
  var recipient: User?

  override func viewDidLoad() {
    super.viewDidLoad()

    if let recipient = recipient {
      navigationItem.title = recipient.firstName
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
