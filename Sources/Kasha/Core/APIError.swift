//
//  APIError.swift
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

import protocol Foundation.LocalizedError
import struct Foundation.URL
import Marshal

/// An object that provides additional information about problems encountered
/// while performing an operation.
public struct APIError: Error{

	/// A unique identifier for this particular occurrence of the problem.
	public let id: String?

	/// A link that leads to further details about this particular occurrence of the problem.
	public let about: URL?

	/// The HTTP status code applicable to this problem.
	public let status: String?

	/// An application-specific error code.
	public let code: String?

	/// A short, human-readable summary of the problem.
	public let title: String?

	/// A human-readable explanation specific to this occurrence of the problem.
	public let detail: String?

	/// A JSON Pointer [[RFC6901](https://tools.ietf.org/html/rfc6901)] to the associated entity
	/// in the request document (e.g. `"/data"` for a primary data object,
	/// `"/data/attributes/title"` for a specific attribute).
	public let pointer: String?

	/// A string indicating which URI query parameter caused the error.
	public let parameter: String?

	/// A meta object containing non-standard meta-information about the error.
	public let meta: JSONObject?

	private init() {
		fatalError()
	}

}

extension APIError: LocalizedError { // MARK: LocalizedError

	public var errorDescription: String? {
		return title
	}

	public var failureReason: String? {
		return detail
	}

}

extension APIError: Unmarshaling { // MARK: Unmarshaling

	/// Creates a `APIError` using a given JSON representation.
	///
	/// - Parameter object: JSON representation of an error object.
	/// - Throws: `MarshalError`
	public init(object: MarshaledObject) throws {
		id = try object.value(for: "id")
		about = try object.value(for: "links.about")
		status = try object.value(for: "status")
		code = try object.value(for: "code")
		title = try object.value(for: "title")
		detail = try object.value(for: "detail")
		pointer = try object.value(for: "source.pointer")
		parameter = try object.value(for: "source.parameter")
		meta = try object.value(for: "meta")
	}

}
