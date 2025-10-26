//
//  Done.swift
//  Plants
//
//  Created by Maram Ibrahim  on 04/05/1447 AH.
//
import SwiftUI

struct Done: View {
    @State private var showingAdd = false
    @EnvironmentObject var store: PlantStore

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                
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
                
                // ✅ محتوى Done
                VStack(spacing: 20) {
                    Image("Done")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 164, height: 200)
                        .padding(.top, 150)
                    
                    Text("All Done! 🎉")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text("All Reminders Completed")
                        .font(.system(size: 14))
                        .foregroundColor(Color.white.opacity(0.75))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 36)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
            }
            
            // ✅ زر الإضافة + في الزاوية
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
    }
}

// ✅ Preview
struct Done_Previews: PreviewProvider {
    static var previews: some View {
        Done().environmentObject(PlantStore())
    }
}
