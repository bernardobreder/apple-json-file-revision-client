//
//  Package.swift
//  JsonFileRevisionClient
//
//

import PackageDescription

let package = Package(
	name: "JsonFileRevisionClient",
	targets: [
		Target(name: "JsonFileRevisionClient", dependencies: ["JsonFileRevisionBase"]),
		Target(name: "Array", dependencies: []),
		Target(name: "AtomicValue", dependencies: []),
		Target(name: "DataStore", dependencies: ["Array", "AtomicValue", "Dictionary", "FileSystem", "IndexLiteral", "Json", "Literal", "Optional", "Regex"]),
		Target(name: "DatabaseFileSystem", dependencies: ["Array", "AtomicValue", "DataStore", "Dictionary", "FileSystem", "IndexLiteral", "Json", "Literal", "Optional", "Regex"]),
		Target(name: "Dictionary", dependencies: []),
		Target(name: "FileSystem", dependencies: []),
		Target(name: "IndexLiteral", dependencies: []),
		Target(name: "Json", dependencies: ["Array", "IndexLiteral", "Literal"]),
		Target(name: "JsonFileChange", dependencies: ["Array", "AtomicValue", "DataStore", "DatabaseFileSystem", "Dictionary", "FileSystem", "IndexLiteral", "Json", "JsonTrack", "Literal", "Optional", "Regex"]),
		Target(name: "JsonFileRevisionBase", dependencies: ["Array", "AtomicValue", "DataStore", "DatabaseFileSystem", "Dictionary", "FileSystem", "IndexLiteral", "Json", "JsonFileChange", "JsonTrack", "Literal", "Optional", "Regex"]),
		Target(name: "JsonTrack", dependencies: ["Array", "IndexLiteral", "Json", "Literal"]),
		Target(name: "Literal", dependencies: []),
		Target(name: "Optional", dependencies: []),
		Target(name: "Regex", dependencies: []),
	]
)

