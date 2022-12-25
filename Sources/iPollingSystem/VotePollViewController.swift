import Firebase
import UIKit

class VotePollViewController: UIViewController {
  // MARK: - Properties

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionsTableView: UITableView!
  @IBOutlet weak var submitButton: UIButton!

  var poll: Poll?

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    questionsTableView.dataSource = self
    questionsTableView.delegate = self
  }

  // MARK: - Actions

  @IBAction func submitButtonTapped(_ sender: Any) {
    // Validate that all questions have been answered
    for question in questions {
      if question.selectedOptionIndex == nil {
        // Show error message if a question has not been answered
        let alertController = UIAlertController(
          title: "Error", message: "Please answer all questions.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        return
      }
    }

    // Get the current date and time
    let date = Date()
    let timestamp = Timestamp(date: date)

    // Get the user's location
    guard let location = locationManager.location else {
      // Show error message if location is not available
      let alertController = UIAlertController(
        title: "Error", message: "Unable to get your location.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
      return
    }

    // Save the user's choices
    let userChoicesRef = Database.database().reference().child("userChoices").child(pollId)
      .childByAutoId()
    let userChoices = UserChoices(timestamp: timestamp, location: location, choices: questions)
    userChoicesRef.setValue(userChoices.toAnyObject())

    // Dismiss the view controller
    dismiss(animated: true, completion: nil)
  }

}

extension VotePollViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return questions.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell =
      tableView.dequeueReusableCell(withIdentifier: "OptionCell", for: indexPath)
      as! OptionTableViewCell
    cell.configure(with: questions[indexPath.row], selectedOption: selectedOptions[indexPath.row])
    cell.delegate = self
    return cell
  }
}
