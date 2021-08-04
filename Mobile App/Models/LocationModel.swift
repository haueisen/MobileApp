//
//  Location.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

struct Location: Codable {
    var id: Int
    var name: String
    var review: Float
    var type: String
}

struct LocationList: Codable {
    var listLocations: [Location]
}
