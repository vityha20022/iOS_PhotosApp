//
//  SearchResults.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import Foundation

enum URLKind: String {
    case raw
    case full
    case regular
    case small
    case thumb
}

struct UnsplashSearchPhotosResults: Codable {
    let total: Int
    let results: [UnsplashSearchPhoto]
}

struct UnsplashPhoto: Codable {
    let id: String
    let width: Int
    let height: Int
    // swiftlint: disable identifier_name
    let created_at: String
    // swiftlint: enable identifier_name
    let downloads: Int
    let location: UnsplashPhotoLocation
    let user: UnsplashPhotoAuthor
    let urls: [URLKind.RawValue: String]
}

struct UnsplashSearchPhoto: Codable {
    let id: String
    let width: Int
    let height: Int
    let urls: [URLKind.RawValue: String]
}

struct UnsplashPhotoLocation: Codable {
    let country: String?
}

struct UnsplashPhotoAuthor: Codable {
    let name: String
}
