//
//  ResponseModels.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation

// MARK: - PexelAPIResponse
struct PexelAPIResponse: Codable {
    let page: Int?
    let perPage: Int?
    let photos: [Photo]?
    let totalResults: Int?
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case perPage = "per_page"
        case photos = "photos"
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}

// MARK: - Photo
struct Photo: Codable {
    let id: Int?
    let width: Int?
    let height: Int?
    let url: String?
    let photographer: String?
    let photographerurl: String?
    let photographerid: Int?
    let avgColor: String?
    let src: Src?
    let liked: Bool?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case width = "width"
        case height = "height"
        case url = "url"
        case photographer = "photographer"
        case photographerurl = "photographer_url"
        case photographerid = "photographer_id"
        case avgColor = "avg_color"
        case src = "src"
        case liked = "liked"
    }
}

// MARK: - Src
struct Src: Codable {
    let original: String?
    let large2X: String?
    let large: String?
    let medium: String?
    let small: String?
    let portrait: String?
    let landscape: String?
    let tiny: String?

    enum CodingKeys: String, CodingKey {
        case original = "original"
        case large2X = "large2x"
        case large = "large"
        case medium = "medium"
        case small = "small"
        case portrait = "portrait"
        case landscape = "landscape"
        case tiny = "tiny"
    }
}
