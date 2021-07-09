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
    
    /// The current result being shown.
    private var currentResult: TVShowResult?
    
    
    init(result: TVShowResult?) {
        currentResult = result
        setResult()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(setResult),
                                               name: TVShowsDataManager.didChangeSelectedResultNotification,
                                               object: nil)
    }
    
    
    /// This function changes the current result.
    @objc func setResult() {
        var res = currentResult
        if res == nil {
            res = TVShowsDataManager.shared.selectedResult
        }
        guard let result = res else { return }
        name = result.name ?? ""
        overview = result.overview ?? ""
        backdropURL = ImageBaseURLs.backdrop + (result.backdrop_path ?? "")
    }
    
}
