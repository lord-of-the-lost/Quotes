//
//  NetworkService.swift
//  Quotes
//
//  Created by Николай Игнатов on 18.02.2025.
//

import Foundation

// MARK: - NetworkServiceProtocol
protocol NetworkServiceProtocol {
    func fetchData(completion: @escaping (Result<QuoteModel, Error>) -> Void)
}

// MARK: - NetworkError
enum NetworkError: Error {
    case badURL, badResponse, invalidData, decodeError
}

// MARK: - NetworkService
final class NetworkService: NetworkServiceProtocol {
    private let baseURL = "https://api.api-ninjas.com"
    
    func fetchData(completion: @escaping (Result<QuoteModel, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/v1/quotes") else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("GjzH6TPla1aQTHkwdGUczA==3XqJrf3rVQjP8stn", forHTTPHeaderField: "X-Api-Key")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let _ = error {
                completion(.failure(NetworkError.badResponse))
                return
            }
            
            guard let data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            do {
                let response = try JSONDecoder().decode([QuoteModel].self, from: data)
                if let quote = response.first {
                    completion(.success(quote))
                } else {
                    completion(.failure(NetworkError.invalidData))
                }
            } catch {
                completion(.failure(NetworkError.decodeError))
            }
        }.resume()
    }
}
