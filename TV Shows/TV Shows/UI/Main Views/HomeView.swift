//
//  HomeView.swift
//  TV Shows
//
//  Created by Owen McGirr on 05/07/2021.
//

import SwiftUI

struct HomeView: View {
    /// MVVM model for HomeView.
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            NavigationView {
                TVShowList()
                    .navigationBarHidden(true)
            }
        } else {
            GeometryReader { proxy in
                HStack {
                    TVShowList()
                        .frame(width: proxy.size.width / 3, height: proxy.size.height)
                    TVShowDetailView()
                        .environmentObject(TVShowDetailViewModel(result: nil))
                        .frame(width: proxy.size.width - (proxy.size.width / 3), height: proxy.size.height)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}




/// This view shows the list of TV shows.
fileprivate struct TVShowList: View {
    @EnvironmentObject var homeViewModel: HomeViewModel
    var body: some View {
        VStack(spacing: 0) {
            Text("TV Shows")
                .font(.largeTitle)
                .padding()
            List(homeViewModel.currentTVShowResults, id: \.id) { result in
                if UIDevice.current.userInterfaceIdiom == .phone {
                    NavigationLink(destination: TVShowDetailView()
                                    .environmentObject(TVShowDetailViewModel(result: result))) {
                        TVShowResultCell(result: result)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding([.horizontal, .top])
                            .onAppear {
                                if homeViewModel.canFetchMoreResults {
                                    homeViewModel.fetchMoreResultsIfNeeded(result: result)
                                }
                            }
                    }
                } else {
                    TVShowResultCell(result: result)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding([.horizontal, .top])
                        .onAppear {
                            if homeViewModel.canFetchMoreResults {
                                homeViewModel.fetchMoreResultsIfNeeded(result: result)
                            }
                        }
                        .onTapGesture {
                            TVShowsDataManager.shared.setSelectedResult(result: result)
                        }
                }
            }
            if homeViewModel.isLoadingResults {
                Text("Loading...")
                    .padding()
            }
        }
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
                    Text(String(result.vote_average ?? 0))
                        .font(Font.system(size: 12))
                        .foregroundColor(Color.gray)
                }
                .padding()
            }
        }
    }
}
