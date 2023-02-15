//
//  NetworkService.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import Foundation

class NetworkService {
    func requestData(params: [String: String]?, scheme: String, host: String, path: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = self.url(params: params, scheme: scheme, host: host, path: path)
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = prepareHeaders()
        request.httpMethod = "get"
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    func requestSearchingPhoto(searchTerm: String, completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParametersForSearchingPhoto(searchTerm: searchTerm)
        requestData(params: parameters, scheme: "https", host: "api.unsplash.com", path: "/search/photos", completion: completion)
    }
    
    func requestGettingPhoto(id: String, completion: @escaping (Data?, Error?) -> Void) {
        requestData(params: nil, scheme: "https", host: "api.unsplash.com", path: "/photos/" + id, completion: completion)
    }
    
    func requestGettingRandomPhotos(completion: @escaping (Data?, Error?) -> Void) {
        let parameters = self.prepareParametersForGettingRandomPhotos()
        requestData(params: parameters, scheme: "https", host: "api.unsplash.com", path: "/photos/random", completion: completion)
    }
    
    private func prepareHeaders() -> [String: String]? {
        var headers = [String: String]()
        headers["Authorization"] = "Client-ID WrLL6Mg-UXpHwxPvlouhG64T_jvR3b3_6D0eT6D4Vjs"
        return headers
    }
    
    private func prepareParametersForSearchingPhoto(searchTerm: String?) -> [String: String] {
        var parameters = [String: String]()
        parameters["query"] = searchTerm
        parameters["page"] = String(1)
        parameters["per_page"] = String(30)
        
        return parameters
    }
    
    private func prepareParametersForGettingRandomPhotos() -> [String: String] {
        var parameters = [String: String]()
        parameters["count"] = String(30)
        
        return parameters
    }
    
    private func url(params: [String: String]?, scheme: String, host: String, path: String) -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        if let params = params {
            components.queryItems = params.map {
                URLQueryItem(name: $0, value: $1)}
        }
        
        return components.url!
    }
    
    private func createDataTask(from request: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
}
