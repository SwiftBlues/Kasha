//
//  Models.swift
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

import Kasha

struct Article: Resource {

	static let type = "articles"

	let id: String
	let title: String
	let author: Related<Author>?
	let comments: [Related<Comment>]

	init(resource: APIResource, included: [APIResource] = []) throws {
		try Article.checkSanity(for: resource)

		id = resource.id
		title = try resource.attribute("title")
		author = try resource.related("author", from: included)
		comments = try resource.related("comments", from: included)
	}

}

public struct Author: Resource {

	public static let type = "people"

	public let id: String
	let firstName: String
	let lastName: String
	let twitter: String?
	let articles: [Related<Article>]

	public init(resource: APIResource, included: [APIResource] = []) throws {
		try Author.checkSanity(for: resource)

		id = resource.id
		firstName = try resource.attribute("first-name")
		lastName = try resource.attribute("last-name")
		twitter = try resource.attribute("twitter")
		articles = try resource.related("articles", from: included)
	}

}

struct Comment: Resource {

	static let type = "comments"

	let id: String
	let body: String
	let author: Related<Author>?

	init(resource: APIResource, included: [APIResource] = []) throws {
		try Comment.checkSanity(for: resource)

		id = resource.id
		body = try resource.attribute("body")
		author = try resource.related("author", from: included)
	}

}
