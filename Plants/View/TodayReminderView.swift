//  TodayReminderView.swift
//  Plants
//
//  Created by Maram Ibrahim  on 01/05/1447 AH.
//
import SwiftUI

// MARK: - TodayReminderView
struct TodayReminderView: View {
    @EnvironmentObject var store: PlantStore
    @State private var showingAdd = false
    @State private var navigateToDone: Bool = false

    // نسبة النباتات المسقية
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
                Divider().background(Color.white.opacity(0.06))

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

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(store.plants.indices, id: \.self) { idx in
                            NavigationLink {
                                EditPlantView(plant: $store.plants[idx])
                                    .environmentObject(store)
                            } label: {
                                PlantRowView(plant: $store.plants[idx])
                            }
                            .buttonStyle(.plain)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    let idToDelete = store.plants[idx].id
                                    store.remove(by: idToDelete)
                                    NotificationManager.shared.cancelReminder(id: idToDelete)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                                .tint(.red)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                Spacer()
            }
            .padding()

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

        // راقب تغيّر قيمة progress بدون deprecated
        .onChange(of: progress) { oldValue, newValue in
            if newValue >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    navigateToDone = true
                }
            }
        }
        .onAppear {
            // طلب صلاحية الإشعارات
            NotificationManager.shared.requestAuthorization { granted in
                if granted { print("Notifications authorized ✅") }
                else { print("Notifications denied ❌") }
            }

            if progress >= 1.0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    navigateToDone = true
                }
            }
        }
        .fullScreenCover(isPresented: $navigateToDone) {
            Done().environmentObject(store)
        }
    }
}

// MARK: - PlantRowView
struct PlantRowView: View {
    @Binding var plant: Plant

    var body: some View {
        VStack(spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                Button {
                    withAnimation(.easeInOut(duration: 0.25)) {
                        plant.isWatered.toggle()
                    }
                } label: {
                    Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                        .font(.title2)
                        .foregroundColor(plant.isWatered ? Color(red: 0.16, green: 0.88, blue: 0.66) : .gray)
                }

                VStack(alignment: .leading, spacing: 6) {
                    HStack(spacing: 6) {
                        Image(systemName: "paperplane")
                            .foregroundColor(.gray)
                            .font(.caption)
                        Text("in \(plant.room)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }

                    Text(plant.name)
                        .font(.title3)
                        .foregroundColor(.white)
                        .fontWeight(.regular)

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

// MARK: - Preview
struct TodayReminderView_Previews: PreviewProvider {
    static var previews: some View {
        let store = PlantStore()
        store.add(Plant(name: "Pothos", room: "Bedroom", light: "Full Sun", wateringDay: "Every day", waterAmount: "20-50 ml"))
        store.add(Plant(name: "Ficus", room: "Living Room", light: "Partial Sun", wateringDay: "Every 2 days", waterAmount: "50-100 ml"))
        return NavigationStack {
            TodayReminderView().environmentObject(store)
        }
    }
}
