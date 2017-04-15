//
//  Errors.swift
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

import protocol Foundation.LocalizedError

public enum SpecViolationError: Error {

	/// Document doesn’t contain any of the `data`, `errors`, or `meta` top-level members.
	case topLevelMemberMissing

	/// Top-level members `data` and `errors` coexist in the same document.
	case topLevelDataAndErrorsCoexist

	/// Top-level `included` document is present while top-level `data` member is missing.
	case topLevelIncludedPresentWhileDataMissing

}

extension SpecViolationError: LocalizedError { // MARK: LocalizedError

	public var errorDescription: String? {
		switch self {
		case .topLevelMemberMissing:
			return "Document doesn’t contain any of the `data`, `errors`, or `meta` top-level members."
		case .topLevelDataAndErrorsCoexist:
			return "Top-level members `data` and `errors` coexist in the same document."
		case .topLevelIncludedPresentWhileDataMissing:
			return "Top-level `included` document is present while top-level `data` member is missing."
		}
	}

}

// MARK: -

public enum SanityError: Error {

	case resourceTypeMismatch(expected: String, actual: String)

	case noResources

	case multipleResources

}

extension SanityError: LocalizedError { // MARK: LocalizedError

	public var errorDescription: String? {
		switch self {
		default:
			return nil
		}
	}

}
