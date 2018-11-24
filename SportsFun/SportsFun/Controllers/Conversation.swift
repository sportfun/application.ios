import UIKit

class Conversation {

  //MARK: Properties

  var recipient: User
  var messages: [Message]

  //MARK: Initialization

  init?(recipient: User, messages: [Message]) {
    self.recipient = recipient
    self.messages = messages
  }

}
