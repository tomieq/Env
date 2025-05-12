import Foundation

public enum EnvError: Error {
    case fileNotExist
    case invalidValue
}

public class Env {
    private var cache: [String: String] = [:]
    
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
            
            cache[key] = value
        }
        return self
    }
    
    public func get(_ key: String) -> String? {
        cache[key] ?? ProcessInfo.processInfo.environment[key]
    }
    
    public func int(_ key: String) -> Int? {
        Int(get(key) ?? "")
    }
    
    public func bool(_ key: String) -> Bool? {
        Bool(get(key)?.lowercased() ?? "")
    }
}
