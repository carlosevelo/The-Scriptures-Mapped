//
//  ChapterContentView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/5/22.
//

import SwiftUI

struct ChapterContentView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    var presentedViews: Binding<Array<String>>
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
                    if horizontalSizeClass == .compact {
                        presentedViews.wrappedValue.append("map")
                    } else {
                        // Ignore -- it's already visible
                    }
                } label: {
                    Image(systemName: horizontalSizeClass == .compact ? "map" : "gobackward" )
                }
            }
        }
        
    }
}

//
//struct ChapterContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChapterContentView(presentedViews: $presentedViewsPreView, bookId: 1, chapter: 1 )
//    }
//}
