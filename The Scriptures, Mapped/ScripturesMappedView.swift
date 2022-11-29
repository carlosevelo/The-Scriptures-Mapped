//
//  ScripturesMappedView.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/29/22.
//

import SwiftUI

struct ScripturesMappedView: View {
    var body: some View {
        NavigationSplitView {
            VolumesView()
        } detail: {
            MapView(text: "From ScripturesMappedView")
        }
    }
}

struct ScripturesMappedView_Previews: PreviewProvider {
    static var previews: some View {
        ScripturesMappedView()
    }
}
