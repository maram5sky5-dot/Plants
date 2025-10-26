//
//  PlantsApp.swift
//  Plants
//
//  Created by Maram Ibrahim  on 27/04/1447 AH.
//

import SwiftUI

@main
struct Plants_App: App {
    @StateObject private var store = PlantStore()
    
    var body: some Scene {
        WindowGroup {
            TodayReminderView()
                .environmentObject(store)
        }
    }
}
