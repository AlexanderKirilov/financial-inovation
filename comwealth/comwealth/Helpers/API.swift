//
//  API.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 22.10.23.
//

import Foundation

enum API {
    static private let scheme = "https"
    static private let baseURL = "055c6ca89da8e1.lhr.life"
    static private let endpoint = "suggestions"
    
    static func fetchSuggestions(for survey: Survey, then handler: @escaping (Result<Data, Error>) -> Void) { // replace Data with [Ticker]
        let url = URL(string: "\(scheme)://\(baseURL)/\(endpoint)")!
        let body = (try? JSONEncoder().encode(survey)) ?? Data()
        sendPostRequest(to: url, body: body) { result in
            
            
            
            // do parsing
            handler(result)
        }
    }
    
    static private func sendPostRequest(to url: URL,
                                        body: Data,
                                        then handler: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        request.httpBody = body
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                handler(.failure(error!))
                return
            }
            handler(.success(data))
        }
        task.resume()
    }
}
