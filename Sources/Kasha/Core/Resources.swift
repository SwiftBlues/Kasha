//
//  Resources.swift
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

	public func related<R: Resource>(_ key: KeyType, context: APIDocument?) throws -> Related<R>? {
		let document = try APIDocument(object: someRelationships.value(for: key))

		return try document.someData.first.map { try makeRelated(key, candidate: $0, context: context) }
	}

	public func related<R: Resource>(_ key: KeyType, context: APIDocument?) throws -> [Related<R>] {
		let document = try APIDocument(object: someRelationships.value(for: key))

		return try document.someData.map { try makeRelated(key, candidate: $0, context: context) }
	}

	fileprivate func makeRelated<R: Resource>(
		_ key: KeyType,
		candidate: APIResource,
		context: APIDocument?) throws
		-> Related<R>
	{
		try R.checkSanity(for: candidate)

		return try Related(key, id: candidate.id, value: context?.someIncluded
			.first { $0.type == R.type && $0.id == candidate.id }
			.map { try R(resource: $0, context: context) })

	}

}

public struct Related<R: Resource> {

	public static var type: String {
		return R.type
	}

	public let key: KeyType
	public let id: String
	public let value: R?

	init(_ key: KeyType, id: String, value: R? = nil) {
		self.key = key
		self.id = id
		self.value = value
	}

}

public protocol Resource {
	static var type: String { get }
	var id: String { get }
	init(resource: APIResource, context: APIDocument?) throws
}

extension Resource {

	public static func checkSanity(for resource: APIResource) throws {
		guard resource.type == type else {
			throw SanityError.resourceTypeMismatch(expected: type, actual: resource.type)
		}
	}

	public static func make(context: APIDocument) throws -> Self? {
		guard let resource = context.someData.first else { return nil }

		return try Self(resource: resource, context: context)
	}

	public static func make(context: APIDocument) throws -> [Self] {
		return try context.someData.map { try Self(resource: $0, context: context) }
	}

}
