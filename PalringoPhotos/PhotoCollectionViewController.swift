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
    private var photos: [[Photo]] = []
    private var isFetchingPhotos = false
    

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
    
    var selectedPhotographerImage : UIImage? {
        didSet {
            let customImageButton = ImageBarButton(withImage: selectedPhotographerImage)
            customImageButton.button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
            self.navigationItem.leftBarButtonItem = customImageButton.barButtonItem()
        }
    }
    

    private var selectedPhoto : Photo? //CommentsDetailVC use only
    
    
    
    
    //MARK: - VC LifeCycle
    
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
    
    
    deinit {
        print("MEMORY RELEASED - PhotoCollectionVC")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

}

extension PhotoCollectionViewController {
    
    // MARK: - UICollectionViewDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 200)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photoSelected = self.photos[indexPath.section][indexPath.item]
        selectedPhoto  = photoSelected
        modalToCommentsDetailVC()
    }
    
    
    private func modalToCommentsDetailVC() {
        performSegue(withIdentifier: EnumSegues.photosToDetailComments.segueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        if segue.identifier == EnumSegues.photosToDetailComments.segueIdentifier {
            if let destVc = segue.destination as? CommentsDetailViewController {
                destVc.selectedPhoto      = selectedPhoto
            }
        }
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnumIdentifiers.photos.cellId, for: indexPath) as? PhotoCell
        else {
            return UICollectionViewCell()
        }

        let photo = self.photo(forIndexPath: indexPath)
        cell.photo = photo

        return cell
    }
    
    
    
    
    
}



// MARK: - Fetch Photo Data

extension PhotoCollectionViewController {
    
    
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
