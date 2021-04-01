// Created by Ina Statkic in 2021.

import Foundation

final class YouTubeManager {
    static let shared = YouTubeManager()
    
    private let apiKey = "API_KEY"
    private let searchPath = "https://www.googleapis.com/youtube/v3/search"
    
    func search(for term: String) -> Endpoint<SearchResponse> {
        return Endpoint<SearchResponse>(url: URL(string: searchPath)!, query: ["q":term, "key":apiKey, "part":"snippet", "type":"video", "videoDefinition":"high", "maxResults":"10"])
    }
    
    func searchNext(for term: String, next token: String) -> Endpoint<SearchResponse> {
        return Endpoint<SearchResponse>(url: URL(string: searchPath)!, query: ["q":term, "key":apiKey, "part":"snippet", "type":"video", "videoDefinition":"high", "pageToken":token, "maxResults":"10"])
    }
}
