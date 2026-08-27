//
//  UnnaturalApp.swift
//  Unnatural
//
//  Created by jeffrey on 26/8/2026.
//

import SwiftUI

@main
struct UnnaturalApp: App {
    var body: some Scene {
        MenuBarExtra("ScrollInvert", systemImage: "chevron.up.chevron.down") {
            ContentView()
        }
        .menuBarExtraStyle(.window)
    }
}
