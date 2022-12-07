//
//  ChapterContentView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/5/22.
//

import SwiftUI

struct ChapterContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
        
    var bookId: Int
    var chapter: Int
    
    var body: some View {
        ZStack {
            let request = ScriptureRenderer.shared.htmlForBookId(bookId, chapter: chapter)
            WebView(request: WebViewLoadRequest.htmlText(html: request)) { geoPlaceId in
                viewModel.focusOnGeoPlace(geoPlaceId: geoPlaceId)
                
                if horizontalSizeClass == .compact {
                    viewModel.presentedViews.append("map")
                }
            }
            .onAppear {
                viewModel.resetMapView()
            }
            .onDisappear {
                viewModel.clearMapView()
            }
        }
        .navigationTitle(GeoDatabase.shared.bookForId(bookId).fullName)
        .toolbar {
            ToolbarItem {
                Button {
                    viewModel.setGeoPlacesForChapter(bookId: bookId, chapter: chapter)
                    
                    if horizontalSizeClass == .compact {
                        viewModel.presentedViews.append("map")
                    } else {
                        //Nothing
                    }
                } label: {
                    Image(systemName: horizontalSizeClass == .compact ? "map" : "gobackward" )
                }
            }
        }
        
    }
}


struct ChapterContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterContentView(bookId: 101, chapter: 1 )
    }
}
