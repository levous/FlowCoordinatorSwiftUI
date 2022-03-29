//
//  UserMessage.swift
//  
//
//  Created by Rusty Zarse on 3/12/22.
//

public enum UserMessage {
    case error(title: String, message: String, error: Error?)

    public var title: String {
        switch self {
        case .error(let title, _, _):
            return title
        }
    }

    public var message: String {
        switch self {
        case .error(_, let message, _):
            return message
        }
    }
}
