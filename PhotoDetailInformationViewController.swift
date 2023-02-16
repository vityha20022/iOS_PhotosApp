//
//  PhotoDetailInformationViewController.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import UIKit

class PhotoDetailInformationViewController: UIViewController {
    
    var networkDataFetcher = NetworkDataFetcher()
    
    private let photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBackground
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var unsplashPhoto: UnsplashPhoto! {
        didSet {
            let photoUrl = unsplashPhoto.urls["regular"]
            guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else {
                return
            }
            
            photoImageView.sd_setImage(with: url)
        }
    }
    
    var unsplashPhotoDetails: GettingPhotoResults?
    
    var previous: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupImageView()
        setupLabels()
        setupFavouritesButton()
    }
    
    // MARK: - Setup UI Elements
    
    private func setupImageView() {
        view.addSubview(photoImageView)
        photoImageView.image = photoImageView.image?.resized(to: CGSize(width: 400, height: 250))
        
        photoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        photoImageView.isUserInteractionEnabled = true
    }
    
    private func setupLabels() {
        let imageId = unsplashPhoto.id
        networkDataFetcher.fetchImage(id: imageId) { result in
            guard let fetchedImage = result else {
                return
            }
            self.unsplashPhotoDetails = fetchedImage
            self.addInfoLabels(headerName: "Author", info: fetchedImage.user.name)
            let isoDate = fetchedImage.created_at
            let isoDateFormatter = ISO8601DateFormatter()
            let date = isoDateFormatter.date(from: isoDate)!
            let regularDateFormatter = DateFormatter()
            regularDateFormatter.dateFormat = "dd/MM/YY"
            self.addInfoLabels(headerName: "Created at", info: regularDateFormatter.string(from: date))
            self.addInfoLabels(headerName: "Location", info: fetchedImage.location.country ?? "No information")
            self.addInfoLabels(headerName: "Downloads", info: String(fetchedImage.downloads))
        }
    }
    
    private func setupFavouritesButton() {
        let favouriteButton = UIButton()
        photoImageView.addSubview(favouriteButton)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 200, weight: .regular, scale: .large)
        favouriteButton.setImage(UIImage(systemName: "heart", withConfiguration: largeConfig), for: .normal)
        favouriteButton.setImage(UIImage(systemName: "heart.fill", withConfiguration: largeConfig), for: .selected)
        favouriteButton.tintColor = .white
        
        favouriteButton.isSelected = false
        
        if isFavouritePhoto(id: unsplashPhoto.id) {
            favouriteButton.isSelected = true
        }
        
        favouriteButton.addTarget(self, action: #selector(favouritesButtonPressed), for: .touchUpInside)

        favouriteButton.translatesAutoresizingMaskIntoConstraints = false
        favouriteButton.topAnchor.constraint(equalTo: photoImageView.topAnchor, constant: 15).isActive = true
        favouriteButton.trailingAnchor.constraint(equalTo: photoImageView.trailingAnchor, constant: -15).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    // MARK: - Utils functions
    
    private func addInfoLabels(headerName: String, info: String) {
        let headerLabel = UILabel()
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.font = UIFont.boldSystemFont(ofSize: 20)
        headerLabel.text = headerName
        
        view.addSubview(headerLabel)
        headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        if let previous = previous {
            headerLabel.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
        } else {
            headerLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10).isActive = true
        }
        
        let infoLabel = UILabel()
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        infoLabel.font = UIFont.systemFont(ofSize: 15)
        infoLabel.text = info
        
        view.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 10).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        previous = infoLabel
    }
    
    // MARK: - Selectors
    
    @objc func favouritesButtonPressed(sender: UIButton!) {
        if !sender.isSelected {
            if let photoDetails = unsplashPhotoDetails {
                addFavouritePhoto(id: photoDetails.id, photo: photoDetails)
            }
        } else {
            removeFavouritePhoto(id: unsplashPhoto.id)
        }
        
        sender.isSelected = !sender.isSelected
    }
}

// MARK: - UIImage

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
