//: Playground - noun: a place where people can play

//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct StoreItems {
    var kind: String
    

    init?(json: [String: Any]) {
        guard let kind = json["kind"] as? String else { return nil }
        
        self.kind = kind
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
    
    if let data = data,
        let rawJSON = try? JSONSerialization.jsonObject(with: data),
        let json = rawJSON as? [String: Any],
        let resultsArray = json["results"] as? [[String: Any]] {
        
        //print("\n\nrawJSON: \(rawJSON)\n\n")
        //print("\n\njson: \(json)\n\n")
        //print("\n\nresultsArray: \(resultsArray)")
        
        let items = resultsArray.flatMap { StoreItems(json: $0)}
        
        print("num items: \(items.count)")
        for item in items {
            print(item)
        }
    }
}
    
task.resume()
