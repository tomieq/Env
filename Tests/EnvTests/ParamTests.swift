//
//  ParamTests.swift
//  Env
// 
//  Created by: tomieq on 26/02/2026
//

import Testing
@testable import Env

@Test func parseSyntax1() async throws {
    #expect(Param.syntax1("port", args: ["port=80"]) == "80")
    #expect(Param.syntax1("port", args: ["port=\"80\""]) == "80")
    #expect(Param.syntax1("port", args: ["-port=\"80\""]) == "80")
    #expect(Param.syntax1("port", args: ["--port=\"80\""]) == "80")
    #expect(Param.syntax1("port", args: ["id=6", "port=\"80\"", "host=localhost"]) == "80")
}

@Test func parseSyntax2() async throws {
    #expect(Param.syntax2("port", args: ["-port", "80"]) == "80")
    #expect(Param.syntax2("port", args: ["--port", "80"]) == "80")
}

@Test func parseSyntax2negative() async throws {
    #expect(Param.syntax2("port", args: ["-port"]) == nil)
    #expect(Param.syntax2("port", args: ["--port"]) == nil)
    #expect(Param.syntax2("host", args: ["--port", "--host", "localhost"]) == "localhost")
}
