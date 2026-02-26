//
//  Param.swift
//  Env
// 
//  Created by: tomieq on 26/02/2026
//

/// Parses and returns params used when launching the app
///  It supports two syntax:
///   app port=80 folder=/
///   app -p 80 -folder /
///   app --p 80 --folder /

import Foundation

public enum Param {
    public static func get(_ name: CustomStringConvertible) -> String? {
        Self.syntax1(name.description) ?? Self.syntax2(name.description)
    }
    
    public static func int(_ name: CustomStringConvertible) -> Int? {
        guard let text = Self.get(name), !text.isEmpty else {
            return nil
        }
        return Int(text)
    }
    
    public static func bool(_ name: CustomStringConvertible) -> Bool? {
        guard let text =  Self.get(name), !text.isEmpty else {
            return nil
        }
        return Bool(text.lowercased())
    }
    
    static func syntax1(_ name: String, args: [String] = CommandLine.arguments) -> String? {
        for argument in args {
            let parts = argument.split(separator: "=")
            guard parts.count == 2 else { continue }
            let paramName = parts[0]
            let paramValue = parts[1]
            if paramName == name {
                let value = paramValue.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                return value
            }
        }
        return nil
    }
    
    static func syntax2(_ name: String, args: [String] = CommandLine.arguments) -> String? {
        for (index, argument) in args.enumerated() {
            if argument == "-\(name)" || argument == "--\(name)" {
                guard args.count > index + 1 else { return nil }
                let paramValue = args[index + 1]
                let value = paramValue.trimmingCharacters(in: CharacterSet(charactersIn: "\""))
                return value
            }
        }
        return nil
    }
}
