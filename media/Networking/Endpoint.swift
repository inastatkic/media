// Created by Ina Statkic in 2021.

import Foundation
import Combine

public func expected200to300(_ code: Int) -> Bool {
    return code >= 200 && code < 300
}

public struct Endpoint<A> {
    var urlRequest: URLRequest
    var convert: (Data?, URLResponse?) -> Result<A, Error>
    var expectedStatusCode: (Int) -> Bool = expected200to300
    
    public init(urlRequest: URLRequest, expectedStatusCode: @escaping (Int) -> Bool, convert: @escaping (Data?, URLResponse?) -> Result<A, Error>) {
        self.urlRequest = urlRequest
        self.expectedStatusCode = expectedStatusCode
        self.convert = convert
    }
    
    public init(url: URL, headers: [String:String] = [:], expectedStatusCode: @escaping (Int) -> Bool = expected200to300, query: [String:String] = [:], convert: @escaping (Data?, URLResponse?) -> Result<A, Error>) {
        var requestURL: URL
        if query.isEmpty { requestURL = url } else {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = components.queryItems ?? []
            components.queryItems!.append(contentsOf: query.map { URLQueryItem(name: $0.0, value: $0.1) })
            requestURL = components.url!
        }
        urlRequest = URLRequest(url: requestURL)
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
        self.expectedStatusCode = expectedStatusCode
        self.convert = convert
    }
}

extension Endpoint where A: Decodable {
    public init(url: URL, expectedStatusCode: @escaping (Int) -> Bool = expected200to300, query: [String:String] = [:]) {
        self.init(url: url, expectedStatusCode: expectedStatusCode, query: query) { data, _ in
            return Result {
                guard let resultData = data else { throw NetworkError.noData }
                return try JSONDecoder().decode(A.self, from: resultData)
            }
        }
        
    }
}

public enum NetworkError: Error {
    case invalidResponse
    case noData
    case satusCode(Int)
}

extension URLSession {
    public func load<A>(_ endpoint: Endpoint<A>, onComplete: @escaping (Result<A, Error>) -> ()) {
        dataTask(with: endpoint.urlRequest, completionHandler: { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                onComplete(.failure(NetworkError.invalidResponse))
                return
            }
            guard endpoint.expectedStatusCode(httpResponse.statusCode) else {
                onComplete(.failure(NetworkError.satusCode(httpResponse.statusCode)))
                return
            }
            onComplete(endpoint.convert(data, response))
        }).resume()
    }
    
    public func load<A>(_ endpoint: Endpoint<A>) -> AnyPublisher<A, Error> {
            let urlRequest = endpoint.urlRequest
            return dataTaskPublisher(for: urlRequest)
                .tryMap { data, response in
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw NetworkError.invalidResponse
                    }
                    guard endpoint.expectedStatusCode(httpResponse.statusCode) else {
                        throw NetworkError.satusCode(httpResponse.statusCode)
                    }
                    return try endpoint.convert(data, response).get()
            }
            .eraseToAnyPublisher()
        }
}
