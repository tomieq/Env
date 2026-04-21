# Env

Swift library to parse and load `.env` files. Getters fallback to `ProcessInfo.processInfo.environment`.
By default, the library searches and loads `.env` file from the current directory. 
You can load values from custom files with `load(filename:)`:
```swift
let env = Env() // it will silently try to load .env file if exists
try env.load(filename: ".env.prod")
```
### Obtaining values
To get values you can use convenient getters:
```swift
let host = env.get("HOST")
let port = env.int("PORT")
let enabled = env.bool("SSL_ENABLED")
```
### Decoding to object
You can also use in-build object decoder:
```swift
struct Config: Decodable {
    let host: String
    let port: Int
    let sslEnabled: Bool
}

let config: Config = try env.decode()
```
The decode function will try to match all entries like 'SSL_ENABLED', 'SSL.ENABLED', 'SSL-ENABLED', 'sslEnabled' from env file to match attribute `sslEnabled` in your object. So there is possibility to create env file with UPPER_CASED entries and in Swift use clean camelCased variable names. 
### Bool tip
For boolean values use can use: "true", "yes", "1", "y" / "false", "no", "0", "n"

# Param

Utility object to get launch param values. It supports following syntax types:
```
app_name port=80 host=0.0.0.0
app_name -port=80 -host=0.0.0.0
app_name --port=80 --host=0.0.0.0
app_name -port 80 -host 0.0.0.0
app_name --port 80 --host 0.0.0.0
```
In order to get value just use:
```swift
let port = Param.int("port")
let host = Param.get("host")
```

### SPM

```swift
import PackageDescription

let package = Package(
    name: "MyServer",
    dependencies: [
        .package(url: "https://github.com/tomieq/Env", .upToNextMajor(from: "1.0.0"))
    ]
)
```
In the taeget:
```swift
    targets: [
        .executableTarget(
            name: "AppName",
            dependencies: [
                .product(name: "Env", package: "Env")
            ])
    ]
```
