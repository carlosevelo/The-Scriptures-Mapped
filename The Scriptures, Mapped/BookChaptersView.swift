//
//  BookChaptersView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct BookChaptersView: View {
    var bookId: Int
    
    var body: some View {
        List {
            NavigationLink(value: "chapter 1"){
                Text("Chapter 1")
                //ChapterContentView(bookId: bookId, chapter: bookId)
            }
//            NavigationLink("Show Chapter") {
//                WebView(request: WebViewLoadRequest.htmlText(html: "<b>Hello</b> World"))
//            }
        }
        .navigationTitle("Genesis")
    }
}

struct ChaptersView_Previews: PreviewProvider {
    static var previews: some View {
        BookChaptersView(bookId: 1)
    }
}
