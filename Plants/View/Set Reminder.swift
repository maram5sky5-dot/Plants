//
//  Set Reminder.swift
//  Plants
//
//  Created by Maram Ibrahim  on 28/04/1447 AH.
//
import SwiftUI

struct Set_Reminder: View {
    @EnvironmentObject var store: PlantStore
    @Environment(\.dismiss) private var dismiss

    @State private var plantName: String = ""
    @State private var room: String = "Bedroom"
    @State private var light: String = "Full Sun"
    @State private var wateringDay: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"

    // حالة تنقّل حديثة
    @State private var navigateToToday: Bool = false

    let rooms = ["Bedroom","Living Room","Kitchen","Balcony","Bathroom"]
    let lightOptions = ["Full Sun","Partial Sun","Low Light"]
    let wateringDaysOptions = ["Every day","Every 2 days","Every 3 days","Once a week","Every 10 days","Every 2 weeks"]
    let waterAmounts = ["20-50 ml","50-100 ml","100-200 ml","200-300 ml"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 18) {
                HStack {
                    Text("Plant Name")
                        .foregroundColor(.white)
                    Spacer()
                    TextField("Pothos", text: $plantName)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)

                // --- Room & Light Pickers ---
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.white.opacity(0.9))
                            .frame(width: 20)
                        Text("Room").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $room) {
                            ForEach(rooms, id: \.self) { r in Text(r).tag(r) }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.gray)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)

                    Divider().background(Color.gray.opacity(0.6))

                    HStack {
                        Image(systemName: "sun.max").foregroundColor(.white.opacity(0.9)).frame(width: 20)
                        Text("Light").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $light) {
                            ForEach(lightOptions, id: \.self) { opt in Text(opt).tag(opt) }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.gray)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)
                }
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.02), lineWidth: 0.5))

                // --- Watering ---
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "drop").foregroundColor(.white.opacity(0.9))
                        Text("Watering Days").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $wateringDay) {
                            ForEach(wateringDaysOptions, id: \.self) { day in Text(day).tag(day) }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)

                    Divider().background(Color.gray.opacity(0.6))

                    HStack {
                        Image(systemName: "drop").foregroundColor(.white.opacity(0.9))
                        Text("Water").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $waterAmount) {
                            ForEach(waterAmounts, id: \.self) { amt in Text(amt).tag(amt) }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                }

                Spacer()
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("Set Reminder").font(.headline).foregroundColor(.white)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // حفظ النبتة في المخزن
                        let name = plantName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? "Unnamed" : plantName
                        let plant = Plant(name: name, room: room, light: light, wateringDay: wateringDay, waterAmount: waterAmount)
                        store.add(plant)

                        // ===== إضافة: جدولة إشعار لمرة واحدة بعد 10 ثواني =====
                        NotificationManager.shared.scheduleReminderAfter(
                            id: plant.id,
                            title: "Time to water \(plant.name)",
                            subtitle: "It's time to water your plant 🌱",
                            after: 10 // يظهر بعد 10 ثواني
                        )

                        // تفعيل التنقّل لعرض TodayReminderView
                        navigateToToday = true
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.16, green: 0.88, blue: 0.66))
                            .shadow(radius: 1)
                    }
                }
            }
            // هذا هو البديل الحديث لربط boolean بالتنقّل داخل NavigationStack
            .navigationDestination(isPresented: $navigateToToday) {
                // نفترض أن لديك TodayReminderView الذي يعتمد على store
                TodayReminderView().environmentObject(store)
            }
        } // end NavigationStack
    }
}

struct Set_Reminder_Previews: PreviewProvider {
    static var previews: some View {
        Set_Reminder().environmentObject(PlantStore())
    }
}
