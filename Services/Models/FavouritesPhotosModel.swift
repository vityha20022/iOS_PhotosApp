//
//  FavouritesPhotosModel.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 16.02.2023.
//

import Foundation

let favouritesDataKey = "favouritesData"

var favouritesPhotos: [String: GettingPhotoResults] {
    get {
        guard let decodedFavouritesData = UserDefaults.standard.data(forKey: favouritesDataKey) else {
            return [String: GettingPhotoResults]()
        }

        let encodedFavouritesData = try! PropertyListDecoder().decode([String: GettingPhotoResults].self, from: decodedFavouritesData)

        return encodedFavouritesData
    }

    set {
        let encodedFavourite = try! PropertyListEncoder().encode(newValue)
        UserDefaults.standard.set(encodedFavourite, forKey: favouritesDataKey)
        UserDefaults.standard.synchronize()
    }
}

func isFavouritePhoto(id: String) -> Bool {
    return favouritesPhotos[id] != nil
}

func addFavouritePhoto(id: String, photo: GettingPhotoResults) {
    favouritesPhotos[id] = photo
}

func removeFavouritePhoto(id: String) {
    favouritesPhotos.removeValue(forKey: id)
}

func getFavouritePhoto(id: String) -> GettingPhotoResults? {
    return favouritesPhotos[id]
}

func getFavouritesPhotosList() -> [GettingPhotoResults] {
    var favouritesPhotosList = Array(favouritesPhotos.values)
    favouritesPhotosList.sort { first, second in
        return first.user.name < second.user.name
    }
    
    return favouritesPhotosList
}

func getFavouritesPhotosCount() -> Int {
    return favouritesPhotos.count
}
