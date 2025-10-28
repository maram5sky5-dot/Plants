//
//  PlantStore.swift
//  Plants
//
//  Created by Maram Ibrahim  on 02/05/1447 AH.
//
import Foundation
import Combine

final class PlantStore: ObservableObject {
    @Published var plants: [Plant] = []
    
    // إضافة نبات
    func add(_ plant: Plant) {
        plants.append(plant)
    }
    
    // حذف نبات عن طريق الكائن نفسه
    func remove(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    }
    
    // حذف نبات عن طريق المعرف (UUID)
    func remove(by id: UUID) {
        plants.removeAll { $0.id == id }
    }
}
