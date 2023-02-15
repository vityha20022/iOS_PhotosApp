//
//  PhotoDetailInformationViewController.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import UIKit

class PhotoDetailInformationViewController: UIViewController {
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
    
    var previous: UILabel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        view.addSubview(photoImageView)
        photoImageView.image = photoImageView.image?.resized(to: CGSize(width: 400, height: 250))
        
        photoImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        
        photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
        
        setupLabels()
    }
    
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
    
    private func setupLabels() {
        addInfoLabels(headerName: "Author", info: "Victor Borisovskiy")
        addInfoLabels(headerName: "Created at", info: "05.12.1998")
        addInfoLabels(headerName: "Location", info: "Omsk")
        addInfoLabels(headerName: "Downloads", info: "235")
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
