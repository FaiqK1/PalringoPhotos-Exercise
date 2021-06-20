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
            
            if selectedPhotographerImage != nil {
                let customImageButton = ImageBarButton(withImage: selectedPhotographerImage ?? nil, padding: 2)
                customImageButton.button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
                
                self.navigationItem.leftItemsSupplementBackButton = true
                //self.navigationItem.leftBarButtonItem = customImageButton.barButtonItem()
                
                let backButton = UIBarButtonItem(title: "  ", style: .plain, target: nil, action: nil)
                self.navigationItem.leftBarButtonItems = [backButton, customImageButton.barButtonItem()]
                
                
            }
            
        }
    }
    

    private var selectedPhoto : Photo? //CommentsDetailVC use only
    
    
    
    
    
    
    
    
    deinit {
        print("MEMORY RELEASED - PhotoCollectionVC")
    }
    
    
    

}

//MARK: - VC Life Cycle

extension PhotoCollectionViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        //TODO: I would think about clearing the cache here at some point...
    }
    
    
    //NAVIGATE BACK
    @objc func backAction() {
        navigationController?.popViewController(animated: true)
    }
}




//MARK: - LOADER

extension PhotoCollectionViewController {
    
    fileprivate func removeLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { //Just for the visuals
            self.loadingView?.removeFromSuperview()
        }
    }
    
    fileprivate func showLoader() {
        if let loadingView = loadingView {
            self.view.addSubview(loadingView)
            self.view.bringSubviewToFront(loadingView)
            loadingView.layer.cornerRadius = 5
            loadingView.sizeToFit()
            loadingView.center = loadingCenter(forView: self.view)
        }
    }
}

// MARK: - UICollectionView

extension PhotoCollectionViewController {
    
    // MARK: UICollectionView Delegate Functions

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heightToUse : CGFloat = 200
        
        if UIScreen.main.bounds.width > 500 { //Just handling iPad sizing, crudely
            heightToUse = UIScreen.main.bounds.height / 3
        }
        return CGSize(width: collectionView.bounds.width, height: heightToUse)
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
    
    
    
    // MARK: UICollectionView DataSource Functions
    
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
        
        showLoader()
        
        let currentPage = photos.count
        guard let photographerId = selectedPhotographerID else { print("Error with photographer id"); return } //HANDLE alert here
        
        //NEW:
        FlickrFetcher.shared.getPhotosUrls(endpoint: FlickrEndpoint.getPhotos(id: photographerId, page: currentPage + 1)) { [weak self] in
            if $0.count > 0 {
                self?.photos.append($0)
                self?.collectionView.insertSections(IndexSet(integer: currentPage))
                self?.isFetchingPhotos = false
            }
        
            self?.removeLoader()
        }
        
    }
}
