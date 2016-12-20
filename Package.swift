import PackageDescription

let package = Package(
    name: "CuteCrytpo",
    targets: [
        Target(name: "Types", dependencies: []),
        Target(name: "Utils", dependencies: ["Types"]),
        Target(name: "MAC", dependencies: ["Utils", "Types"]),
        Target(name: "FF1", dependencies: ["AES", "MAC", "Utils", "Types"]),
        Target(name: "Algebra", dependencies: ["Types", "Utils"]),
        Target(name: "AES", dependencies: ["Algebra", "Utils", "Types"]),
    ]
)
