//
//  LocationAPI.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

class LocationAPI {

    static let baseURL: URL = URL(string: "https://hotmart-mobile-app.herokuapp.com/")!
    static let locationsEndPoint = "locations"
    static let locationDetailsEndPoint = "locations/%d"

    public enum LocationAPIError: Error {
        case invalidURL
        case requestError
        case jsonDeserializationError
    }

    static func getLocations(resultHandler: @escaping (Result<LocationList, LocationAPIError>) -> Void) {
        guard let locationsURL = URL(string: locationsEndPoint, relativeTo: baseURL) else {
            return resultHandler(.failure(.invalidURL))
        }

        get(url: locationsURL, resultHandler: resultHandler)
    }

    static func getLocationDetails(id locationId: Int, resultHandler: @escaping (Result<LocationDetails, LocationAPIError>) -> Void) {
        guard let locationDetailsURL = URL(string: String(format: locationDetailsEndPoint, locationId), relativeTo: baseURL) else {
            return
        }

        get(url: locationDetailsURL, resultHandler: resultHandler)
    }

    private static func get<T: Codable>(url: URL, resultHandler: @escaping (Result<T, LocationAPIError>) -> Void) {
        let request = URLRequest(url: url)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return resultHandler(.failure(.requestError))
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let responseData = data
                  else {
                return resultHandler(.failure(.requestError))
            }

            let jsonDecoder = JSONDecoder()

            do {
                let result = try jsonDecoder.decode(T.self, from: responseData)
                return resultHandler(.success(result))
            } catch {
                print("jsonDeserializationError \(error)")
                return resultHandler(.failure(.jsonDeserializationError))
            }
        }
        task.resume()
    }
}
