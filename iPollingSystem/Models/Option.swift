//
//  Choice.swift
//  iPollingSystem
//
//  Created by Nextsense on 12/29/22.
//  Copyright © 2022 Nextsense. All rights reserved.
//

import Foundation

public struct Option {
  let id: String
  let title: String

  init(id: String, title: String) {
    self.id = id
    self.title = title
  }

  init?(dictionary: [String: Any]) {
    guard let title = dictionary["title"] as? String else {
      return nil
    }
    self.id = UUID().uuidString
    self.title = title
  }
}
