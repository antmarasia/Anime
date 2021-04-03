//
//  AnimeResult.swift
//  Anime
//
//  Created by Anthony on 4/3/21.
//

import Foundation

struct AnimeResult: Codable {

    // MARK: - Properties

    let imageURL: String
    let title: String
    let synopsis: String
    let type: String
    let episodes: Int
    let score: Double

    // MARK: - Coding Keys

    enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        case title
        case synopsis
        case type
        case episodes
        case score
    }
}
