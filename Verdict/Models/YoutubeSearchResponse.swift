//
//  YoutubeSearchResponse.swift
//  Netflix Clone
//
//  Created by Mekala Vamsi Krishna on 24/10/22.
//

import Foundation

struct YoutubeSearchResponse: Codable{
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
