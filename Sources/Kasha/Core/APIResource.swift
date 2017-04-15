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

public struct APIResource: Unmarshaling {

	/// Resource type.
	public let type: String

	/// Unique resource identifier.
	public let id: String

	/// Some of resource’s data.
	public let attributes: JSONObject?

	/// Relationships between the resource and other resources.
	public let relationships: JSONObject?

	/// Links related to the resource.
	public let links: JSONObject?

	/// Non-standard meta-information about a resource that can not be
	/// represented as an attribute or relationship.
	public let meta: JSONObject?

	public init(object: MarshaledObject) throws {
		type = try object.value(for: "type")
		id = try object.value(for: "id")
		attributes = try object.value(for: "attributes")
		relationships = try object.value(for: "relationships")
		links = try object.value(for: "links")
		meta = try object.value(for: "meta")
	}

}

extension APIResource {

	/// Convenience wrapper for `attributes`.
	public var someAttributes: JSONObject {
		return attributes ?? [:]
	}

	/// Convenience wrapper for `relationships`.
	public var someRelationships: JSONObject {
		return relationships ?? [:]
	}

	/// Convenience wrapper for `links`.
	public var someLinks: JSONObject {
		return links ?? [:]
	}

	/// Convenience wrapper for `meta`.
	public var someMeta: JSONObject {
		return meta ?? [:]
	}

}

extension APIResource {

	public func attribute<A>(_ key: KeyType) throws -> A where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> A? where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A] where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A?] where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A]? where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [String: A] where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [String: A]? where A: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> [MarshalDictionary] {
		return try someAttributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> [MarshalDictionary]? {
		return try someAttributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> MarshalDictionary {
		return try someAttributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> MarshalDictionary? {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> Set<A> where A: ValueType, A: Hashable {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> Set<A>? where A: ValueType, A: Hashable {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> A where A: RawRepresentable, A.RawValue: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> A? where A: RawRepresentable, A.RawValue: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A] where A: RawRepresentable, A.RawValue: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A]? where A: RawRepresentable, A.RawValue: ValueType {
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> Set<A>
		where A: Hashable, A: RawRepresentable, A.RawValue: ValueType
	{
		return try someAttributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> Set<A>?
		where A: Hashable, A: RawRepresentable, A.RawValue: ValueType
	{
		return try someAttributes.value(for: key)
	}

}

extension APIResource {

	public func related<R: Resource>(_ key: KeyType, from resourcePool: [APIResource]) throws -> Related<R>? {
		let relDoc = try SingleResourceDocument(object: someRelationships.value(for: key))

		if let resource = resourcePool.first(where: { $0.type == R.type && $0.id == relDoc.data?.id }) {
			return try Related(resource: R(resource: resource, included: resourcePool))
		} else if let id = relDoc.data?.id {
			return Related(id: id)
		} else {
			return nil
		}
	}

	public func related<R: Resource>(_ key: KeyType, from resourcePool: [APIResource]) throws -> [Related<R>] {
		let relDoc = try MultipleResourcesDocument(object: someRelationships.value(for: key))

		return try relDoc.someData.map { apiResource in
			if let resource = resourcePool.first(where: { $0.type == R.type && $0.id == apiResource.id }) {
				return try Related(resource: R(resource: resource, included: resourcePool))
			} else {
				return Related(id: apiResource.id)
			}
		}
	}

}
