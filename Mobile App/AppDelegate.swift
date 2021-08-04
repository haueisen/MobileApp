//
//  AppDelegate.swift
//  Mobile App
//
//  Created by flavio on 02/08/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        LocationAPI.getLocations(resultHandler: locationRequestResultHandler)

        return true
    }

    func locationRequestResultHandler(result: Result<LocationList, LocationAPI.LocationAPIError>) {

        switch result {
        case .success(let locationListModel):
            locationListModel.listLocations.forEach { (locationModel) in
                LocationAPI.getLocationDetails(id: locationModel.id, resultHandler: locationDetailsResultHandler)
            }

           
        case .failure(let error):
            print("Error \(error)")
        }
    }

    func locationDetailsResultHandler(result: Result<LocationDetails,LocationAPI.LocationAPIError>) {
        switch result {
        case .success(let locationDetails):
            print("Locations details \(locationDetails.name)")
        case .failure(let error):
            print("Error \(error)")
        }
    }
}
