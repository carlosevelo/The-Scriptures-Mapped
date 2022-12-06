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
        ZStack {
            Rectangle().foregroundColor(.purple).opacity(0.5)
        }
        .navigationTitle("Genesis")
    }
}

struct ChaptersView_Previews: PreviewProvider {
    static var previews: some View {
        BookChaptersView(bookId: 1)
    }
}
