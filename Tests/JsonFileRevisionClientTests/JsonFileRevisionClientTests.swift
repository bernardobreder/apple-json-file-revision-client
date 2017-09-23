//
//  JsonFileRevisionClientTests.swift
//  JsonFileRevision
//
//  Created by Bernardo Breder on 29/01/17.
//
//

import XCTest
import Foundation
@testable import DataStore
@testable import JsonFileRevisionClient
@testable import JsonFileRevisionBase
@testable import JsonFileChange
@testable import Json
@testable import Literal

class JsonFileRevisionClientTests: XCTestCase {
    
    func testExample() throws {
        let fs = MemoryFileSystem()
        let db = try DataStore(fileSystem: DataStoreFileSystem(folder: fs.home()))
        let client = try db.read { reader in try JsonFileRevisionClient(reader: reader) }
        try db.write { writer in try client.write(writer: writer) { w in try w.createFile([], name: "a.txt") } }
        try db.write { writer in try client.write(writer: writer) { w in try w.write([], name: "a.txt", { jw in jw.apply(["a", "b"], value: 1) }) } }
        try db.read { reader in try client.read(reader: reader) { r in XCTAssertTrue(try r.existFile([], name: "a.txt")) } }
        try db.read { reader in try client.read(reader: reader) { r in try r.read([], name: "a.txt", { jr in XCTAssertEqual(1, jr[["a", "b"]]?.int) }) } }
        try db.write { writer in try client.revertChanges(writer: writer) }; client.revertChanges()
        try db.read { reader in try client.read(reader: reader) { r in XCTAssertFalse(try r.existFile([], name: "a.txt")) } }
    }
    
}
