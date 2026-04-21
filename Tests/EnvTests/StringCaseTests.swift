//
//  StringCaseTests.swift
//  Env
// 
//  Created by: tomieq on 21/04/2026
//


import Testing
@testable import Env

@Test func toCamelCase() {
    #expect("hello_world".camelCased == "helloWorld")
    #expect("Hello-World".camelCased == "helloWorld")
    #expect("Hello_World".camelCased == "helloWorld")
    #expect("HELLO_WORLD".camelCased == "helloWorld")
}

@Test func toSnakeCase() {
    #expect("helloWorld".toSnakeCase == "HELLO_WORLD")
    #expect("HELLO_WORLD".toSnakeCase == "HELLO_WORLD")
}
