// Created by Ina Statkic in 2021.

import Foundation

struct Video: Identifiable, Codable {
    var id: String
    var title: String
    var description: String
    var thumbnail: URL?
    var image: URL?
}

extension Video {
    init(from searchResult: SearchResult) {
        id = searchResult.id.videoId
        title = searchResult.snippet.title
        description = searchResult.snippet.description
        thumbnail = URL(string: searchResult.snippet.thumbnails.medium.url)
        image = URL(string: searchResult.snippet.thumbnails.high.url)
    }
}

struct SearchResult: Decodable {
    let id: Id
    let snippet: Snippet
    
    struct Snippet: Decodable {
        let title: String
        let description: String
        let thumbnails: Thumbnails
        
        struct Thumbnails: Decodable {
            let medium: Image
            let high: Image
            
            struct Image: Decodable {
                let url: String
            }
        }
    }
    
    struct Id: Decodable {
        let videoId: String
    }
}

struct SearchResponse: Decodable {    
    let items: [SearchResult]
    let pageInfo: Info
    let nextPageToken: String
    
    struct Info: Decodable {
        let resultsPerPage: Int
    }
}
