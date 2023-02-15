//
//  NetworkService.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import Foundation

class NetworkService {
    func request(searchTerm: String, completion: @escaping (Result<Data?, Error?>) -> Void) {
        let parameters = self.prepareParameters(searchTerm: searchTerm)
        let url = self.url(params: parameters)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID WrLL6Mg-UXpHwxPvlouhG64T_jvR3b3_6D0eT6D4Vjs"
        return headers
    }
    
    private func prepareParameters(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        
        return parameters
    }
    
    private func url(params: [String: String]) -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.unsplash.com"
        components.path = "/search/photos"
        components.queryItems = params.map {
            URLQueryItem(name: $0, value: $1)}
        
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Result<Data?, Error?>) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                completion(Result(data, error))
            }
        }
    }
}
