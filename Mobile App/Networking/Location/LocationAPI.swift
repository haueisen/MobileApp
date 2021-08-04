//
//  LocationAPI.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation

class LocationAPI {
    
    static let baseURL: URL = URL(string:"https://hotmart-mobile-app.herokuapp.com/")!
    static let locationsEndPoint = "locations"
    static let locationDetailsEndPoint = "locations/{id}"
    
    enum LocationAPIError: Error {
        case invalidURL
        case requestError
        case jsonDeserializationError
    }
    
    static func getLocations() -> Result<LocationListModel,LocationAPIError> {
        guard let locationsURL = URL(string:locationsEndPoint, relativeTo:baseURL) else {
            return .failure(.invalidURL)
        }
        
        let request = URLRequest(url: locationsURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return .failure(.requestError)
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let responseData = data
                  else {
                return .failure(.requestError)
            }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let locations = try jsonDecoder.decode(LocationListModel.self, from: responseData)
                return .success(locations)
            } catch {
                return .failure(.jsonDeserializationError)
            }
        }
        task.resume()
    }
}
