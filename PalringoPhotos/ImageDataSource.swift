//
//  ImageDataSource.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit



class ImageDataSource: NSObject, UICollectionViewDataSource {
    
    
    //MARK: - OUTLETS:
    @IBOutlet var loadingView: UIView?
    @IBOutlet weak var collectionView: UICollectionView?
    
    
    
    //MARK: - PROPERTIES
    private let reuseIdentifier = "PhotoCell" //FIXME: MOVED INSIDE CLASS SCOPE - FAIQ
    var photos: [[Photo]] = []
    var isFetchingPhotos = false

    

    override init() {
        super.init()
        fetchNextPage()
    }
    
    
    func photo(forIndexPath indexPath: IndexPath) -> Photo {
        if indexPath.section == photos.count - 1 {
            fetchNextPage()
        }
        return self.photos[indexPath.section][indexPath.item]
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell

        let photo = self.photo(forIndexPath: indexPath)
        cell.photo = photo

        return cell
    }
    
    func loadingCenter() -> CGPoint {
        let y: CGFloat
        if (photos.count > 0) {
            y = (self.collectionView?.bounds.maxY ?? 0) - 60
        } else {
            y = (self.collectionView?.bounds.midY ?? 0)
        }

        return CGPoint(
            x: (self.collectionView?.bounds.midX ?? 0),
            y: y
        )
    }
    
    private func fetchNextPage() {
        if isFetchingPhotos { return }
        isFetchingPhotos = true
        
        if let loadingView = loadingView, let collectionView = collectionView?.superview {
            collectionView.addSubview(loadingView)
            loadingView.layer.cornerRadius = 5
            loadingView.sizeToFit()
            loadingView.center = loadingCenter()
        }
        
        let currentPage = photos.count
        
        FlickrFetcher().getPhotosUrls(forPage: currentPage+1) { [weak self] in
            if $0.count > 0 {
                self?.photos.append($0)
                self?.collectionView?.insertSections(IndexSet(integer: currentPage))
                self?.isFetchingPhotos = false
            }
        
            self?.loadingView?.removeFromSuperview()
        }
    }
}
