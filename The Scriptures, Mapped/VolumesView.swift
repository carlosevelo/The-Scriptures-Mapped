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
            NavigationLink(value: "volume 1") {
                Text("Old Testament")
            }
//            ForEach(GeoDatabase.shared.volumes(), id: \.self) { volumeName in
//
//                .isDetailLink(false)
//            }
        }
    }
}

struct VolumesView_Previews: PreviewProvider {
    static var previews: some View {
        VolumesView()
    }
}
