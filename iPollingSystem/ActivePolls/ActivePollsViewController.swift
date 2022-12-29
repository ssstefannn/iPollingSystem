import UIKit
import FirebaseDatabase
import FirebaseAuth

class ActivePollsViewController: UIViewController {

  // MARK: - Outlets

  @IBOutlet weak var tableView: UITableView!

  // MARK: - Properties

  let ref = Database.database().reference()
  var polls: [Poll] = []
  var currentUser: User?

  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    fetchCurrentUser()
    fetchPolls()
  }

  // MARK: - Private Methods

  private func fetchCurrentUser() {
    if let currentUserId = Auth.auth().currentUser?.uid {
      ref.child("users").child(currentUserId).observeSingleEvent(of: .value) { (snapshot) in
        self.currentUser = User(snapshot: snapshot)
      }
    }
  }

  private func fetchPolls() {
    ref.child("polls").observe(.value) { (snapshot) in
      self.polls = []
      for child in snapshot.children {
        if let childSnapshot = child as? DataSnapshot,
          let poll = Poll(snapshot: childSnapshot) {
          self.polls.append(poll)
        }
      }
      self.tableView.reloadData()
    }
  }
}

// MARK: - UITableViewDataSource

extension ActivePollsViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return polls.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath) as! PollCell
    let poll = polls[indexPath.row]
    cell.configure(with: poll)
    return cell
  }
}
