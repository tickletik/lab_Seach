//: Playground - noun: a place where people can play

//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct StoreInfo: Codable {
    var kind: String
    
    enum CodingKeys: String, CodingKey {
        case kind
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.kind = try valueContainer.decode(String.self, forKey: CodingKeys.kind)
    }
}


/*
struct StoreItem: Codable {
    var kind: String
    /*
    var trackId: Int
    var artistName: String
    var trackName: String
    //var previewURL: URL
    var shortDescription: String
    var longDescription: String
    //var hasITunesExtras: Bool
    */
    
    enum CodingKeys: String, CodingKey {
        case kind
        case trackId
        case artistName
        case trackName
        //case previewURL
        case shortDescription
        case longDescription
        //case hasITunesExtras
    }
 
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        
        self.kind = try valueContainer.decode(String.self, forKey: CodingKeys.kind)
    }
}
*/

extension URL {
    func withQueries(_ queries: [String: String]) -> URL? {
        /// returns a properly formed url with all the additions
        /// query requests on it
        
        /// the URL is meant to be used as an REST or POST request
        
        var components = URLComponents(url: self, resolvingAgainstBaseURL: true)
        components?.queryItems = queries.flatMap { URLQueryItem(name: $0.0, value: $0.1)  }
        
        return components?.url
    }
}

let baseURL = URL(string: "https://itunes.apple.com/search?")

let queryDict: [String: String] = [
    "term": "Inside Out 2015",
    "media": "movie",
    "lang": "en_us",
    "limit": "10"
]

let searchURL = baseURL?.withQueries(queryDict)!

let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
    
    
    let jsonDecoder = JSONDecoder()
    
    if let data = data,
        let string = String(data: data, encoding: .utf8),
        let info = try? jsonDecoder.decode(StoreInfo.self, from: data) {
     
        print(string)
        print(info)
        
        PlaygroundPage.current.finishExecution()
    }
}

task.resume()
