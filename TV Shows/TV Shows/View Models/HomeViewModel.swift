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
    
    /// Indicates whether or not results are loading.
    @Published var isLoadingResults: Bool = false
    
    /// Indicates whether or not more results are available.
    @Published var canFetchMoreResults: Bool = false
    
    init() {
        // set delegate
        TVShowsDataManager.shared.delegate = self
        
        // get the results of the first page
        TVShowsDataManager.shared.setOrIncrementPageAndGetResults()
    }

    func didUpdateListOfTVShows(with results: [TVShowResult]) {
        DispatchQueue.main.sync { [self] in
            currentTVShowResults = results
            isLoadingResults = false
            canFetchMoreResults = !TVShowsDataManager.shared.isOnLastPage()
        }
    }
    
    /// This function fetches more TV show results if the last available result is passed in.
    func fetchMoreResultsIfNeeded(result: TVShowResult) {
        if currentTVShowResults.last?.id == result.id && !isLoadingResults {
            isLoadingResults = true
            TVShowsDataManager.shared.setOrIncrementPageAndGetResults()
        }
    }

}
