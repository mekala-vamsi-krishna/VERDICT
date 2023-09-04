//
//  MovieDetail.swift
//  Verdict
//
//  Created by Mekala Vamsi Krishna on 9/3/23.
//

import Foundation

struct MovieDetail: Codable {
  let id: Int?
  let backdrop_path: String?
  let budget: Int
  let homepage: String
  let original_language: String
  let original_title: String?
  let overview: String
  let popularity: Double
  let poster_path: String?
  let production_companies: [ProductionCompanies]
  let release_date: String
  let revenue: Int
  let runtime: Int
  let status: String
  let tagline: String
  let title: String?
  let vote_average: Double
  let vote_count: Int
}

struct ProductionCompanies: Codable {
    let id: Int
    let logo_path: String?
    let name: String
    let origin_country: String
}
