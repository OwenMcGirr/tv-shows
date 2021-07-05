//
//  HomeView.swift
//  TV Shows
//
//  Created by Owen McGirr on 05/07/2021.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onAppear() {
                TVShowsDataManager.shared.populateCurrentPageOfTVShows()
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
