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
