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
	init(resource: APIResource, included: [APIResource]) throws
}

extension Resource {

	public static func checkSanity(for resource: APIResource) throws {
		guard resource.type == type else {
			throw SanityError.resourceTypeMismatch(expected: type, actual: resource.type)
		}
	}

	public init?<D: APIDocument>(document: D) throws where D.Resource == APIResource {
		guard let resource = document.data else { return nil }

		try self.init(resource: resource, included: document.someIncluded)
	}

}

extension Array where Element: Resource {

	public init<D: APIDocument>(document: D) throws where D.Resource == [APIResource] {
		try self.init(document.someData.map { try Element(resource: $0, included: document.someIncluded) })
	}

}

public struct Related<R: Resource> {

	public let id: String
	public let value: R?

	public init(id: String) {
		self.id = id
		value = nil
	}

	public init(resource: R) {
		id = resource.id
		value = resource
	}

}
