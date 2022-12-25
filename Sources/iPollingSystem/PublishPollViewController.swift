import Firebase
import UIKit

class PublishPollViewController: UIViewController {
  // MARK: - Properties

  @IBOutlet weak var titleTextField: UITextField!
  @IBOutlet weak var startDateTextField: UITextField!
  @IBOutlet weak var durationTextField: UITextField!
  @IBOutlet weak var questionsTableView: UITableView!
  @IBOutlet weak var addQuestionButton: UIButton!
  @IBOutlet weak var publishButton: UIButton!

  private var questions: [[String]] = []
  private var startDate: Timestamp?
  private var duration: Int?

  // MARK: - View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()

    questionsTableView.dataSource = self
    questionsTableView.delegate = self
  }

  // MARK: - Actions

  @IBAction func addQuestionButtonTapped(_ sender: Any) {
    // Add a new question with 3 default options
    questions.append(["", "", ""])
    questionsTableView.reloadData()
  }

  @IBAction func publishButtonTapped(_ sender: Any) {
    guard let title = titleTextField.text, !title.isEmpty else {
      // Show error message if title is empty
      let alertController = UIAlertController(
        title: "Error", message: "Please enter a title for the poll.", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
      return
    }

    if let startDateText = startDateTextField.text,
      let startDate = DateFormatter.pollDateFormatter.date(from: startDateText)
    {
      self.startDate = Timestamp(date: startDate)
    } else {
      // Show error message if start date is invalid
      let alertController = UIAlertController(
        title: "Error", message: "Please enter a valid start date for the poll.",
        preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
      return
    }

    if let durationText = durationTextField.text, let duration = Int(durationText) {
      self.duration = duration
    } else {
      // Show error message if duration is invalid
      let alertController = UIAlertController(
        title: "Error", message: "Please enter a valid duration for the poll.",
        preferredStyle: .alert)
      let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(okAction)
      present(alertController, animated: true, completion: nil)
      return
    }

    // Validate questions
    for question in questions {
      if question.count < 3 {
        // Show error message if a question has less than 3 options
        let alertController = UIAlertController(
          title: "Error", message: "Please make sure all questions have at least 3 options.",
          preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
        return
      }
    }

    // Create the poll
    let pollRef = Database.database().reference().child("polls").childByAutoId()
    let pollId = pollRef.key
    let poll = Poll(
      id: pollId, title: title, startDate: startDate, duration: duration, questions: questions)
    pollRef.setValue(poll.toAnyObject())

    // Dismiss the view controller
    dismiss(animated: true, completion: nil)
  }
}

// MARK: - UITableViewDelegate

extension PublishPollViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            questions.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}