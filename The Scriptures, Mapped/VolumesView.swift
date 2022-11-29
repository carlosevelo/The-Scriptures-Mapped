//
//  VolumesView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct VolumesView: View {
    var body: some View {
        List {
            ForEach(GeoDatabase.shared.volumes(), id: \.self) { volumeName in
                NavigationLink(volumeName) {
                    BooksView(volumeId: 1)
                }
                .isDetailLink(false)
            }
        }
    }
}

struct VolumesView_Previews: PreviewProvider {
    static var previews: some View {
        VolumesView()
    }
}
