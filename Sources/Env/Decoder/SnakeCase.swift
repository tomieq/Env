//
//  SnakeCase.swift
//  Env
// 
//  Created by: tomieq on 21/04/2026
//


import Foundation

extension String {
    /**
     Converts camelCase into SCREAMING_SNAKE_CASE
     */
    var toSnakeCase: String {
        let regex = try! NSRegularExpression(pattern: "([a-z])([A-Z])", options: [])
        
        let result = regex.stringByReplacingMatches(in: self, range: NSRange(location: 0, length: self.utf16.count), withTemplate: "$1_$2")
        
        return result.uppercased()
    }
}
