//
//  SearchResults.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import Foundation

struct SearchPhotosResults: Decodable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct GettingPhotoResults: Decodable {
    // swiftlint: disable identifier_name
    let created_at: String
    // swiftlint: enable identifier_name
    let downloads: Int
    let location: PhotoLocation
    let user: PhotoAuthor
}

struct UnsplashPhoto: Decodable {
    let id: String
    let width: Int
    let height: Int
    
    let urls: [URLKind.RawValue: String]
    
    enum URLKind: String {
        case raw
        case full
        case regular
        case small
        case thumb
    }
}

struct PhotoLocation: Decodable {
    let name: String
}

struct PhotoAuthor: Decodable {
    let name: String
}
