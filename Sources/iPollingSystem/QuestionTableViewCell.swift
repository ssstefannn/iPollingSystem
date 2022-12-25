import UIKit

class QuestionTableViewCell: UITableViewCell {
    // MARK: - Properties

    @IBOutlet weak var option1TextField: UITextField!
    @IBOutlet weak var option2TextField: UITextField!
    @IBOutlet weak var option3TextField: UITextField!
    @IBOutlet weak var addOptionButton: UIButton!

    var questions: [[String]] = []
    var indexPath: IndexPath?

    // MARK: - Actions

    @IBAction func addOptionButtonTapped(_ sender: Any) {
        guard let indexPath = indexPath else {
            return
        }

        // Append a new option to the question
        questions[indexPath.row].append("")
        option3TextField.isHidden = false

        // Reload the table view to display the new option
        if let tableView = superview as? UITableView, let publishPollViewController = tableView.dataSource as? PublishPollViewController {
            tableView.reloadData()
        }
    }
}
