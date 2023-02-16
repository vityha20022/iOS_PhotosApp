//
//  ViewController.swift
//  PhotosApp
//
//  Created by Виктор Борисовский on 15.02.2023.
//

import UIKit
import SDWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var favouritesPhotosList: [GettingPhotoResults] {
        let photosList = getFavouritesPhotosList()
        return photosList
    }
    
    let favouritesTableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "favouritePhotoCell")
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        favouritesTableView.dataSource = self
        favouritesTableView.delegate = self
        view.addSubview(favouritesTableView)
        
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favouritesTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        favouritesTableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouritesPhotosList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favouritePhotoCell", for: indexPath)
        
        cell.textLabel?.text = favouritesPhotosList[indexPath.row].user.name
        
        let photoUrl = favouritesPhotosList[indexPath.row].urls["regular"]
        guard let imageUrl = photoUrl, let url = URL(string: imageUrl) else {
            return cell
        }
        
        let transformer = SDImageResizingTransformer(size: CGSize(width: 100, height: 90), scaleMode: .aspectFit)
        
        cell.imageView?.sd_setImage(with: url,
                                    placeholderImage: UIColor.systemBackground.image(CGSize(width: 100, height: 90)),
                                    context: [.imageTransformer: transformer],
                                    progress: nil,
                                    completed: { _, _, _, _ in
            cell.setNeedsLayout()
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let photoDetailInformationVC = PhotoDetailInformationViewController()
        let favouritePhoto = favouritesPhotosList[indexPath.row]
        photoDetailInformationVC.unsplashPhoto = UnsplashPhoto(id: favouritePhoto.id, width: favouritePhoto.width, height: favouritePhoto.height, urls: favouritePhoto.urls)
        navigationController?.pushViewController(photoDetailInformationVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let favouritePhoto = favouritesPhotosList[indexPath.row]
            removeFavouritePhoto(id: favouritePhoto.id)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    private func setupNavigationBar() {
        let titleLabel = UILabel()
        titleLabel.text = "FAVOURITES"
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.textColor = .gray
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: titleLabel)
    }

}

// MARK: - UIColor

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 1, height: 1)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}
