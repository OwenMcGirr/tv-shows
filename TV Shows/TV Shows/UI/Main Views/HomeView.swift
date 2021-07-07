//
//  HomeView.swift
//  TV Shows
//
//  Created by Owen McGirr on 05/07/2021.
//

import SwiftUI

struct HomeView: View {
    /// MVVM model for HomeView.
    @StateObject var homeViewModel = HomeViewModel()
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment: .center, spacing: 0) {
                    ForEach(homeViewModel.currentTVShowResults, id: \.id) { result in
                        TVShowResultCell(result: result)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.horizontal, .bottom])
                            .onAppear {
                                if homeViewModel.canFetchMoreResults {
                                    homeViewModel.fetchMoreResultsIfNeeded(result: result)
                                }
                            }
                    }
                    if homeViewModel.isLoadingResults {
                        Text("Loading...")
                            .padding()
                    }
                }
            }
            .navigationTitle(Text("TV Shows"))
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}




/// This view shows the TV show poster. name, and vote count.
fileprivate struct TVShowResultCell: View {
    var result: TVShowResult
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 8)
            HStack {
                URLImageView(urlString: ImageBaseURLs.poster + (result.poster_path ?? ""))
                    .frame(width: 75, height: 125)
                    .padding()
                Text(result.name ?? "")
                    .font(Font.system(size: 18))
                    .foregroundColor(Color.black)
                Spacer()
                HStack(spacing: 3) {
                    Image(systemName: "heart")
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.gray)
                    Text(String(result.vote_count ?? 0))
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.gray)
                }
                .padding()
            }
        }
    }
}
