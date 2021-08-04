//
//  Location.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

struct LocationModel: Codable {
    var id: Int
    var name: String
    var review: Float
    var type: String
}

struct LocationListModel: Codable {
    var listLocations: [LocationModel]
}
