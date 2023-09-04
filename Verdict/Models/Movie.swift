//
//  Movie.swift
//  Netflix Clone
//
//  Created by Mekala Vamsi Krishna on 27/06/22.
//

import Foundation

struct TrendingMovieResponse: Codable {
    let results: [Movie]
    let total_pages: Int?
}

struct Movie: Codable {
    let id: Int
    let media_layer: String?
    let title: String?
    let original_name: String?
    let original_title: String?
    let original_language: String?
    let poster_path: String?
    let overview: String?
    let vote_count: Int
    let release_date: String?
    let vote_average: Double
}
