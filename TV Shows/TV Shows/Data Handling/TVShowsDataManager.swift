//
//  TVShowsDataManager.swift
//  TV Shows
//
//  Created by Owen McGirr on 05/07/2021.
//

import Foundation

/// This class manages the getting and sorting of the TV shows.
class TVShowsDataManager: NSObject {

    /// Singleton object.
    static let shared = TVShowsDataManager()
  
    /// API key for the movie db.
    private let apiKey = "f74a7854d632252e53cf5310a94cadc9"
    
    /// The current page index of TV show results.
    private var currentTVShowsPageIndex = 1
    
    /// The current page results.
    private var currentPageResults: [TVShowResult] = []
    
    
    /// This function gets the current page of TV show results.
    func populateCurrentPageOfTVShows() {
        let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&page=\(currentTVShowsPageIndex)")
        guard let url = url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { [weak self] data, response, error -> Void in
            guard let data = data else { return }
            do {
                let page = try JSONDecoder().decode(Page.self, from: data)
                if let results = page.results {
                    self?.currentPageResults = results
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
}
