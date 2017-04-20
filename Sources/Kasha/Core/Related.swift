//
//  Related.swift
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

public enum Related<R: Resource>: Resource {

	case resource(R)
	case identifier(ResourceIdentifier<R>)

	public static var type: String {
		return R.type
	}

	public var id: String {
		switch self {
		case .resource(let resource): return resource.id
		case .identifier(let identifier): return identifier.id
		}
	}

	public var resource: R? {
		switch self {
		case .resource(let resource): return resource
		case .identifier: return nil
		}
	}

	public init(resource: APIResource, document: APIDocument?) throws {
		try R.checkSanity(of: resource)
		if let res = try? R(resource: resource, document: document) {
			self = .resource(res)
		} else if let res = try? ResourceIdentifier<R>(resource: resource, document: document) {
			self = .identifier(res)
		} else {
			throw SanityError.other
		}
	}

}
