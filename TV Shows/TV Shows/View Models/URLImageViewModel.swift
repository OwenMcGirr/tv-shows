//
//  URLImageViewModel.swift
//  TV Shows
//
//  Created by Owen McGirr on 07/07/2021.
//

import SwiftUI

class URLImageViewModel: ObservableObject {
    
    @Published var image: UIImage?
    
    /// The URL pointing to the image.
    private var imageURL: URL?
    
    init(imageURL: String) {
        self.imageURL = URL(string: imageURL)
        fetchImage()
    }
    
    /// This function fetches the image from the URL.
    private func fetchImage() {
        guard let imageURL = imageURL else { return }
        let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, response, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "error getting image")
                return
            }
            guard let data = data else { return }
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }
        task.resume()
    }
}
