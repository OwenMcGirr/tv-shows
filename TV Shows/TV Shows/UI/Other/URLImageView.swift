//
//  URLImageView.swift
//  TV Shows
//
//  Created by Owen McGirr on 07/07/2021.
//

import SwiftUI

struct URLImageView: View {
    @ObservedObject var urlImageViewModel: URLImageViewModel
    
    init(urlString: String) {
        urlImageViewModel = URLImageViewModel(imageURL: urlString)
    }
    
    var body: some View {
        Image(uiImage: (urlImageViewModel.image ?? UIImage(systemName: "xmark"))!)
            .resizable()
    }
}
