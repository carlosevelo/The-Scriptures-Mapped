//
//  ChapterContentView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 12/5/22.
//

import SwiftUI

struct ChapterContentView: View {
    var bookId: Int
    var chapter: Int
    
    var body: some View {
        ZStack {
            Rectangle().foregroundColor(.blue).opacity(0.5)
        }
        .navigationTitle("Genesis 1")    }
}

struct ChapterContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChapterContentView(bookId: 1, chapter: 1)
    }
}
