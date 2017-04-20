//
//  APIResource.swift
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

public struct APIResource: Unmarshaling, Equatable {

	public static func ==(lhs: APIResource, rhs: APIResource) -> Bool {
		return lhs.type == rhs.type && lhs.id == rhs.id
	}

	/// Resource type.
	public let type: String

	/// Unique resource identifier.
	public let id: String

	public let attributes: JSONObject

	public let relationships: JSONObject

	public let links: JSONObject

	public let meta: JSONObject

	/// Some of resource’s data.
	public let maybeAttributes: JSONObject?

	/// Relationships between the resource and other resources.
	public let maybeRelationships: JSONObject?

	/// Links related to the resource.
	public let maybeLinks: JSONObject?

	/// Non-standard meta-information about a resource that can not be
	/// represented as an attribute or relationship.
	public let maybeMeta: JSONObject?

	public init(object: MarshaledObject) throws {
		type = try object.value(for: "type")
		id = try object.value(for: "id")
		maybeAttributes = try object.value(for: "attributes")
		maybeRelationships = try object.value(for: "relationships")
		maybeLinks = try object.value(for: "links")
		maybeMeta = try object.value(for: "meta")
		attributes = maybeAttributes ?? [:]
		relationships = maybeRelationships ?? [:]
		links = maybeLinks ?? [:]
		meta = maybeMeta ?? [:]
	}

}
