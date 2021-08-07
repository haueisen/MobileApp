//
//  Location.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

struct Location: Codable {
    private(set) var id: Int
    private(set) var name: String
    private(set) var review: Float
    private(set) var type: String
    var imageURL: URL { return URL(string: "https://picsum.photos/id/\(id+220)/200/300")! }
}

struct LocationList: Codable {
    var listLocations: [Location]
}
