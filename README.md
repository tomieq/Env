# Env

Swift library to parse and load `.env` files. Getters fallback to `ProcessInfo.processInfo.environment`.
By default, the library searches and loads `.env` file from the current directory. 
You can load values from custom files with `load(filename:)`:
```swift
let env = Env() // it will silently try to load .env file if exists
try env.load(filename: ".env.prod")
```
# Param

Util to get launch param values. It supports 3 syntax types:
```
app_name port=80 host=0.0.0.0
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
