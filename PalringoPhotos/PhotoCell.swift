//
//  PhotoCell.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    
    //MARK: - OUTLETS:
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    
    
    //MARK: - PROPERTIES:

    private var fetchTask: URLSessionTask? {
        willSet {
            fetchTask?.cancel()
        }
    }

    
    var photo: Photo? {
        didSet {
            nameLabel?.text = photo?.name ?? ""
            
            if let photo = photo {
                self.fetchTask = CachedRequest.request(url: photo.url) { data, isCached in
                    
                    guard let data = data else { return }
                    guard let img = UIImage(data: data) else { return }
                    
                    if isCached {
                        self.updatePhotoImageView(img)
                        
                    } else if self.photo == photo {
                        
                        self.updatePhotoImageView(img, transition: true)
                    }
                    
                }
            }
        }
        
        
    }
    
    
    fileprivate func updatePhotoImageView(_ image: UIImage, transition: Bool = false) {
        //FAIQ - MOVED TO MAIN THREAD
        // Removed Transition duration
        // Replaced with animating with alpha instead to achieve same effect
        
        DispatchQueue.main.async {
            self.imageView?.image = image
            self.imageView?.alpha = 0
            
            ////DECIDED to use .animate with Alpha instead, seems less intensive and achieves same effect as below
            UIView.animate(withDuration: 1.0) {
                self.imageView?.alpha = 1
            }
            
        }
    }
    
    

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel?.text = nil
        self.imageView?.image = nil
    }
}
