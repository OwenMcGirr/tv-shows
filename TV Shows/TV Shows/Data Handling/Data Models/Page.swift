//
//  Page.swift
//  TV Shows
//
//  Created by Owen McGirr on 05/07/2021.
//

/// Represents a page returned by the movie db. 
struct Page: Codable {
    let page: Int? // page number
    let results: [TVShowResult]? 
}
