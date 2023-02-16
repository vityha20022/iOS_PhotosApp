//
//  NetworkDataFetcher.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import Foundation

class NetworkDataFetcher {
    var networkService = NetworkService()

    // MARK: - Fetch functions

    func fetchSearchImages(searchTerm: String, completion: @escaping (UnsplashSearchPhotosResults?) -> Void) {
        networkService.requestSearchingPhoto(searchTerm: searchTerm) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: UnsplashSearchPhotosResults.self, from: data)
            completion(decode)
        }
    }

    func fetchRandomImages(completion: @escaping ([UnsplashSearchPhoto]?) -> Void) {
        networkService.requestGettingRandomPhotos { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: [UnsplashSearchPhoto].self, from: data)
            completion(decode)
        }
    }

    func fetchImage(id: String, completion: @escaping (UnsplashPhoto?) -> Void) {
        networkService.requestGettingPhoto(id: id) { data, error in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                completion(nil)
            }

            let decode = self.decodeJSON(type: UnsplashPhoto.self, from: data)
            completion(decode)
        }
    }

    // MARK: - JSON functions

    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else {
            return nil
        }

        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
