//
//  EnvValueConvertible.swift
//  Env
// 
//  Created by: tomieq on 21/04/2026
//

protocol EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Self
}

extension String: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> String {
        data
    }
}

extension Int: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Int {
        guard let value = Int(data) else { throw EnvError.invalidType(reason: "Expected Int value for \(key)") }
        return value
    }
}

extension Int32: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Int32 {
        guard let value = Int32(data) else { throw EnvError.invalidType(reason: "Expected Int32 value for \(key)") }
        return value
    }
}

extension Int16: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Int16 {
        guard let value = Int16(data) else { throw EnvError.invalidType(reason: "Expected Int16 value for \(key)") }
        return value
    }
}

extension Int8: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Int8 {
        guard let value = Int8(data) else { throw EnvError.invalidType(reason: "Expected Int8 value for \(key)") }
        return value
    }
}

extension Double: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Double {
        guard let value = Double(data) else { throw EnvError.invalidType(reason: "Expected Double value for \(key)") }
        return value
    }
}

extension Bool: EnvValueConvertible {
    static func convertFromEnvData(_ data: String, key: CustomStringConvertible) throws -> Bool {
        guard let value = data.bool else { throw EnvError.invalidType(reason: "Expected Bool value for \(key)") }
        return value
    }
}
