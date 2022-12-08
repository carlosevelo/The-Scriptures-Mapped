//
//  VolumeBooksView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct VolumeBooksView: View {
    var volumeId: Int
    
    var body: some View {
        List {
            ForEach(GeoDatabase.shared.booksForParentId(volumeId), id: \.self) { book in
                if book.numChapters == nil {
                    NavigationLink(book.fullName, value: "chapter \(book.id) \(0)")
                    .isDetailLink(false)
                } else {
                    if book.numChapters == 1 {
                        NavigationLink(book.fullName, value: "chapter \(book.id) \(1)")
                        .isDetailLink(false)
                    } else {
                        NavigationLink(book.fullName, value: "book \(book.id)")
                            .isDetailLink(false)
                    }
                }
//                NavigationLink(book.fullName, value: "book \(book.id)")
//                .isDetailLink(false)
            }
        }
        .navigationTitle(GeoDatabase.shared.bookForId(volumeId).fullName)
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeBooksView(volumeId: 1)
    }
}
