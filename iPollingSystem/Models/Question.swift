//
//  Question.swift
//  iPollingSystem
//
//  Created by Nextsense on 12/29/22.
//  Copyright © 2022 Nextsense. All rights reserved.
//

import Foundation

public struct Question {
  let id: String
  let title: String
  let options: [Option]

  init(id: String, title: String, options: [Option]) {
    self.id = id
    self.title = title
    self.options = options
  }

  init?(dictionary: [String: Any]) {
    guard let title = dictionary["title"] as? String,
      let options = dictionary["options"] as? [[String: Any]] else {
        return nil
    }
    self.id = UUID().uuidString
    self.title = title
    self.options = options.compactMap { Option(dictionary: $0) }
  }
}
