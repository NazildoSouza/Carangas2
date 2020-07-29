//
//  Car.swift
//  Carangas2
//
//  Created by Nazildo Souza on 22/04/20.
//  Copyright © 2020 Nazildo Souza. All rights reserved.
//

import Foundation

struct Car: Codable {
    var _id: String?
    var brand: String
    var gasType: Int
    var name: String
    var price: Double
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Álcool"
        default:
            return "Gasolina"
        }
    }
}

struct Brand: Codable {
    var id: Int
    var fipe_name: String
}
