import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("My Plants 🌱")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Divider()
                        .background(Color.gray.opacity(0.6))
                }
                .padding(.horizontal, 24)
                .padding(.top, 40)
                
                Spacer()
                
    
                Image("plant 1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .padding(.bottom, 16)
                
            
                VStack(spacing: 8) {
                    Text("Start your plant journey!")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text("Now all your plants will be in one place and we will help you take care of them :)")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                }
                
                Spacer()
                
    
                Button(action: {
                    // هنا احتاج اسويها زي عزم حقنا الزر حق التتبع 
                }) {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(16)
                        .shadow(radius: 8)
                }
                .padding(.horizontal, 60)
                .padding(.bottom, 40)
            }
        }
    }
}

#Preview {
    ContentView()
}
