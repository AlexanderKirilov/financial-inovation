//
//  API.swift
//  Comwealth
//
//  Created by Alexander Karaatanasov on 22.10.23.
//

import Foundation

enum API {
    static private let scheme = "http"
    static private let baseURL = "0.0.0.0:9001"
    static private let endpoint = "suggestions"
    
    static func fetchSuggestions(for survey: Survey, then handler: @escaping (Result<[Ticker], Error>) -> Void) {
        let url = URL(string: "\(scheme)://\(baseURL)/\(endpoint)")!
        let body = (try? JSONEncoder().encode(survey)) ?? Data()
        sendPostRequest(to: url, body: body) { result in
            switch result {
            case .failure(let error):
                handler(.failure(error))
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(SuggestionResponse.self, from: data)
                    handler(.success(response.data))
                } catch {
                    handler(.failure(error))
                }
            }
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
