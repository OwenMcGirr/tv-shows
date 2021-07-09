//
//  TVShowDetailViewModel.swift
//  TV Shows
//
//  Created by Owen McGirr on 08/07/2021.
//

import SwiftUI

class TVShowDetailViewModel: ObservableObject {
    
    /// The name of the TV show.
    @Published var name: String = ""
    
    /// The overview of the TV show.
    @Published var overview: String = ""
    
    /// The URL pointing to the image of the TV show backdrop.
    @Published var backdropURL: String = ""
    
    /// Similar TV shows.
    @Published var similarTVShows: [TVShowResult] = []
    
    /// The current result being shown.
    public var currentResult: TVShowResult?
    
    
    init(result: TVShowResult?) {
        currentResult = result
        setResult()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setResult),
                                               name: TVShowsDataManager.didChangeSelectedResultNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateSimilarTVShows),
                                               name: TVShowsDataManager.didChangeSimilarResultsNotification,
                                               object: nil)
    }
    
    
    /// This function changes the current result.
    @objc func setResult() {
        var res = currentResult
        if res == nil {
            res = TVShowsDataManager.shared.selectedResult
            currentResult = res
        }
        guard let result = res else { return }
        name = result.name ?? ""
        overview = result.overview ?? ""
        backdropURL = ImageBaseURLs.backdrop + (result.backdrop_path ?? "")
        
        TVShowsDataManager.shared.getSimilarTVShows(for: result.id ?? 0)
    }
    
    
    /// This function updates the similar TV shows.
    @objc func updateSimilarTVShows() {
        DispatchQueue.main.async { [self] in
            similarTVShows = TVShowsDataManager.shared.similarTVShows
        }
    }
    
}
