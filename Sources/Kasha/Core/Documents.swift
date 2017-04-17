//
//  Documents.swift
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

public struct APIDocument: Unmarshaling {

	/// The document’s primary data.
	public let data: [APIResource]?

	/// Additional information about problems encountered while performing an operation.
	public let errors: [APIError]?

	/// Non-standard meta-information.
	public let meta: JSONObject?

	/// Information about the server’s JSON API implementation.
	public let jsonapi: JSONObject?

	/// Links related to the primary data.
	public let links: JSONObject?

	/// APIResources that are related to the primary data and/or each other.
	public let included: [APIResource]?

	public init(object: MarshaledObject) throws {
		if let resource = try? object.value(for: "data") as APIResource {
			data = [resource]
		} else if let resources = try? object.value(for: "data") as [APIResource] {
			data = resources
		} else {
			data = nil
		}
		errors = try object.value(for: "errors")
		meta = try object.value(for: "meta")
		jsonapi = try object.value(for: "jsonapi")
		links = try object.value(for: "links")
		included = try object.value(for: "included")
		try checkSpecConformance()
	}

}

extension APIDocument {

	/// Convenience wrapper for `data`.
	public var someData: [APIResource] {
		return data ?? []
	}

	/// Convenience wrapper for `errors`.
	public var someErrors: [APIError] {
		return errors ?? []
	}

	/// Convenience wrapper for `meta`.
	public var someMeta: JSONObject {
		return meta ?? [:]
	}

	/// Convenience wrapper for `jsonapi`.
	public var someJSONAPI: JSONObject {
		return jsonapi ?? [:]
	}

	/// Convenience wrapper for `links`.
	public var someLinks: JSONObject {
		return links ?? [:]
	}

	/// Convenience wrapper for `included`.
	public var someIncluded: [APIResource] {
		return included ?? []
	}

	func checkSpecConformance() throws {
		guard !(data == nil && errors == nil && meta == nil) else {
			throw SpecViolationError.topLevelMemberMissing
		}

		guard !(data != nil && errors != nil) else {
			throw SpecViolationError.topLevelDataAndErrorsCoexist
		}

		guard !(data == nil && included != nil) else {
			throw SpecViolationError.topLevelIncludedPresentWhileDataMissing
		}
	}

}
