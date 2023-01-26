//
//  HttpClientError.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 28/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation

class HttpClientError: Error {

    enum HttpClientErrorType {
        case unknown, invalidJSON, validationFailed, invalidRequest, apiRateLimit
    }

    var type: HttpClientErrorType = .unknown
    var httpStatusCode: Int?
    var localizedDescription: String?

    init(type: HttpClientErrorType, httpStatusCode: Int?, localizedDescription: String?) {
        self.type = type
        self.httpStatusCode = httpStatusCode
        self.localizedDescription = localizedDescription
    }

    init(withError error: Error) {
        self.httpStatusCode = nil
        self.localizedDescription = error.localizedDescription
    }

}
