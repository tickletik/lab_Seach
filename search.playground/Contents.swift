//: Playground - noun: a place where people can play

//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct StoreItems {
    
    var name: String
    var artist: String
    var description: String
    var kind: String
    var artworkURL: URL
    

    init?(json: [String: Any]) {
        guard let kind = json["kind"] as? String,
            let name = json["trackName"] as? String,
            let artist = json["artistName"] as? String,
            let artworkURLString = json["artworkUrl100"] as? String,
            let artworkURL = URL(string: artworkURLString) else { return nil }
        
        self.kind = kind
        self.name = name
        self.artist = artist
        self.artworkURL = artworkURL

        self.description = json["description"] as? String ?? json["longDescription"] as? String ?? ""

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

func fetchItems(matching query: [String: String], completion: @escaping ([StoreItems]?) -> Void ) {
    let baseURL = URL(string: "https://itunes.apple.com/search?")


    let searchURL = baseURL?.withQueries(query)!
    // print(searchURL)

    let task = URLSession.shared.dataTask(with: searchURL!) { (data, response, error) in
        
        if let data = data,
            let rawJSON = try? JSONSerialization.jsonObject(with: data),
            let json = rawJSON as? [String: Any],
            let resultsArray = json["results"] as? [[String: Any]] {
            
            //print("\n\nrawJSON: \(rawJSON)\n\n")
            //print("\n\njson: \(json)\n\n")
            //print("\n\nresultsArray: \(resultsArray)")
            
            let items = resultsArray.flatMap { StoreItems(json: $0)}
            
            completion(items)
        } else {
            print("no data was returned, or data was not serialized")
            completion(nil)
        }
    }
        
    task.resume()
}

let query: [String: String] = [
    "term": "Inside Out 2015",
    "media": "movie",
    "lang": "en_us",
    "limit": "10"
]

fetchItems(matching: query) { (items) in
    if let items = items {
        print("num items: \(items.count)")
    } else {
        print("nothin received")
    }
}
