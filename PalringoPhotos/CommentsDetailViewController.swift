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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    fileprivate func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    
    

}

//MARK: - FETCH COMMENTS

extension CommentsDetailViewController {
    
    fileprivate func removeLoader() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
        }
    }
    
    func fetchComments() {
        guard let photo = selectedPhoto else { return }
        
        //TODO: Placed in quickly - need to check this works------
        if let loadingView = loadingView {
            self.view.addSubview(loadingView)
            self.view.bringSubviewToFront(loadingView)
            loadingView.layer.cornerRadius = 5
            loadingView.sizeToFit()
            loadingView.center = loadingCenter(forView: self.view)
        }
        //-------------------------------------------------------
        
        FlickrFetcher().getPhotoComments(for: photo) { [weak self] (comments) in
            //print(comments)s
            self?.comments = comments
            self?.refreshTableView()
            
            self?.removeLoader()
            
            
        }
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
        let count = comments?.count
        if count == 0 {
            tableView.alpha = 0
        }
        return count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell", for: indexPath) as? CommentsTableViewCell else {return UITableViewCell() }
        
        cell.authorLbl.text             = "Author: \(comments?[indexPath.row].author ?? "Unknown")"
        cell.commentsLbl.attributedText = comments?[indexPath.row].comment.htmlToAttributedString
        
        return cell
    }
    
    
}
