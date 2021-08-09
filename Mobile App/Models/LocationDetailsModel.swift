//
//  LocationDetailsObject.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

struct LocationDetails: Codable {
    // swiftlint:disable identifier_name
    var id: Int
    var name: String
    var review: Float
    var type: String
    var about: String
    var phone: String
    var schedule: Schedules

    private var address: String?
    private var adress: String?

    /* Thinking in a real life situation
        This is only here because on model specification the field is called
        "address", but api is returning "adress". So when it is fixed on api side
        the app will keep working without required a update
     */
    func getAddress() -> String {
        return address ?? adress ?? ""
    }
}
