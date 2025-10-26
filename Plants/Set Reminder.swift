//
//  Set Reminder.swift
//  Plants
//
//  Created by Maram Ibrahim  on 28/04/1447 AH.
//
import SwiftUI

struct Set_Reminder: View {
    
    @State private var plantName: String = ""
    @State private var room: String = "Bedroom"
    @State private var light: String = "Full Sun"
    @State private var wateringDay: String = "Every day"
    @State private var waterAmount: String = "20-50 ml"
    
    
    let rooms = ["Bedroom","Living Room","Kitchen","Balcony","Bathroom"]
    let lightOptions = ["Full Sun","Partial Sun","Low Light"]
    let wateringDaysOptions = ["Every day","Every 2 days","Every 3 days", "Once a week", "Every 10 days", "Every 2 weeks"]
    let waterAmounts = ["20-50 ml","50-100 ml","100-200 ml","200-300 ml"]
    
    // لون العلامة (28E0A8)
    @Environment(\.dismiss) private var dismiss
    
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
            
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
            
            
            VStack(spacing: 0) {
               
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 20)
                    
                    Text("Room")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Picker("", selection: $room) {
                        ForEach(rooms, id: \.self) { r in
                            Text(r).tag(r)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(minWidth: 90)
                    .foregroundColor(.gray)
                    
                }
                .padding(.vertical, 14)
                .padding(.leading, 16)
                .padding(.trailing, 12)
                .tint(.gray)
               
                Divider()
                    .background(Color.gray.opacity(0.6))
                
               
                // Right: Light
                HStack {
                    Image(systemName: "sun.max")
                        .foregroundColor(.white.opacity(0.9))
                        .frame(width: 20)
                    
                    Text("Light")
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Picker("", selection: $light) {
                        ForEach(lightOptions, id: \.self) { opt in
                            Text(opt).tag(opt)
                            
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .frame(minWidth: 90)
                }
                .padding(.vertical, 14)
                .padding(.trailing, 16)
                .padding(.leading, 12)
            }
            .background(Color.white.opacity(0.06))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.white.opacity(0.02), lineWidth: 0.5)
            )
            VStack(spacing: 0) {
                // ===== Watering Days row =====
                HStack {
                    Image(systemName: "drop")
                    Text("Watering Days")
                        .foregroundColor(.white)
                    Spacer()
                    Picker("", selection: $wateringDay) {
                        ForEach(wateringDaysOptions, id: \.self) { day in
                            Text(day).tag(day)
                                .foregroundColor(.gray)
                                
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .tint(.gray)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)
                Divider()
                    .background(Color.gray.opacity(0.6))
                
                // ===== Water amount row =====
                HStack {
                    Image(systemName: "drop")
                    Text("Water")
                        .foregroundColor(.white)
                    Spacer()
                    Picker("", selection: $waterAmount) {
                        ForEach(waterAmounts, id: \.self) { amt in
                            Text(amt).tag(amt)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                }
                .padding()
                .background(Color.white.opacity(0.06))
                .cornerRadius(12)
                
            }
                Spacer()
            }
            .padding()
            .background(Color.black.ignoresSafeArea()) // خلفية داكنة
            .preferredColorScheme(.dark)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                // زر الإلغاء على اليسار
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                
                // العنوان في الوسط
                ToolbarItem(placement: .principal) {
                    Text("Set Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                
                // زر الحفظ/الموافقة على اليمين
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // هنا تضيف التصرف عند الضغط (مثلاً حفظ البيانات أو الانتقال)
                        // حالياً نغلق الـ sheet أو الشاشة
                        dismiss()
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.16, green: 0.88, blue: 0.66)) // لون العلامة 28E0A8
                            .shadow(radius: 1)
                    }
                }
            }
        } // NavigationView
    }
}

struct Set_Reminder_Previews: PreviewProvider {
    static var previews: some View {
        Set_Reminder()
    }
}
