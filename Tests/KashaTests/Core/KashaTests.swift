//
//  KashaTests.swift
//  Part of Kasha, a JSON API library for Swift.
//
//  Copyright (C) 2017 Alexander Tovstonozhenko
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Marshal
import XCTest
@testable import Kasha

final class KashaTests: XCTestCase {

	func testDocument() {
		let json = fixture("document")
		do {
			let document = try APIDocument(object: json)
			let article = try Article.make(context: document) as Article?
			print(article as Any)
		} catch {
			print(error)
			XCTFail(error.localizedDescription)
		}
	}

}
