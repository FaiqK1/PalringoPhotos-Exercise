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
                    //TODO: CLEAN UP HERE FAIQ
                    //guard data != nil else { return }
                    //let img = UIImage(data: data)
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
        // Reduced Transition duration
        
        
        DispatchQueue.main.async {
            
            if transition {
                UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
                    self.imageView?.image = image
                }, completion: nil)
            } else {
                self.imageView?.image = image
            }
            
        }
    }
    
    

    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel?.text = nil
        self.imageView?.image = nil
    }
}
