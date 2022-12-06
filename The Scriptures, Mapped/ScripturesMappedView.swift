//
//  ScripturesMappedView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct ScripturesMappedView: View {
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var presentedViews: [String] = []
    
    var body: some View {
        if horizontalSizeClass == .compact {
            volumesView
        } else {
            HStack(spacing: 0) {
                volumesView
                    .frame(width: 400)
                MapView(text: "Test")
            }
        }
    }
    
    private var volumesView: some View {
        NavigationStack(path: $presentedViews) {
            VolumesView()
                .navigationDestination(for: String.self, destination: navigationDestination(for:))
                .navigationTitle("The Scriptures Mapped")
        }
    }
    
    private func navigationDestination(for path: String) -> AnyView {
        // volume ID
        // book ID
        // chapther bookID chapterNo
        // map
        
        let parts = path.split(separator: " ")
        
        if parts.count > 0 {
            let numbers = parts[1...].map { Int($0) ?? 0 }
            
            switch parts[0] {
            case "volume":
                return AnyView(VolumeBooksView(volumeId: numbers[0]))
            case "book":
                return AnyView(BookChaptersView(bookId: numbers[0]))
            case "chapter":
                return AnyView(ChapterContentView(bookId: numbers[0], chapter: numbers[1]))
            case "map":
                return AnyView(MapView(text: "Test"))
            default:
                break
            }
        }
        
        return AnyView(Text("Unknown path"))
    }
}

struct ScripturesMappedView_Previews: PreviewProvider {
    static var previews: some View {
        ScripturesMappedView()
    }
}
