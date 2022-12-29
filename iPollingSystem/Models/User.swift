import Foundation
import FirebaseAuth
import FirebaseDatabase

class User {
  let id: String
  let email: String
  var name: String

  init(id: String, email: String, name: String) {
    self.id = id
    self.email = email
    self.name = name
  }

  init(snapshot: DataSnapshot) {
    guard let value = snapshot.value as? [String: Any],
      let email = value["email"] as? String,
      let name = value["name"] as? String else {
        fatalError("Error parsing user snapshot")
    }
    self.id = snapshot.key
    self.email = email
    self.name = name
  }
}
