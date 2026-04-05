// A2_iOS_Libareo_101499536App.swift
// A2_iOS_Libareo_101499536
// Libareo Barbour — 101499536
// COMP3097 — George Brown College

import SwiftUI

@main
struct A2_iOS_Libareo_101499536App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
