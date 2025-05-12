# Env

Swift library to parse and load `.env` files. Getters fallback to `ProcessInfo.processInfo.environment`.
By default, the library searches and loads `.env` file from the current directory. 
You can load values from custom files with `load(filename:)`:
```swift
let env = Env() // it will silently try to load .env file if exists
try env.load(filename: ".env.prod")
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
