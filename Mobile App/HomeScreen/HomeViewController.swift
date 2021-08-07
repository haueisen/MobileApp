//
//  HomeViewController.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation
import UIKit

class HomeViewController: UICollectionViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

    let picturePlaceholderColors = [UIColor(named: "creme"), UIColor(named: "light_pink"), UIColor(named: "duck_egg_blue")]
    private let homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "LocationCellView", bundle: Bundle.main), forCellWithReuseIdentifier: "locationcell")

        homeViewModel.locationsUpdated = locationsUpdate
        self.loadContent()

        navigationItem.title = NSLocalizedString("home_title", comment: "")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor(named: "topaz")!), for: .default)
    }

    func loadContent() {
        self.loadingIndicator.isHidden = false
        homeViewModel.fetchData()
    }

    func locationsUpdate(_ error: Error?) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = true
            if error != nil {
                self.showError()
                return
            }
            self.collectionView.reloadData()
        }
    }

    func showError() {
        let errorTitle = NSLocalizedString("error_title", comment: "")
        let errorMessage = NSLocalizedString("error_message", comment: "")
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("retry", comment: ""), style: .default, handler: { _ in
            self.loadContent()
        }))
        self.present(alert, animated: true, completion: nil)
    }

// MARK: - DataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return homeViewModel.locations.count
        }
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationCell.reuseId, for: indexPath) as? LocationCell else {
            fatalError()
        }

        let location = homeViewModel.locations[indexPath.item]
        let picture = homeViewModel.pictures[location.id]
        cell.picture.image = picture
        if picture == nil {
            cell.picture.backgroundColor = picturePlaceholderColors[indexPath.item % picturePlaceholderColors.count]
            homeViewModel.downloadPicture(forLocation: location) { (image, locationId) in
                DispatchQueue.main.async {
                    if cell.locationId == locationId {
                        cell.picture.image = image
                    }
                }
            }
        }

        cell.locationId = location.id
        cell.name.text = location.name
        cell.locationType.text = location.type
        cell.starScore.setStartScore(location.review)
        cell.score.text = "\(location.review)"

        print("\(location)")
        return cell
    }

// MARK: - Delegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let detailStoryboard = UIStoryboard(name: "Detail", bundle: Bundle.main)
        guard let detailViewController = detailStoryboard.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController else {
            fatalError()
        }
        detailViewController.locationId = homeViewModel.locations[ indexPath.item].id
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}
