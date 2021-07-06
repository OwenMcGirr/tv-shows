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
    private var currentTVShowsPageIndex: Int?
    
    /// The current TV show results.
    private var currentResults: [TVShowResult] = []
    
    /// The number of available pages.
    private var numberOfAvailablePages: Int?
    
    
    /// This function gets the next page of TV show results and appends them
    /// to the current ones.
    private func appendNextPageOfTVShowResults() {
        guard let index = currentTVShowsPageIndex else { return }
        let url = URL(string: "https://api.themoviedb.org/3/tv/popular?api_key=\(apiKey)&page=\(index)")
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
                if let results = page.results,
                   let pageCount = page.total_pages {
                    self?.currentResults.append(contentsOf: results)
                    self?.numberOfAvailablePages = pageCount
                    print(pageCount)
                }
            } catch {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    
    /// This function is responsible for setting the current page index,
    /// and calls the function to append the next page of TV show results
    /// to the current ones.
    public func setOrIncrementPageAndGetResults() {
        if currentTVShowsPageIndex != nil {
            if currentTVShowsPageIndex == numberOfAvailablePages { return }
            
            // increment page index and append results
            currentTVShowsPageIndex! += 1
            appendNextPageOfTVShowResults()
        } else { // get first page
            currentTVShowsPageIndex = 1
            appendNextPageOfTVShowResults()
        }
    }
}
