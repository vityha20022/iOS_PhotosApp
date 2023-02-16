//
//  SearchResults.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import Foundation

struct SearchPhotosResults: Codable {
    let total: Int
    let results: [UnsplashPhoto]
}

struct GettingPhotoResults: Codable {
    let id: String
    // swiftlint: disable identifier_name
    let created_at: String
    // swiftlint: enable identifier_name
    let downloads: Int
    let location: PhotoLocation
    let user: PhotoAuthor
}

struct UnsplashPhoto: Codable {
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

struct PhotoLocation: Codable {
    let country: String?
}

struct PhotoAuthor: Codable {
    let name: String
}
