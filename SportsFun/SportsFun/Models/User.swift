import UIKit

class User {

  var id: String
  var firstName: String
  var lastName: String
  var username: String
  var photo: UIImage?

  //MARK: Initialization

  init?(id: String, firstName: String, lastName: String, username: String, photo: UIImage?) {
    if firstName.isEmpty || lastName.isEmpty || username.isEmpty {
      return nil
    }

    self.id = id
    self.firstName = firstName
    self.lastName = lastName
    self.username = username
    self.photo = photo
  }

}
