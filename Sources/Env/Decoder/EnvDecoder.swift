//
//  EnvDecoder.swift
//
//
//  Created by Tomasz on 27/06/2024.
//

import Foundation

final class EnvDecoder {

    private let context: EnvValueProvider

    init(context: EnvValueProvider) {
        self.context = context
    }

    func decode<D>() throws -> D where D: Decodable {
        let decoder = EnvDecoderCore(context: context, codingPath: [])
        return try D(from: decoder)
    }
}

private final class EnvDecoderCore: Decoder {
    init(context: EnvValueProvider, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }
    private let context: EnvValueProvider
    let codingPath: [CodingKey]
    var userInfo: [CodingUserInfoKey: Any] { [:] }

    func container<Key>(keyedBy _: Key.Type) throws -> KeyedDecodingContainer<Key> where Key: CodingKey {
        .init(EnvKeyedDecoder<Key>(context: self.context, codingPath: self.codingPath))
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        EnvUnkeyedDecoder(context: self.context, codingPath: self.codingPath)
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        EnvSingleValueDecoder(context: self.context, codingPath: self.codingPath)
    }
}

private final class EnvSingleValueDecoder: SingleValueDecodingContainer {
    
    init(context: EnvValueProvider, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }
    
    private let context: EnvValueProvider
    private var value: String? {
        context.get(self.codingPath.map{$0.stringValue}.joined(separator: "."))
    }

    var codingPath: [CodingKey]
    func decodeNil() -> Bool {
        self.value == nil
    }

    func decode<T>(_: T.Type) throws -> T where T: Decodable {
        guard let value else {
            throw EnvError.missingValue("\(T.self) value for \(self.codingPath.first?.stringValue.toSnakeCase ?? "nil")")
        }
        if let convertible = T.self as? EnvValueConvertible.Type {
            return try convertible.convertFromEnvData(value, key: codingPath) as! T
        } else {
            throw EnvError.typeNotSupported("\(T.self) value for \(self.codingPath.first?.stringValue.toSnakeCase ?? "nil")")
        }
    }
}

private final class EnvKeyedDecoder<K>: KeyedDecodingContainerProtocol where K: CodingKey {
    init(context: EnvValueProvider, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
    }

    typealias Key = K
    private let context: EnvValueProvider
    private func value(at: K) -> String? {
        context.get(self.codingPath.map{$0.stringValue}.joined(separator: ".") + at.stringValue)
    }
    var codingPath: [CodingKey]
    var allKeys: [K] {
        context.keys.compactMap { K(stringValue: $0) }
    }

    func contains(_ key: K) -> Bool {
        value(at: key) != nil
    }

    func decodeNil(forKey key: K) throws -> Bool {
        value(at: key) == nil
    }

    func decode<T>(_: T.Type, forKey key: K) throws -> T where T: Decodable {
        guard let val =  value(at: key) else {
            throw EnvError.missingValue("\(T.self) value for \(key.stringValue.toSnakeCase)")
        }
        guard let convertible = T.self as? EnvValueConvertible.Type else {
            let decoder = EnvDecoderCore(context: context, codingPath: codingPath + [key])
            return try T(from: decoder)
        }
        return try convertible.convertFromEnvData(val, key: codingPath + [key]) as! T
    }

    func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type, forKey key: K) throws -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey {
        .init(EnvKeyedDecoder<NestedKey>(context: self.context, codingPath: self.codingPath + [key]))
    }

    func nestedUnkeyedContainer(forKey key: K) throws -> UnkeyedDecodingContainer {
        EnvUnkeyedDecoder(context: self.context, codingPath: self.codingPath + [key])
    }

    func superDecoder() throws -> Decoder {
        EnvDecoderCore(context: self.context, codingPath: self.codingPath)
    }

    func superDecoder(forKey key: K) throws -> Decoder {
        EnvDecoderCore(context: self.context, codingPath: self.codingPath + [key])
    }
}

private final class EnvUnkeyedDecoder: UnkeyedDecodingContainer {
    private let context: EnvValueProvider
        
    init(context: EnvValueProvider, codingPath: [CodingKey]) {
        self.context = context
        self.codingPath = codingPath
        self.currentIndex = 0
    }

    
    var codingPath: [CodingKey]
    var currentIndex: Int
    var count: Int? {
        nil
    }

    var isAtEnd: Bool {
        true
    }

    func decodeNil() throws -> Bool {
        true
    }

    func decode<T>(_: T.Type) throws -> T where T: Decodable {
        throw EnvError.missingValue("\(T.self) value for \(self.codingPath.first?.stringValue.toSnakeCase ?? "nil")")
    }

    func nestedContainer<NestedKey>(keyedBy _: NestedKey.Type) throws -> KeyedDecodingContainer<NestedKey>
        where NestedKey: CodingKey {
        .init(EnvKeyedDecoder<NestedKey>(context: self.context, codingPath: self.codingPath))
    }

    func nestedUnkeyedContainer() throws -> UnkeyedDecodingContainer {
        EnvUnkeyedDecoder(context: self.context, codingPath: self.codingPath)
    }

    func superDecoder() throws -> Decoder {
        defer { currentIndex += 1 }
        return EnvDecoderCore(context: self.context, codingPath: self.codingPath)
    }
}
