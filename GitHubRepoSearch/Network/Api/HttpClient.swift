//
//  HttpClient.swift
//  GitHubRepoSearch
//
//  Created by Bojan Gaspar on 28/04/2020.
//  Copyright © 2020 UltraDev. All rights reserved.
//

import Foundation

enum HttpMethod: String {
    case get, post, put, patch, delete
}

let host = URL(string: "https://api.github.com/")

class HttpClient {

    var session: URLSession = URLSession(configuration: .default)

    func createRequest(forMethod method: HttpMethod, path: String) -> URLRequest? {
        guard let url = URL(string: path, relativeTo: host) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        #if DEBUG
            print("----------\nRequest:\n\(method.rawValue) \(url.absoluteString)\n----------")
        #endif
        return request
    }

    func loadData(path: String, method: HttpMethod = .get, additionalHeaders: [String: Any]? = nil, query: [String: String]? = nil, completion: @escaping (HttpClientError?, Data?) -> Void) {

        guard let request = createRequest(forMethod: method, path: path) else {
            completion(HttpClientError(type: .invalidRequest, httpStatusCode: nil, localizedDescription: "Couldn't create request"), nil)
            return
        }

        let dataTask = session.dataTask(with: request) { (data, response, error) in

            #if DEBUG
                var jsonResponse: NSString = ""
                if let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []), let jsonData = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted), let string = String(data: jsonData, encoding: .utf8) {
                    jsonResponse = string as NSString
                }
                print("Response:\n\((response as? HTTPURLResponse)?.statusCode ?? 0)\n\(jsonResponse)\n----------\n")
            #endif

            DispatchQueue.main.async {
                if let error = error {
                    completion(HttpClientError(withError: error), nil)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(HttpClientError(type: .unknown, httpStatusCode: nil, localizedDescription: "Api didn't return a valid http response"), data)
                    return
                }

                switch httpResponse.statusCode {
                case 200...299:

                    guard let data = data else {
                        completion(HttpClientError(type: .unknown, httpStatusCode: httpResponse.statusCode, localizedDescription: "The response doesn't contain any data"), nil)
                        return
                    }
                    completion(nil, data)
                case 403:
                    completion(HttpClientError(type: .apiRateLimit, httpStatusCode: httpResponse.statusCode, localizedDescription: "API rate limit exceeded"), nil)
                case 433:
                    completion(HttpClientError(type: .invalidRequest, httpStatusCode: httpResponse.statusCode, localizedDescription: "The search parameter is required"), nil)
                default:
                    completion(HttpClientError(type: .unknown, httpStatusCode: nil, localizedDescription: nil), data)
                }
            }

        }
        dataTask.resume()
    }
}
