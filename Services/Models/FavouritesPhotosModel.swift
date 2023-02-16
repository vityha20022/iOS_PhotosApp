//
//  FavouritesPhotosModel.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 16.02.2023.
//

import Foundation

let favouritesDataKey = "favouritesData"

var favouritesPhotosList: [String: GettingPhotoResults] {
    get {
        guard let decodedfavouritesData = UserDefaults.standard.data(forKey: favouritesDataKey) else {
            return [String: GettingPhotoResults]()
        }

        let encodedFavouritesData = try! PropertyListDecoder().decode([String: GettingPhotoResults].self, from: decodedfavouritesData)

        return encodedFavouritesData
    }

    set {
        let encodedFavourite = try! PropertyListEncoder().encode(newValue)
        UserDefaults.standard.set(encodedFavourite, forKey: favouritesDataKey)
        UserDefaults.standard.synchronize()
    }
}

func isFavouritePhoto(id: String) -> Bool {
    return favouritesPhotosList[id] != nil
}

func addFavouritePhoto(id: String, photo: GettingPhotoResults) {
    favouritesPhotosList[id] = photo
}

func removeFavouritePhoto(id: String) {
    favouritesPhotosList.removeValue(forKey: id)
}

func getFavouritePhoto(id: String) -> GettingPhotoResults? {
    return favouritesPhotosList[id]
}

func getFavouritesPhotosCount() -> Int {
    return favouritesPhotosList.count
}
