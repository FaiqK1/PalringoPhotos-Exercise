//
//  PhotoCollectionViewController.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import UIKit


class PhotoCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    //MARK: - OUTLETS:
    @IBOutlet var loadingView: UIView?
    //@IBOutlet weak var collectionView: UICollectionView? //Not needed here being a UICollectionViewController
    
    //MARK: - PROPERTIES
    var photos: [[Photo]] = []
    var isFetchingPhotos = false
    

    var selectedPhotographerID : String? {
        didSet {
            fetchNextPage()
        }
    }
    var selectedPhotographerName : String? {
        didSet {
            self.title = selectedPhotographerName
        }
    }
    
    
    
    //MARK: - VC LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = EnumPhotographers.dersascha.displayName
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension PhotoCollectionViewController {
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    
    // MARK: - UICollectionViewDataSource
    
    func photo(forIndexPath indexPath: IndexPath) -> Photo {
        if indexPath.section == photos.count - 1 {
            fetchNextPage()
        }
        return self.photos[indexPath.section][indexPath.item]
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnumIdentifiers.photos.cellId, for: indexPath) as! PhotoCell

        let photo = self.photo(forIndexPath: indexPath)
        cell.photo = photo

        return cell
    }
    
    
    
    
    // MARK: - Fetch Photo Data
    
    @objc private func fetchNextPage() {
        if isFetchingPhotos { return }
        isFetchingPhotos = true
        
        if let loadingView = loadingView, let collectionView = self.collectionView.superview {
            self.collectionView.addSubview(loadingView)
            loadingView.layer.cornerRadius = 5
            loadingView.sizeToFit()
            loadingView.center = loadingCenter(forView: collectionView, count: photos.count)
        }
        
        let currentPage = photos.count
        guard let photographerId = selectedPhotographerID else { print("Error with photographer string"); return } //HANDLE alert here
        
        FlickrFetcher().getPhotosUrls(id: photographerId,forPage: currentPage + 1) { [weak self] in
            if $0.count > 0 {
                self?.photos.append($0)
                self?.collectionView.insertSections(IndexSet(integer: currentPage))
                self?.isFetchingPhotos = false
            }
        
            self?.loadingView?.removeFromSuperview()
        }
    }
}
