//
//  NetworkManager.swift
//  Anime
//
//  Created by Anthony on 4/3/21.
//

import UIKit

class NetworkManager {

    static func getAnimeResults(searchTerm: String, completion:( @escaping (_ animeResults: [AnimeResult]?) -> Void)) {

        // Temporary struct to get the AnimeResult array inside json object that is returned
        struct SearchResponse: Decodable {
            let results: [AnimeResult]
        }

        guard let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            print("Can't encode search term")
            completion(nil)
            return
        }

        guard let url = URL(string: "https://api.jikan.moe/v3/search/anime?q=\(escapedString)") else {
            print("Can't create url")
            completion(nil)
            return
        }
        
        var request = URLRequest(url: url,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(nil)
                return
            }

            // Decode the json objects into an array
            let decoder = JSONDecoder()

            do {
                let searchResults = try decoder.decode(SearchResponse.self, from: data)
                completion(searchResults.results)
            } catch {
                print(error.localizedDescription)
                completion(nil)
            }
        }

        task.resume()
    }

    static func getImage(url: String, completion:( @escaping (_ imageData: Data?) -> Void)) {
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                completion(nil)
                return
            }
            completion(data)
        }

        task.resume()
    }

}
