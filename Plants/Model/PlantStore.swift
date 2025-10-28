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
    
    func add(_ plant: Plant) {
        plants.append(plant)
    }
    
    func remove(_ plant: Plant) {
        plants.removeAll { $0.id == plant.id }
    }
}
