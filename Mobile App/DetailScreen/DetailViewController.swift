//
//  DetailViewController.swift
//  Mobile App
//
//  Created by flavio on 03/08/21.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    private var detailViewModel = DetailViewModel()

    var locationId: Int?
    var picturePlaceholderColor: UIColor?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.isHidden = true
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.registerCells()

        self.tableView.tableFooterView = UIView(frame: CGRect.zero)

        self.tableView.rowHeight = UITableView.automaticDimension

        let shareButton = UIBarButtonItem(image: UIImage(named: "share"), style: .plain, target: self, action: #selector(share))
        self.navigationItem.rightBarButtonItem = shareButton

        if let navigationBar = self.navigationController?.navigationBar {
            self.applyGradientBackgroundTo(navigationBar)
        }

        self.detailViewModel.locationDetailsUpdated = detailsUpdate
        self.loadContent()
    }

    private func registerCells() {
        self.tableView.register(UINib(nibName: "CoverCell", bundle: Bundle.main), forCellReuseIdentifier: "covercell")
        self.tableView.register(UINib(nibName: "TitleCell", bundle: Bundle.main), forCellReuseIdentifier: "titlecell")
        self.tableView.register(UINib(nibName: "PhotosCell", bundle: Bundle.main), forCellReuseIdentifier: "photoscell")
        self.tableView.register(UINib(nibName: "AboutCell", bundle: Bundle.main), forCellReuseIdentifier: "aboutcell")
        self.tableView.register(UINib(nibName: "ScheduleCell", bundle: Bundle.main), forCellReuseIdentifier: "schedulecell")
        self.tableView.register(UINib(nibName: "PhoneCell", bundle: Bundle.main), forCellReuseIdentifier: "phonecell")
        self.tableView.register(UINib(nibName: "AddressCell", bundle: Bundle.main), forCellReuseIdentifier: "addresscell")
        self.tableView.register(UINib(nibName: "ReviewsCell", bundle: Bundle.main), forCellReuseIdentifier: "reviewscell")
        self.tableView.register(UINib(nibName: "MoreCell", bundle: Bundle.main), forCellReuseIdentifier: "morecell")
    }

    private func applyGradientBackgroundTo(_ navigationBar: UINavigationBar) {
        let gradient = CAGradientLayer()

        gradient.frame = navigationBar.frame
        gradient.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 0.9)

        let image = UIImage.image(from: gradient)?.resizableImage(withCapInsets: .zero, resizingMode: .stretch)

        navigationBar.setBackgroundImage(image ?? UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }

    @objc func share() {
        print("Share")
    }

    private func loadContent() {
        if let locationId = self.locationId {
            self.loadingIndicator.isHidden = false
            detailViewModel.fetchData(forLocationId: locationId)
        } else {
            showError()
        }
    }

    private func detailsUpdate(_ error: Error?) {
        DispatchQueue.main.async {
            self.loadingIndicator.isHidden = true

            if error != nil {
                self.showError()
                return
            }
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }

    private func showError() {
        let errorTitle = NSLocalizedString("error_title", comment: "")
        let errorMessage = NSLocalizedString("error_message", comment: "")
        let alert = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - DataSource
extension DetailViewController: UITableViewDataSource {

    enum CellType: Int, CaseIterable {
        case cover = 0
        case title = 1
        case photos = 2
        case about = 3
        case schedule = 4
        case phone = 5
        case address = 6
        case reviews = 7
        case more = 8
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return CellType.allCases.count
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cellType = CellType(rawValue: indexPath.row)
        switch cellType {
        case .cover:
            return getCoverCell()
        case .title:
            return getTitleCell()
        case .photos:
            return getPhotosCell()
        case .about:
            return getAboutCell()
        case .schedule:
            return getScheduleCell()
        case .phone:
            return getPhoneCell()
        case .address:
            return getAddressCell()
        case .reviews:
            return getReviewsCell()
        case .more:
            return getMoreCell()
        case .none:
            fatalError()
        }
    }

    private func getCoverCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "covercell")
                as? CoverCell else {
            fatalError()
        }

        if detailViewModel.locationPicture == nil {
            detailViewModel.downloadCoverPicture( observer: { (image) in
                DispatchQueue.main.async {
                    cell.coverImage.image = image
                }
            })
        }

        cell.coverImage.image = detailViewModel.locationPicture
        cell.backgroundColor = picturePlaceholderColor
        return cell
    }

    private func getTitleCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "titlecell")
                as? TitleCell else {
            fatalError()
        }

        guard let details = detailViewModel.locationDetails else {
            return cell
        }
        cell.name.text = details.name
        cell.starScore.setStarScore(details.review)
        cell.score.text = details.review.description
        return cell
    }

    private func getPhotosCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photoscell")
                as? PhotosCell else {
            fatalError()
        }

        cell.name.text = NSLocalizedString("photos_title", comment: "")

        return cell
    }

    private func getAboutCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "aboutcell")
                as? AboutCell else {
            fatalError()
        }
        if let details = detailViewModel.locationDetails {
            cell.aboutText.text = details.about
        }

        return cell
    }

    private func getScheduleCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "schedulecell")
                as? ScheduleCell else {
            fatalError()
        }

        cell.schedule.text = detailViewModel.getSchedule()

        return cell
    }

    private func getPhoneCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "phonecell")
                as? PhoneCell else {
            fatalError()
        }

        if let details = detailViewModel.locationDetails {
            cell.phone.text = details.phone
        }

        return cell
    }

    private func getAddressCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addresscell")
                as? AddressCell else {
            fatalError()
        }

        if let details = detailViewModel.locationDetails {
            cell.address.text = details.getAddress()
        }

        return cell
    }

    private func getReviewsCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "reviewscell")
                as? ReviewsCell else {
            fatalError()
        }

        return cell
    }

    private func getMoreCell() -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "morecell")
                as? MoreCell else {
            fatalError()
        }

        return cell
    }
}
// MARK: - Delegate
extension DetailViewController: UITableViewDelegate {

}
