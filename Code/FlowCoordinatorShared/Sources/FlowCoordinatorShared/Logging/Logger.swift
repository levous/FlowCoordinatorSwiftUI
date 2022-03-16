//
//  Logger.swift
//  
//
//  Created by Rusty Zarse on 3/12/22.
//


import Foundation

public enum Logger {
    public static func logError(
        _ message: String,
        error: Error? = nil,
        function: StaticString = #function,
        file: StaticString = #file
    ) {
        print("💥 [\(file) \(function)] ERROR: \(message) | error: \(error?.localizedDescription ?? "nil"))")
    }
}

