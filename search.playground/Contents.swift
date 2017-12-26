//: Playground - noun: a place where people can play

//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct StoreItems: Codable {
    var name: String
    var artist: String
    var kind: String
    var artworkURL: URL?
    
    
    

    init?(json: [String: Any]) {
        guard let kind = json["kind"] as? String,
            let name = json["trackName"] as? String,
            let artist = json["artistName"] as? String,
            let artworkURLString = json["artworkUrl100"] as? String
                else { return nil }
        
        self.kind = kind
        self.name = name
        self.artist = artist
        
        if let artworkURL = URL(string: artworkURLString) {
            self.artworkURL = artworkURL
        } else {
            self.artworkURL = nil
        }
    }
}


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
// print(searchURL)

let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
    
    let jsonDecoder = JSONDecoder()
    
    if let data = data {
        print("hi")
    }
}
    
task.resume()
