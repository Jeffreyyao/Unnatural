//
//  ContentView.swift
//  ScrollInvert
//
//  Created by jeffrey on 26/8/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isUnnatural: Bool = false
    
    var body: some View {
        VStack(spacing: 12) {
            Label("Unnatural", systemImage: "chevron.up.chevron.down")

            Toggle("", isOn: $isUnnatural)
            .labelsHidden()
            .toggleStyle(.switch)
            .tint(.purple)
            .padding()
            .scaleEffect(2)
            .onAppear {
                isUnnatural = !ScrollSettings.isNaturalScrollingEnabled
            }
            .onChange(of: isUnnatural) {_, newValue in
                ScrollSettings.setNaturalScrolling(!isUnnatural)
            }

            Button("Quit App") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding()
        .frame(width: 200)
    }
}

import Foundation

struct ScrollSettings {
    private static let key = "com.apple.swipescrolldirection"
    
    /// Reads current natural scrolling state (Defaults to true on macOS if unassigned)
    static var isNaturalScrollingEnabled: Bool {
        guard let value = CFPreferencesCopyAppValue(key as CFString, kCFPreferencesAnyApplication) else {
            return true
        }
        return (value as? Bool) ?? false
    }
    
    /// Sets natural scrolling state and applies it immediately
    static func setNaturalScrolling(_ enabled: Bool) {
        CFPreferencesSetAppValue(
            key as CFString,
            enabled as CFPropertyList,
            kCFPreferencesAnyApplication
        )
        CFPreferencesAppSynchronize(kCFPreferencesAnyApplication)

        applyScrollDirectionInstantly(enabled: enabled)
    }
    
    // Apply pointer setting according to https://github.com/davidalecrim1/natural/blob/main/src-tauri/src/scroll.rs
    private static func applyScrollDirectionInstantly(enabled: Bool) {
        let frameworkPath = "/System/Library/PrivateFrameworks/PreferencePanesSupport.framework/PreferencePanesSupport"

        guard let handle = dlopen(frameworkPath, RTLD_LAZY) else {
            print("Failed to load PreferencePanesSupport framework")
            return
        }
        defer { dlclose(handle) }

        if let symbol = dlsym(handle, "setSwipeScrollDirection") {
            typealias SetSwipeScrollDirectionFunc = @convention(c) (CBool) -> Void
            let setDirection = unsafeBitCast(symbol, to: SetSwipeScrollDirectionFunc.self)
            setDirection(enabled)
        } else {
            print("symbol not found")
        }
    }
}

#Preview {
    ContentView()
}
