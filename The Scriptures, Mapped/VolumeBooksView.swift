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
                NavigationLink(value: "book \(book.id)") {
                    Text(book.fullName)
                }
                .isDetailLink(false)
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
