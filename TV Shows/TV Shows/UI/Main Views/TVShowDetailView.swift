//
//  TVShowDetailView.swift
//  TV Shows
//
//  Created by Owen McGirr on 08/07/2021.
//

import SwiftUI

struct TVShowDetailView: View {
    @EnvironmentObject var tvShowDetailViewModel: TVShowDetailViewModel
    var body: some View {
        if tvShowDetailViewModel.name.isEmpty {
            EmptyDatailView()
        } else {
            MainvView()
                .navigationBarHidden(true)
        }
    }
}

struct TVShowDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TVShowDetailView()
    }
}





fileprivate struct EmptyDatailView: View {
    @State var animationAmount: CGFloat = 1
    var body: some View {
        Text("Choose a TV show")
            .font(.title)
            .scaleEffect(animationAmount)
            .animation(
                Animation.easeInOut(duration: 0.5)
                    .repeatCount(10, autoreverses: true)
            )
            .onAppear {
                animationAmount = 1.6
            }
    }
}





fileprivate struct MainvView: View {
    @EnvironmentObject var tvShowDetailViewModel: TVShowDetailViewModel
    @State var orientation = UIDevice.current.orientation
    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .leading, spacing: 0) {
                if orientation.isLandscape {
                    TVShowBackdropAndNameView()
                        .frame(width: proxy.size.width, height: proxy.size.height / 2)
                } else {
                    TVShowBackdropAndNameView()
                        .frame(width: proxy.size.width, height: proxy.size.height / 3)
                }
                ScrollView {
                    Text(tvShowDetailViewModel.overview)
                        .font(Font.system(size: 24))
                        .padding()
                }
                Spacer()
                SimilarTVShowsListView()
                    .padding()
            }
            
        }
        .onReceive(orientationChanged, perform: { p in
            orientation = UIDevice.current.orientation
        })
    }
}





/// This view shows the backdrop image and name of the TV show.
/// It shows a back button only when running on an iPhone.
fileprivate struct TVShowBackdropAndNameView: View {
    @EnvironmentObject var tvShowDetailViewModel: TVShowDetailViewModel
    @Environment(\.presentationMode) var presentation
    var body: some View {
        ZStack(alignment: .leading) {
            URLImageView(urlString: tvShowDetailViewModel.backdropURL)
            VStack(alignment: .leading) {
                if UIDevice.current.userInterfaceIdiom == .phone {
                    Button(action: {
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .background(Circle()
                                            .foregroundColor(Color.white)
                                            .opacity(0.6)
                                            .frame(width: 48, height: 48))
                            .frame(width: 36, height: 36)
                            .foregroundColor(Color.black)
                    })
                    .padding()
                }
                Spacer()
                Text(tvShowDetailViewModel.name)
                    .font(.title)
                    .padding()
                    .foregroundColor(.black)
                    .background(Color.white
                                    .opacity(0.6))
                    .clipShape(Capsule())
                    .padding()
            }
        }
    }
}







/// This view shows the similar TV shows in a horizontal, scrollable list.
fileprivate struct SimilarTVShowsListView: View {
    @EnvironmentObject var tvShowDetailViewModel: TVShowDetailViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("You might also like...")
                .font(.title.bold())
            ScrollView(.horizontal) {
                HStack {
                    SimilarTVShowThumbnail(result: tvShowDetailViewModel.currentResult!)
                    ForEach(tvShowDetailViewModel.similarTVShows, id: \.id) { result in
                        SimilarTVShowThumbnail(result: result)
                    }
                }
            }
        }
    }
}







/// This view shows the related TV show poster and name.
fileprivate struct SimilarTVShowThumbnail: View {
    var result: TVShowResult
    var body: some View {
        VStack(spacing: 8) {
            URLImageView(urlString: ImageBaseURLs.poster + (result.poster_path ?? ""))
                .frame(width: 75, height: 125)
            Text(result.name ?? "")
                .frame(width: 75)
                .lineLimit(1)
        }
    }
}
