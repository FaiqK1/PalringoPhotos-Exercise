//
//  CommentsDetailViewController.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 18/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

class CommentsDetailViewController: UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet var loadingView: UIView?
    @IBOutlet weak var commentsTitle: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    //MARK: - PROPERTIES
    var selectedPhoto      : Photo? {
        didSet {
            fetchComments()
        }
    }
    private var comments : [PhotoComment]?
    
    
    
    deinit {
        print("MEMORY RELEASED - CommentsDetailVC")
    }
    
}

//MARK: - VC Life Cycle
extension CommentsDetailViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLoader()
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}


//MARK: - LOADER

extension CommentsDetailViewController {
    
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


//MARK: - FETCH COMMENTS

extension CommentsDetailViewController {
    
    
    private func fetchComments() {
        guard let photo = selectedPhoto else { return }
        
        //NEW
        let endPoint = FlickrEndpoint.getPhotoComments(photoId: photo.id)
        FlickrFetcher.shared.getPhotoComments(endpoint: endPoint) { [weak self] (commentsArray) in
            
            commentsArray.isEmpty ? self?.hideTableView() : self?.loadComments(commentsArray: commentsArray)
            
            self?.removeLoader()
        }
    }
}

//MARK: - TABLVIEW HELPERS:
extension CommentsDetailViewController {
    
    fileprivate func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    fileprivate func hideTableView() {
        DispatchQueue.main.async {
            self.tableView.alpha = 0
        }
    }
    
    fileprivate func loadComments(commentsArray: [PhotoComment]) {
        self.comments = commentsArray
        
        DispatchQueue.main.async {
            self.commentsTitle.text = "Comments(\(commentsArray.count)):"
        }
        self.refreshTableView()
    }
}

//MARK: - TABLEVIEW DELEGATE

extension CommentsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - TABLEVIEW DATA SOURCE

extension CommentsDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        let count = comments?.count
//        if count == 0 {
//            tableView.alpha = 0
//        }
//        return count ?? 0
        return comments?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as? CommentsTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.authorLbl.text             = "Author: \(comments?[indexPath.row].author ?? "Unknown")"
        cell.commentsLbl.attributedText = comments?[indexPath.row].comment //.htmlToAttributedString
        //Probably not best place for this convertion, noticed some choppy behaviour on scroll for a photo with loads of comments (on load before cache)
        //TODO: Perhaps convert before comments are placed into tableView.deque - currently done at Comments model initalizer.
        
        return cell
    }
    
    
}
