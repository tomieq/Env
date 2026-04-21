//
//  EnvObjectTests.swift
//  Env
// 
//  Created by: tomieq on 10/04/2026
//
import Foundation
import Testing
import Env

struct Config: Decodable {
    let host: String
    let port: Int
    let useWebsockets: Bool
    let price: Double?
    let sslEnabled: Bool?
}

struct LongConfig: Decodable {
    let prodStorageUrl: String
}

@Test
func makeObject() async throws {
    let raw = """
    host = localhost
    port = 80
    useWebsockets = 1
    """
    let env = try Env().load(raw: raw)
    let config: Config = try env.decode()
    #expect(config.useWebsockets == true)
    #expect(config.price == nil)
    #expect(config.port == 80)
    #expect(config.host == "localhost")
}

@Test
func objectCamelCased() async throws {
    let raw = """
    HOST = localhost
    PORT=80
    USE_WEBSOCKETS = 1
    SSL_ENABLED = 0
    PRICE = 10.5
    """
    let env = try Env().load(raw: raw)
    let config: Config = try env.decode()
    #expect(config.useWebsockets == true)
    #expect(config.price == 10.5)
    #expect(config.port == 80)
    #expect(config.host == "localhost")
    #expect(config.sslEnabled == false)
}

@Test
func entryWithDots() async throws {
    let raw = """
    PROD.STORAGE.URL = localhost:8080
    """
    let env = try Env().load(raw: raw)
    print(env.keys)
    let config: LongConfig = try env.decode()
    #expect(config.prodStorageUrl == "localhost:8080")
}

@Test
func entryWithUnderscore() async throws {
    let raw = """
    PROD_STORAGE_URL = localhost:8080
    """
    let env = try Env().load(raw: raw)
    print(env.keys)
    let config: LongConfig = try env.decode()
    #expect(config.prodStorageUrl == "localhost:8080")
}

@Test
func uppercasedConfig() async throws {
    struct CustomConfig: Decodable {
        let PROD_STORAGE_URL: String
    }
    let raw = """
    PROD_STORAGE_URL = localhost:8080
    """
    let env = try Env().load(raw: raw)
    print(env.keys)
    let config: CustomConfig = try env.decode()
    #expect(config.PROD_STORAGE_URL == "localhost:8080")
}

@Test
func missingEntry() async throws {
    let raw = """
    STG_STORAGE_URL = localhost:8080
    """
    let env = try Env().load(raw: raw)
    print(env.keys)
    do {
        let config: LongConfig = try env.decode()
        #expect(config.prodStorageUrl == "")
    } catch {
        let expectedError = EnvError.missingValue("String value for PROD_STORAGE_URL")
        #expect((error as? EnvError) == expectedError )
    }
}

@Test
func typeNotSupported() async throws {
    
    struct CustomConfig: Decodable {
        let version: UInt8
    }
    let raw = """
    VERSION = 3
    """
    let env = try Env().load(raw: raw)
    print(env.keys)
    do {
        let config: CustomConfig = try env.decode()
        #expect(config.version == 3)
    } catch {
        let expectedError = EnvError.typeNotSupported("UInt8 value for VERSION")
        #expect((error as? EnvError) == expectedError )
    }
}
