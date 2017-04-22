//
//  Extraction.swift
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

extension APIResource {

	// MARK: - Attribute extractors

	public func attribute<A>(_ key: KeyType) throws -> A where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> A? where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A] where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A]? where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A?] where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A?]? where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [String: A] where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [String: A]? where A: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> MarshalDictionary {
		return try attributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> MarshalDictionary? {
		return try attributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> [MarshalDictionary] {
		return try attributes.value(for: key)
	}

	public func attribute(_ key: KeyType) throws -> [MarshalDictionary]? {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> A where A: RawRepresentable, A.RawValue: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> A? where A: RawRepresentable, A.RawValue: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A] where A: RawRepresentable, A.RawValue: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A]? where A: RawRepresentable, A.RawValue: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A?] where A: RawRepresentable, A.RawValue: ValueType {
		return try attributes.value(for: key)
	}

	public func attribute<A>(_ key: KeyType) throws -> [A?]? where A: RawRepresentable, A.RawValue: ValueType {
		return try attributes.value(for: key)
	}

	// MARK: - Relationship extractors

	public func asRelated<R>(in document: APIDocument?) throws -> Related<R> where R: Resource {
		let resource = document?.included.first(where: { $0 == self }) ?? self
		return try Related(resource: resource, document: document)
	}

	public func related<R>(_ key: KeyType, in document: APIDocument?) throws -> Related<R>? where R: Resource {
		let data = try APIDocument(object: relationships.value(for: key)).data
		return try data.first.map { try $0.asRelated(in: document) }
	}

	public func related<R>(_ key: KeyType, in document: APIDocument?) throws -> [Related<R>] where R: Resource {
		let data = try APIDocument(object: relationships.value(for: key)).data
		return try data.map { try $0.asRelated(in: document) }
	}

}
