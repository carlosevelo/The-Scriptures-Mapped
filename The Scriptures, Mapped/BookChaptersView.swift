//
//  BookChaptersView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct BookChaptersView: View {
    @EnvironmentObject var viewModel: ViewModel

    var bookId: Int
    
    var body: some View {
        List {
            let numChapters = GeoDatabase.shared.bookForId(bookId).numChapters ?? 0
            if numChapters == 0 {
//                NavigationLink("\(chapterNum)", value: "chapter \(bookId) \(chapterNum)")
//                .isDetailLink(false)
            }
            else if numChapters == 1 {
//                NavigationLink("\(chapterNum)", value: "chapter \(bookId) \(chapterNum)")
//                .isDetailLink(false)
            }
            else {
                ForEach(1...numChapters, id: \.self) { chapterNum in
                    NavigationLink("\(chapterNum)", value: "chapter \(bookId) \(chapterNum)")
                    .isDetailLink(false)
                }
            }
        }
        .navigationTitle(GeoDatabase.shared.bookForId(bookId).fullName)
    }
        
}

struct ChaptersView_Previews: PreviewProvider {
    static var previews: some View {
        BookChaptersView(bookId: 101)
    }
}
