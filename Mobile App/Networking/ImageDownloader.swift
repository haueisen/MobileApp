//
//  ImageDownloader.swift
//  Mobile App
//
//  Created by flavio on 07/08/21.
//

import Foundation
import UIKit

class ImageDownloader {

    public enum ImageDownloaderError: Error {
        case downloadError
    }

    static func downloadImage(fromUrl url: URL, resultHandler: @escaping (Result<UIImage, ImageDownloaderError>) -> Void) {
        DispatchQueue.global().async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else {
                        resultHandler(.failure(.downloadError))
                        return
                }
                resultHandler(.success(image))
            }.resume()
        }
    }
}
