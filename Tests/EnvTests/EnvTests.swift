import Testing
import Env

@Test func loadBoolean() async throws {
    let raw = """
    ENABLED =TRUE
    """
    let sut = try Env().load(raw: raw)
    #expect(sut.bool("ENABLED") == true)
}

@Test func loadInteger() async throws {
    let raw = """
    TIMEOUT=180
    DEV_PORT =7000
    PROD_PORT = 8000
    """
    let sut = try Env().load(raw: raw)
    #expect(sut.int("TIMEOUT") == 180)
    #expect(sut.int("DEV_PORT") == 7000)
    #expect(sut.int("PROD_PORT") == 8000)
}

@Test func loadString() async throws {
    let raw = """
    PASSWORD = 12345
    DOMAIN="github.com"
    QUOTED = "Break the \"Strike\""
    """
    let sut = try Env().load(raw: raw)
    #expect(sut.get("PASSWORD") == "12345")
    #expect(sut.get("DOMAIN") == "github.com")
    print(sut.get("QUOTED") ?? "")
    #expect(sut.get("QUOTED") == "Break the \"Strike\"")
}

@Test func override() async throws {
    let raw = """
    PASSWORD = 12345
    """
    let sut = try Env().load(raw: raw)
    #expect(sut.get("PASSWORD") == "12345")
    sut.set("PASSWORD", 1111)
    #expect(sut.get("PASSWORD") == "1111")
}
