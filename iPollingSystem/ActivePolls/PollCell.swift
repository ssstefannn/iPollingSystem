import UIKit

class PollCell: UITableViewCell {

  // MARK: - Outlets

  @IBOutlet weak var titleLabel: UILabel!

  // MARK: - Configure

  func configure(with poll: Poll) {
    titleLabel.text = poll.title
  }
}
