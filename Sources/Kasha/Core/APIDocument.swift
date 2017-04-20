//
//  APIDocument.swift
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

	public let data: [APIResource]

	public let errors: [APIError]

	public let meta: JSONObject

	public let jsonapi: JSONObject

	public let links: JSONObject

	public let included: [APIResource]

	/// The document’s primary data.
	public let maybeData: [APIResource]?

	/// Additional information about problems encountered while performing an operation.
	public let maybeErrors: [APIError]?

	/// Non-standard meta-information.
	public let maybeMeta: JSONObject?

	/// Information about the server’s JSON API implementation.
	public let maybeJSONAPI: JSONObject?

	/// Links related to the primary data.
	public let maybeLinks: JSONObject?

	/// APIResources that are related to the primary data and/or each other.
	public let maybeIncluded: [APIResource]?

	public init(object: MarshaledObject) throws {
		if let resource = try? object.value(for: "data") as APIResource {
			maybeData = [resource]
		} else if let resources = try? object.value(for: "data") as [APIResource] {
			maybeData = resources
		} else if let anyData = object.optionalAny(for: "data") {
			throw MarshalError.typeMismatch(expected: APIResource.self, actual: type(of: anyData))
		} else {
			maybeData = nil
		}
		maybeErrors = try object.value(for: "errors")
		maybeMeta = try object.value(for: "meta")
		maybeJSONAPI = try object.value(for: "jsonapi")
		maybeLinks = try object.value(for: "links")
		maybeIncluded = try object.value(for: "included")
		data = maybeData ?? []
		errors = maybeErrors ?? []
		meta = maybeMeta ?? [:]
		jsonapi = maybeJSONAPI ?? [:]
		links = maybeLinks ?? [:]
		included = maybeIncluded ?? []
		try checkSpecConformance()
	}

	fileprivate func checkSpecConformance() throws {
		guard !(maybeData == nil && maybeErrors == nil && maybeMeta == nil) else {
			throw SpecViolationError.topLevelMemberMissing
		}

		guard !(maybeData != nil && maybeErrors != nil) else {
			throw SpecViolationError.topLevelDataAndErrorsCoexist
		}

		guard !(maybeData == nil && maybeIncluded != nil) else {
			throw SpecViolationError.topLevelIncludedPresentWhileDataMissing
		}
	}

}
