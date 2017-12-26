//: Playground - noun: a place where people can play

//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true


struct StoreItems: Codable {
    let results: [StoreItem]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        results = try values.decode([StoreItem].self, forKey: CodingKeys.results)
    }
}

struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var artworkURL: URL?
    
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case artworkURL = "artistUrl100"
        case description
    }
    
    enum AdditionalKeys: String, CodingKey {
        case longDescription
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
    
        name = try values.decode(String.self, forKey: CodingKeys.name)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try values.decode(URL.self, forKey: CodingKeys.artworkURL)

        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)

            self.description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }
    }
    

    init?(json: [String: Any]) {
        guard let kind = json["kind"] as? String,
            let name = json["trackName"] as? String,
            let artist = json["artistName"] as? String,
            let artworkURLString = json["artworkUrl100"] as? String
                else { return nil }
        
        self.kind = kind
        self.name = name
        self.artist = artist
        self.description = "no description code for init(json)"
        
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
    
    print("in task")
    if let data = data,
        let rawJSON = try? JSONSerialization.jsonObject(with: data) {
        print(rawJSON)
        if let storeItems = try? jsonDecoder.decode(StoreItems.self, from: data) {
            print("got store items")
        }
        print("hi")
    }
}

func fetchItems(matching query: [String: String], completion: @escaping ([StoreItem]?) -> Void) {}

task.resume()
