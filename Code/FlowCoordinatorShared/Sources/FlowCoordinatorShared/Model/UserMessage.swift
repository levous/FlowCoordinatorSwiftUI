//
//  UserMessage.swift
//  
//
//  Created by Rusty Zarse on 3/12/22.
//

public enum UserMessage {
    case error(title: String, message: String, error: Error?)

    var title: String {
        switch self {
        case .error(let title, _, _):
            return title
        }
    }

    var message: String {
        switch self {
        case .error(_, let message, _):
            return message
        }
    }
}
