//
//  TodayReminderView.swift
//  Plants
//
//  Created by Maram Ibrahim  on 01/05/1447 AH.
//

import SwiftUI

struct TodayReminderView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showingAdd = false
    
    var progress: Double {
        guard !store.plants.isEmpty else { return 0.0 }
        let watered = store.plants.filter { $0.isWatered }.count
        return Double(watered) / Double(store.plants.count)
    }
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 12) {
                Text("My Plants 🌱")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 12)
                
                Text("\(store.plants.filter { $0.isWatered }.count) of your plants feel loved today ✨")
                    .foregroundColor(.gray)
                
                // شريط التقدّم مع أنيميشن
                GeometryReader { geo in
                    ZStack(alignment: .leading) {
                        Capsule().frame(height: 10).foregroundColor(Color.white.opacity(0.12))
                        Capsule()
                            .frame(width: max(0, geo.size.width * CGFloat(progress)), height: 10)
                            .foregroundColor(Color(red: 0.58, green: 0.98, blue: 0.88))
                            .animation(.easeInOut(duration: 0.35), value: progress)
                    }
                }
                .frame(height: 10)
                .padding(.trailing, 8)
                
                Divider().background(Color.white.opacity(0.06))
                
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(store.plants.indices, id: \.self) { idx in
                            PlantRowView(plant: $store.plants[idx])
                        }
                    }
                    .padding(.vertical, 8)
                }
                Spacer()
            }
            .padding()
            
            // زر + دائري في الأسفل يمين
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showingAdd = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(Color(red: 0.16, green: 0.88, blue: 0.66))
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                    .sheet(isPresented: $showingAdd) {
                        Set_Reminder().environmentObject(store)
                    }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

struct PlantRowView: View {
    @Binding var plant: Plant
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                // زر التحديد (الدائرة / الصح)
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        plant.isWatered.toggle()
                    }
                } label: {
                    if plant.isWatered {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color(red: 0.16, green: 0.88, blue: 0.66))
                    } else {
                        Image(systemName: "circle")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
                
                // المحتوى النصي: سطر المكان فوق الاسم ثم البادجات
                VStack(alignment: .leading, spacing: 6) {
                    // السطر العلوي: أيقونة + "in <Room>" بلون رمادي وخط صغير
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text("in \(plant.room)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // اسم النبتة الكبير
                    Text(plant.name)
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.regular)
                    
                    // البادجات (إضاءة وكمية ماء)
                    HStack(spacing: 8) {
                        Label(plant.light, systemImage: "sun.max")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(6)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(8)
                        Label(plant.waterAmount, systemImage: "drop")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(6)
                            .background(Color.white.opacity(0.04))
                            .cornerRadius(8)
                    }
                }
                Spacer()
            }
            Divider().background(Color.white.opacity(0.06))
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 8)
        .background(Color.clear)
    }
}

struct TodayReminderView_Previews: PreviewProvider {
    static var previews: some View {
        // استخدمي مخزن فارغ للـ Preview حتى لا تظهر نباتات افتراضية
        let store = PlantStore()
        return TodayReminderView().environmentObject(store)
    }
}
