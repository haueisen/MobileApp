//
//  HomeViewModel.swift
//  Mobile App
//
//  Created by flavio on 04/08/21.
//

import Foundation
import UIKit

class HomeViewModel {

    private(set) var locations: [Location] = [] {
        didSet {
            locationsUpdated?(nil)
        }
    }

    private(set) var pictures: [Int: UIImage] = [:]

    var locationsUpdated: ((_ error: Error?) -> Void)?

    func fetchData() {
        pictures = [:]
        LocationAPI.getLocations(resultHandler: locationRequestResultHandler)
    }

    func downloadPicture(forLocation location: Location, observer: ((UIImage, Int) -> Void)?) {

        if let image = pictures[location.id] {
            observer?(image, location.id)
            return
        }

        ImageDownloader.downloadImage(fromUrl: location.imageURL) { (result) in
            switch result {
            case .success(let image):
                self.pictures[location.id] = image
                observer?(image, location.id)
            case .failure(let error):
                print("\(error)")
            }
        }
    }

// MARK: Result handlers

    func locationRequestResultHandler(result: Result<LocationList, LocationAPI.LocationAPIError>) {

        switch result {
        case .success(let locationList):
            locations = locationList.listLocations
            locations.forEach { (location) in
                pictures[location.id] = nil
            }
        case .failure(let error):
            print("Error \(error)")
            locationsUpdated?(error)
        }
    }
}
