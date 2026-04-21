//
//  EnvValueProvider.swift
//  Env
// 
//  Created by: tomieq on 21/04/2026
//

protocol EnvValueProvider {
    func get(_ key: CustomStringConvertible) -> String?
    var keys: [String] { get }
}

extension Env: EnvValueProvider {}
