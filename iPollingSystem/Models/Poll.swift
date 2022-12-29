import Foundation
import FirebaseDatabase

public struct Poll {
  let id: String
  let title: String
  let startDate: Date
  let endDate: Date
  let questions: [Question]

  init(id: String, title: String, startDate: Date, endDate: Date, questions: [Question]) {
    self.id = id
    self.title = title
    self.startDate = startDate
    self.endDate = endDate
    self.questions = questions
  }

  init?(snapshot: DataSnapshot) {
    guard let value = snapshot.value as? [String: Any],
      let title = value["title"] as? String,
      let startTimestamp = value["startDate"] as? Double,
      let endTimestamp = value["endDate"] as? Double,
      let questions = value["questions"] as? [[String: Any]] else {
        return nil
    }
    self.id = snapshot.key
    self.title = title
    self.startDate = Date(timeIntervalSince1970: startTimestamp)
    self.endDate = Date(timeIntervalSince1970: endTimestamp)
    self.questions = questions.compactMap { Question(dictionary: $0) }
  }
}
