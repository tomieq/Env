import Foundation

typealias EnvCache = [EnvCacheKey: String]

public enum EnvError: Error, Equatable {
    case fileNotExist
    case invalidValue
    case invalidType(reason: String)
    case missingValue(String)
    case typeNotSupported(String)
}

public class Env {
    private var cache: EnvCache = [:]
    public static let shared: Env = {
        Env()
    }()
    
    public init(_ filename: String = ".env") {
        _ = try? self.load(filename: filename)
    }
    
    @discardableResult
    public func load(filename: String) throws -> Env {
        let path = FileManager.default.currentDirectoryPath + "/" + filename
        guard FileManager.default.fileExists(atPath: path) else {
            throw EnvError.fileNotExist
        }
        let raw = try String(contentsOfFile: path, encoding: .utf8)
        try self.load(raw: raw)
        return self
    }
    
    @discardableResult
    public func load(raw: String) throws -> Env {
        let lines = raw.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        
        for line in lines {
            if line.isEmpty {
                continue
            }
            
            if line.starts(with: "#") {
                continue
            }
            
            let parts = line.split(separator: "=", maxSplits: 1)
            
            if parts.count != 2 {
                throw EnvError.invalidValue
            }
            
            let key = parts[0].trimmingCharacters(in: .whitespaces)
            var value = parts[1].trimmingCharacters(in: .whitespaces)
            
            if key.rangeOfCharacter(from: .whitespaces) != nil {
                throw EnvError.invalidValue
            }
            
            if value.count > 1, value.first == "\"", value.last == "\"" {
                value.removeLast()
                value.removeFirst()
                value = value.replacingOccurrences(of: "\\\"", with: "\"")
            }
            
            cache[.init(key)] = value
        }
        return self
    }

    public var keys: [String] {
        cache.keys.map { $0.rawValue }
    }

    public func get(_ key: CustomStringConvertible) -> String? {
        value(for: key) ??
        ProcessInfo.processInfo.environment[key.description] ??
        ProcessInfo.processInfo.environment[key.description.toSnakeCase]
    }
    
    public func int(_ key: CustomStringConvertible) -> Int? {
        Int(get(key) ?? "")
    }
    
    public func bool(_ key: CustomStringConvertible) -> Bool? {
        get(key)?.bool
    }
    
    public func set(_ key: CustomStringConvertible, _ value: CustomStringConvertible) {
        cache[.init(key)] = value.description
    }
    
    public func decode<T>() throws -> T where T: Decodable {
        try EnvDecoder(context: self).decode()
    }
}

struct EnvCacheKey: Hashable {
    let rawValue: String
    
    init(_ rawValue: CustomStringConvertible) {
        self.rawValue = rawValue.description
    }
    
    func matches(_ key: CustomStringConvertible) -> Bool {
        rawValue == key.description || rawValue.camelCased == key.description
    }
}

extension Env {
    
    private var envKeys: [EnvCacheKey] {
        Array(cache.keys)
    }
    
    func value(for key: CustomStringConvertible) -> String? {
        let key = envKeys.first { $0.matches(key) }
        guard let envKey = key else { return nil }
        return self.cache[envKey]
    }
}
