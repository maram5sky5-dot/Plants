//
//  PlantsApp.swift
//  Plants
//
//  Created by Maram Ibrahim  on 05/05/1447 AH.
//

import SwiftUI

@main
struct PlantsApp: App {
    @StateObject private var store = PlantStore()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .environmentObject(store)
            }
            .onAppear {
                // طلب صلاحية الإشعارات مرة واحدة عند فتح التطبيق
                NotificationManager.shared.requestAuthorization { granted in
                    if granted {
                        print("Notifications authorized ✅")
                    } else {
                        print("Notifications denied ❌")
                    }
                }
            }
        }
    }
}
