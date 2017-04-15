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

public protocol APIDocument: Unmarshaling {

	/// Either `APIResource` or `[APIResource]`.
	associatedtype Resource

	/// The document’s primary data.
	var data: Resource? { get }

	/// Additional information about problems encountered while performing an operation.
	var errors: [APIError]? { get }

	/// Non-standard meta-information.
	var meta: JSONObject? { get }

	/// Information about the server’s JSON API implementation.
	var jsonapi: JSONObject? { get }

	/// Links related to the primary data.
	var links: JSONObject? { get }

	/// APIResources that are related to the primary data and/or each other.
	var included: [APIResource]? { get }

}

extension APIDocument where Resource == [APIResource] {

	/// Convenience wrapper for `data`.
	public var someData: Resource {
		return data ?? []
	}

}

extension APIDocument {

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

	public func checkSpecConformance() throws {
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
