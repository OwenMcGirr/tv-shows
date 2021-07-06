//
//  HomeViewModel.swift
//  TV Shows
//
//  Created by Owen McGirr on 06/07/2021.
//

import SwiftUI

class HomeViewModel: ObservableObject, TVShowsDataManagerDelegate {
    
    /// Represents the current TV show results.
    @Published var currentTVShowResults: [TVShowResult] = []
    
    init() {
        // set delegate
        TVShowsDataManager.shared.delegate = self
        
        // get the results of the first page
        TVShowsDataManager.shared.setOrIncrementPageAndGetResults()
    }

    func didUpdateListOfTVShows(with results: [TVShowResult]) {
        DispatchQueue.main.async {
            self.currentTVShowResults = results
        }
    }

}
