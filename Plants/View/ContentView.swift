import SwiftUI

// ---------- امتداد لتحويل HEX إلى Color ----------
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

struct ContentView: View {
    @State private var showReminderSheet = false
    @StateObject private var store = PlantStore() // أضفت هذا لتمريره إلى Set_Reminder

    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()

                VStack(spacing: 0) {

                    // 🟩 العنوان والخط
                    VStack(alignment: .leading, spacing: 8) {
                        Text("My Plants 🌱")
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)

                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.white.opacity(0.12))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 24)

                    // 🪴 الصورة والنصوص
                    VStack(spacing: 10) {
                        Image("plant_illustration")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .clipped()
                            .padding(.top, 10) // قربنا الصورة من الأعلى

                        Text("Start your plant journey!")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.top, 20)

                        Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                            .font(.system(size: 14))
                            .foregroundColor(Color.white.opacity(0.75))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 36)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.top, 20)
                    }
                    .padding(.top, 40) // هذه المسافة بين العنوان والصورة
                    .padding(.bottom, 60) // حتى يبقى بعيد قليل عن الزر

                    Spacer()

                    // 🟢 الزر في الأسفل
                    Button(action: {
                        showReminderSheet.toggle()
                    }) {
                        Text("Set Plant Reminder")
                            .font(.system(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(
                                Capsule()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "#28E0A8"), Color(hex: "#28E0A8")]),
                                        startPoint: .leading,
                                        endPoint: .trailing))
                            )
                            .overlay(
                                Capsule()
                                    .stroke(Color.green.opacity(0.8), lineWidth: 2)
                            )
                            .padding(.horizontal, 60)
                    }
                    .foregroundColor(.black)
                    .padding(.bottom, 36)
                }
            }
            .navigationBarHidden(true)
            // هنا قمنا بتغيير الوجهة لتفتح Set_Reminder وتمرير المخزن
            .sheet(isPresented: $showReminderSheet) {
                Set_Reminder()
                    .environmentObject(store)
            }
        }
    }
}

struct ReminderSetupView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            VStack {
                Text("Reminder setup screen")
                Spacer()
            }
            .navigationTitle("Set Reminder")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                }
            }
            .padding()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .preferredColorScheme(.dark)
            ContentView()
                .preferredColorScheme(.light)
        }
    }
}
