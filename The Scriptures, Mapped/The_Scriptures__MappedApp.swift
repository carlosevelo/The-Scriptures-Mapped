//
//  The_Scriptures__MappedApp.swift
//  The Scriptures, Mapped
//
//  Created by Carlos Evelo on 11/28/22.
//

import SwiftUI

@main
struct The_Scriptures__MappedApp: App {
    var body: some Scene {
        WindowGroup {
            ScripturesMappedView().environmentObject(ViewModel())
        }
    }
}
