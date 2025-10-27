//
//  Delete  EDIT Plant.swift
//  Plants
//
//  Created by Maram Ibrahim  on 04/05/1447 AH.
//


import SwiftUI

struct EditPlantView: View {
    // نستقبل Binding إلى العنصر داخل الـ store
    @EnvironmentObject var store: PlantStore
    @Environment(\.dismiss) private var dismiss

    // Binding إلى النبتة التي نريد تعديلها
    @Binding var plant: Plant

    // حقول محلية لواجهة التحرير (نستخدمها حتى يمكن التراجع قبل الحفظ)
    @State private var plantName: String = ""
    @State private var room: String = "Bedroom"
    @State private var light: String = "Full Sun"
    @State private var wateringDay: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"

    // Alert state للحذف المؤكد
    @State private var showingDeleteAlert = false

    let rooms = ["Bedroom","Living Room","Kitchen","Balcony","Bathroom"]
    let lightOptions = ["Full Sun","Partial Sun","Low Light"]
    let wateringDaysOptions = ["Every day","Every 2 days","Every 3 days","Once a week","Every 10 days","Every 2 weeks"]
    let waterAmounts = ["20-50 ml","50-100 ml","100-200 ml","200-300 ml"]

    var body: some View {
        NavigationView {
            VStack(spacing: 18) {
                // ===== form fields =====
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
                
                // Room & Light group
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
                        .frame(minWidth: 90)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)
                    
                    Divider().background(Color.gray.opacity(0.4))
                    
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
                        .frame(minWidth: 90)
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 12)
                }
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)
            
                // Watering rows
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "drop").foregroundColor(.white.opacity(0.9))
                        Text("Watering Days").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $wateringDay) {
                            ForEach(wateringDaysOptions, id: \.self) { d in Text(d).tag(d) }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                    Divider().background(Color.gray.opacity(0.4))

                    HStack {
                        Image(systemName: "drop").foregroundColor(.white.opacity(0.9))
                        Text("Water").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $waterAmount) {
                            ForEach(waterAmounts, id: \.self) { a in Text(a).tag(a) }
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

                // ===== Delete button في الأسفل =====
                Button {
                    showingDeleteAlert = true
                } label: {
                    Text("Delete Reminder")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .foregroundColor(.red)
                        .background(Color.white.opacity(0.04))
                        .cornerRadius(12)
                }
                .alert("Delete reminder?", isPresented: $showingDeleteAlert) {
                    Button("Delete", role: .destructive) {
                        performDelete()
                    }
                    Button("Cancel", role: .cancel) { }
                } message: {
                    Text("This will remove the plant from your list.")
                }
            }
            .padding()
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // زر الغلق
                ToolbarItem(placement: .navigationBarLeading) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }

                // عنوان
                ToolbarItem(placement: .principal) {
                    Text("Edit Plant").font(.headline).foregroundColor(.white)
                }

                // زر الحفظ: نكتب القيم المحررة إلى الـ binding
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        saveChanges()
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.16, green: 0.88, blue: 0.66))
                    }
                }
            }
            .onAppear {
                // ملء الحقول من النبتة المرتبطة عندما تظهر الـ view
                plantName = plant.name
                room = plant.room
                light = plant.light
                wateringDay = plant.wateringDay
                waterAmount = plant.waterAmount
            }
        } // NavigationView
    }

    // MARK: - وظائف الحفظ والحذف
    private func saveChanges() {
        // نحدّث الـ binding (وبالتالي يتحدّث store)
        plant.name = plantName
        plant.room = room
        plant.light = light
        plant.wateringDay = wateringDay
        plant.waterAmount = waterAmount

    }

    private func performDelete() {
        // نبحث عن الفهرس ونزيل من مصفوفة الـ store مباشرة
        if let idx = store.plants.firstIndex(where: { $0.id == plant.id }) {
            store.plants.remove(at: idx)
        } else {
            // إن أردت: محاولة استدعاء دالة حذف مخصصة في PlantStore إن وُجدت
            // store.remove(plant)
        }
        dismiss()
    }
}

// ===== مثال Preview =====
struct EditPlantView_Previews: PreviewProvider {
    static var previews: some View {
        // إعداد مخزن تجريبي مع نبتة
        let store = PlantStore()
        let sample = Plant(name: "Pothos", room: "Bedroom", light: "Full Sun", wateringDay: "Every day", waterAmount: "20-50 ml")
        store.add(sample)
        // نمرّر binding إلى العنصر الأول
        return EditPlantView(plant: .constant(sample))
            .environmentObject(store)
    }
}
