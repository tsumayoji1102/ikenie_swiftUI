//
//  ApiClient.swift
//  ikenie_ios
//
//  Created by 塩見陵介 on 2025/05/18.
//

import Foundation

class ApiClient {
    static let shared = ApiClient()
    private let session: URLSession = .shared
    
    private let baseUrlString = "https://api.example.com"
    
    func sendRequest<T: Decodable>(path: String, object: T) async throws  {
        guard let url = URL(string: baseUrlString)?.appendingPathComponent(path) else {
            return
        }
        let request = URLRequest(url: url)
//            
//            let (data, response) = try await session.data(for: request)
//            
//            guard let httpResponse = response as? HTTPURLResponse else {
//                throw NetworkError.invalidResponse
//            }
//            
//            switch httpResponse.statusCode {
//            case 200...299:
//                do {
//                    return try JSONDecoder().decode(T.self, from: data)
//                } catch {
//                    throw NetworkError.decodingFailed(error)
//                }
//            case 401:
//                throw NetworkError.unauthorized
//            case 404:
//                throw NetworkError.notFound
//            default:
//                throw NetworkError.serverError(statusCode: httpResponse.statusCode)
//            }
        }
}
