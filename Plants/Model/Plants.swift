//
//  Model.swift
//  Plants
//
//  Created by Maram Ibrahim  on 05/05/1447 AH.
//
import Foundation

struct Plant: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDay: String
    var waterAmount: String
    var isWatered: Bool = false
}
