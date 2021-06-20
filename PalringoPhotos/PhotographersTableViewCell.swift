//
//  PhotographersTableViewCell.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 20/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

class PhotographersTableViewCell: UITableViewCell {
    
    
    //MARK: - OUTLETS:
    @IBOutlet weak var profileImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    

    //MARK: - PROPERTIES:
    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }
    
    var profilePhoto: Photographers? {
        didSet {
            
            
            if let photo = profilePhoto {
                self.fetchTask = CachedRequest.request(url: photo.url) { data, isCached in
                    
                    guard let data = data else {
                        NotificationCenter.default.post(name: Notification.Name(rawValue: "hidePhotographersTableView"), object: nil)
                        return
                    }
                    guard let img  = UIImage(data: data) else { return }
                    guard let name = self.profilePhoto?.name else { return }
                    self.updateNameAndProfileImageView(img, name: name)
                }
            }
            
            
            
        }
    }
    
    
    fileprivate func updateNameAndProfileImageView(_ image: UIImage, name: String?) {
        DispatchQueue.main.async {
            self.nameLabel?.text = name
            self.profileImageView?.image = image
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel?.text = nil
        self.profileImageView?.image = nil
    }
}
