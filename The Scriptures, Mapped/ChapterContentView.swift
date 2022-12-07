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
    
    @State private var displayedGeoplaces: [GeoPlace] = []
    
    var bookId: Int
    var chapter: Int
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.blue).opacity(0.5)
            Text("Book \(bookId), Chapter \(chapter)")
        }
        .navigationTitle("Genesis 1")
        .toolbar {
            ToolbarItem {
                Button {
                    let scripture: [Scripture] = GeoDatabase.shared.versesForScriptureBookId(bookId, chapter)
                    let geoPlaceAndTag: [(GeoPlace, GeoTag)] = GeoDatabase.shared.geoTagsForScriptureId(scripture[0].id)

                    if horizontalSizeClass == .compact {
                        viewModel.displayedGeoplaces = [geoPlaceAndTag[0].0]
                        viewModel.presentedViews.append("map")
                    } else {
                        viewModel.displayedGeoplaces = [geoPlaceAndTag[0].0]
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
        ChapterContentView(bookId: 1, chapter: 1 )
    }
}
