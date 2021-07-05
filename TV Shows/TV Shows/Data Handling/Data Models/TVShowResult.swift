//
//  TVShowResult.swift
//  TV Shows
//
//  Created by Owen McGirr on 05/07/2021.
//

/// Represents a TV show result returned from the movie db.
struct TVShowResult: Identifiable, Codable {
    let id: Int? 
    let name: String?
    let overview: String?
    let poster_path: String?
    let backdrop_path: String?
    let vote_count: Int?
}
