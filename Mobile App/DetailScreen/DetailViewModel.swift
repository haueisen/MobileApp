//
//  DetailViewModel.swift
//  Mobile App
//
//  Created by flavio on 05/08/21.
//

import Foundation
import UIKit

class DetailViewModel {

    private(set) var locationDetails: LocationDetails? {
        didSet {
            locationDetailsUpdated?(nil)
        }
    }

    private(set) var locationPicture: UIImage?
    private(set) var locationPhotos: [UIImage]?

    var locationDetailsUpdated: ((_ error: Error?) -> Void)?

    func fetchData(forLocationId locationId: Int) {
        LocationAPI.getLocationDetails(id: locationId, resultHandler: locationDetailsResultHandler)
    }

    func downloadCoverPicture(observer: ((UIImage) -> Void)?) {
        guard let details = locationDetails else {
            return
        }

        if let image = locationPicture {
            observer?(image)
            return
        }

        let imageURL: URL = URL(string: "https://picsum.photos/id/\(details.id+220)/300/360")!

        print(imageURL)
        ImageDownloader.downloadImage(fromUrl: imageURL) { (result) in
            switch result {
            case .success(let image):
                self.locationPicture = image
                observer?(image)
            case .failure(let error):
                print("\(error)")
            }
        }
    }

    func downloadLocationPhotos(observer: ((UIImage) -> Void)?) {
        // TODO: 
    }

    func getSchedule() -> String? {
        guard let details = locationDetails else {
            return nil
        }

        let schedule = details.schedule
        let week = [
            schedule.monday,
            schedule.tuesday,
            schedule.wednesday,
            schedule.thursday,
            schedule.friday,
            schedule.saturday,
            schedule.sunday
        ]

        var groups: [String: [Weekday]] = [:]
        for index in 0..<week.count {
            guard let day = Weekday(rawValue: index) else {
                continue
            }

            if let weekday = week[index] {
                let openHour = Int(weekday.open.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!
                let closeHour = Int(weekday.close.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())!

                let key = "\(openHour)h-\(closeHour)h"
                if groups[key] != nil {
                    groups[key]!.append(day)
                } else {
                    groups[key] = [day]
                }
            }
        }

        var scheduleText = ""
        for (interval, days) in groups {
            if days.count > 1 {
                scheduleText.append("\(days.first!.abbreviation) \(NSLocalizedString("day_to_day", comment: "")) \(days.last!.abbreviation): \(interval.replacingOccurrences(of: "-", with: " \(NSLocalizedString("hour_to_hour", comment: "")) "))\n")
            } else {
                scheduleText.append("\(days[0].abbreviation): \(interval.replacingOccurrences(of: "-", with: " \(NSLocalizedString("hour_to_hour", comment: "")) "))\n")
            }
        }
        return scheduleText
    }

    private func locationDetailsResultHandler(result: Result<LocationDetails, LocationAPI.LocationAPIError>) {
        switch result {
        case .success(let locationDetails):
            self.locationDetails = locationDetails
        case .failure(let error):
            locationDetailsUpdated?(error)
        }
    }
}
