//
//  Resource.swift
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

public protocol Resource {
	static var type: String { get }
	var id: String { get }
	init(resource: APIResource, document: APIDocument?) throws
}

extension Resource {

	public static func checkSanity(of resource: APIResource) throws {
		guard resource.type == type else {
			throw SanityError.resourceTypeMismatch(expected: type, actual: resource.type)
		}
	}

	public static func from(document: APIDocument) throws -> Self? {
		guard let resource = document.data.first else { return nil }

		return try Self(resource: resource, document: document)
	}

	public static func from(document: APIDocument) throws -> [Self] {
		return try document.data.map { try Self(resource: $0, document: document) }
	}

}
