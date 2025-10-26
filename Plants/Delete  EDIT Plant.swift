//
//  Delete  EDIT Plant.swift
//  Plants
//
//  Created by Maram Ibrahim  on 04/05/1447 AH.
//


import SwiftUI

struct EditPlantView: View {
    // هنا نستقبل Binding إلى العنصر داخل الـ store
    @Binding var plant: Plant
    @EnvironmentObject var store: PlantStore
    @Environment(\.dismiss) private var dismiss
    
    // حالة التأكيد للحذف
    @State private var showingDeleteAlert = false
    
var body: some View {
        NavigationView {
            VStack(spacing: 18) {
                // Plant Name
                HStack {
                    Text("Plant Name")
                        .foregroundColor(.white)
                    Spacer()
                    TextField("Pothos", text: $plant.name)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.gray)
                        .disableAutocorrection(true)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)
                
                // Room + Light (تعدِيلات مباشرة على binding)
                VStack(spacing: 0) {
                    HStack {
                        Image(systemName: "location").foregroundColor(.white.opacity(0.9)).frame(width: 20)
                        Text("Room").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.room) {
                            ForEach(["Bedroom","Living Room","Kitchen","Balcony","Bathroom"], id: \.self) { r in
                                Text(r).tag(r)
                            }
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
                        Picker("", selection: $plant.light) {
                            ForEach(["Full Sun","Partial Sun","Low Light"], id: \.self) { opt in
                                Text(opt).tag(opt)
                            }
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
                
                // Watering Days + Water Amount
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "drop").foregroundColor(.white.opacity(0.9))
                        Text("Watering Days").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.wateringDay) {
                            ForEach(["Every day","Every 2 days","Every 3 days","Once a week","Every 10 days","Every 2 weeks"], id: \.self) { d in
                                Text(d).tag(d)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(.menu)
                        .tint(.gray)
                    }
                    .padding()
                    .background(Color.white.opacity(0.06))
                    .cornerRadius(12)
                    
                    HStack {
                        Image(systemName: "drop").foregroundColor(.white.opacity(0.9))
                        Text("Water").foregroundColor(.white)
                        Spacer()
                        Picker("", selection: $plant.waterAmount) {
                            ForEach(["20-50 ml","50-100 ml","100-200 ml","200-300 ml"], id: \.self) { a in
                                Text(a).tag(a)
                            }
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
                
                // زر الحذف الأحمر
                Button {
                    showingDeleteAlert = true
                } label: {
                    Text("Delete Reminder")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white.opacity(0.03))
                        .cornerRadius(12)
                }
                .padding(.bottom, 10)
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
                            .font(.system(size: 24))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                // العنوان
                ToolbarItem(placement: .principal) {
                    Text("Set Reminder").font(.headline).foregroundColor(.white)
                }
                
                // زر الحفظ (ليس مطلوباً لأن Binding يحدث مباشرة، لكن نضعه ليغلق)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // لا حاجة لحفظ صريح لأن Binding يغيّر store مباشرة
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.16, green: 0.88, blue: 0.66))
                    }
                }
            }
            // تأكيد الحذف
            .alert("Delete Plant", isPresented: $showingDeleteAlert, actions: {
                Button("Delete", role: .destructive) {
                    store.remove(plant)   // يحذف من المخزن بواسطة id
                    dismiss()
                }
                Button("Cancel", role: .cancel) { }
            }, message: {
                Text("Are you sure you want to delete this plant?")
            })
        } // NavigationView
    }
}
