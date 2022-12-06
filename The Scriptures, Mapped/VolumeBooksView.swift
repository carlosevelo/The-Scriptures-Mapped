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
            NavigationLink(value: "book 123") {
                Text("Genesis")
            }
//            NavigationLink(GeoDatabase.shared.bookForId(volumeId).fullName) {
//                BookChaptersView(bookId: volumeId)
//            }
//            NavigationLink("Show Chapter") {
//                WebView(request: WebViewLoadRequest.htmlText(html: "<b>Hello</b> World"))
//            }
        }
        .navigationTitle("Old Testament")
    }
}

struct BooksView_Previews: PreviewProvider {
    static var previews: some View {
        VolumeBooksView(volumeId: 1)
    }
}
