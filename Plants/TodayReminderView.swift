//
//  TodayReminderView.swift
//  Plants
//
//  Created by Maram Ibrahim  on 01/05/1447 AH.
//


import SwiftUI

struct TodayReminderView: View {
    let plantName: String
    let room: String
    let light: String
    let wateringDay: String
    let waterAmount: String

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Plants 🌱")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.gray.opacity(0.6))
                }
                .padding(.horizontal, 34)
                .padding(.top, 40)
            
                Text("Your plants are waiting for a sip 💧")
                    .foregroundColor(.white)
                
            //من هنا نبدا نشوف كيف البيانات حقت النباتات 
                
                // عرض بيانات النبتة
                VStack(alignment: .leading, spacing: 12) {
                    Text("🌿 \(plantName.isEmpty ? "Unnamed Plant" : plantName)")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    HStack {
                        Label(room, systemImage: "location")
                        Label(light, systemImage: "sun.max")
                        Label(waterAmount, systemImage: "drop")
                    }
                    .foregroundColor(.gray)
                    .font(.subheadline)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white.opacity(0.05))
                .cornerRadius(12)
                .padding(.horizontal)
                
                Spacer()
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct TodayReminderView_Previews: PreviewProvider {
    static var previews: some View {
        TodayReminderView(
            plantName: "Monstera",
            room: "Bedroom",
            light: "Full Sun",
            wateringDay: "Every day",
            waterAmount: "20-50 ml"
        )
    }
}
