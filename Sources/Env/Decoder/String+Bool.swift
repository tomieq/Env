//
//  String+Bool.swift
//  Env
// 
//  Created by: tomieq on 21/04/2026
//



extension String {
    var bool: Bool? {
        switch lowercased() {
        case "true", "yes", "1", "y": return true
        case "false", "no", "0", "n": return false
        default: return nil
        }
    }
}
