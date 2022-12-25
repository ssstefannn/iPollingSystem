import Firebase
import UIKit

class PollListViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet weak var tableView: UITableView!

  private var polls: [Poll] = []
  private var pollsRef: DatabaseReference!
  private var pollsHandle: DatabaseHandle!

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    tableView.dataSource = self
    tableView.delegate = self

    // Initialize polls reference
    pollsRef = Database.database().reference().child("polls")

    // Observe polls
    pollsHandle = pollsRef.observe(
      .value,
      with: { [weak self] snapshot in
        guard let strongSelf = self else { return }

        var polls: [Poll] = []
        for child in snapshot.children {
          if let snapshot = child as? DataSnapshot,
            let poll = Poll(snapshot: snapshot)
          {
            polls.append(poll)
          }
        }

        strongSelf.polls = polls
        strongSelf.tableView.reloadData()
      })
  }

  deinit {
    // Remove observer when view controller is no longer needed
    pollsRef.removeObserver(withHandle: pollsHandle)
  }

  // MARK: - Navigation

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "ShowVotePoll",
      let destination = segue.destination as? VotePollViewController,
      let indexPath = tableView.indexPathForSelectedRow
    {
      destination.poll = polls[indexPath.row]
    }
  }
}

// MARK: - UITableViewDataSource

extension PollListViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return polls.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PollCell", for: indexPath)
    let poll = polls[indexPath.row]
    cell.textLabel?.text = poll.title
    return cell
  }
}

// MARK: - UITableViewDelegate

extension PollListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}
