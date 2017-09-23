//
//  JsonFileRevisionClientTests.swift
//  JsonFileRevisionClient
//
//  Created by Bernardo Breder.
//
//

import XCTest
@testable import JsonFileRevisionClientTests

extension JsonFileRevisionClientTests {

	static var allTests : [(String, (JsonFileRevisionClientTests) -> () throws -> Void)] {
		return [
			("testExample", testExample),
		]
	}

}

XCTMain([
	testCase(JsonFileRevisionClientTests.allTests),
])

