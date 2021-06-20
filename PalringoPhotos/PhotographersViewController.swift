//
//  PhotographersViewController.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 17/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit


class PhotographersViewController: UIViewController {
    
    //MARK: - OUTLETS:
    @IBOutlet var loadingView: UIView?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButton: UIButton!
    
    //MARK: - PROPERTIES:
    private var preApprovedPhotographers : [Photographers]?
    //private var profilePhotos = [UIImage]()
    private var selectedId    = String()
    private var selectedName  = String()
    private var selectedImage : UIImage?
    private var imageViewHeight : CGFloat = 125
    
    
    //Visible only when no photographers loaded
    @IBAction func refreshPressed(_ sender: UIButton) {
        sender.preventRepeatedPresses()
        showLoader()
        fetchPhotographers()
    }
}



//MARK: - VC Life Cycle

extension PhotographersViewController {
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Select a photographer"
        setUpUI()
        showLoader()
        fetchPhotographers()
        
        NotificationCenter.default.addObserver(self, selector: #selector(hideTableView), name: Notification.Name(rawValue: "hidePhotographersTableView"), object: nil)
    }
    
    //MARK: - SET UP UI
    fileprivate func setUpUI() {
        refreshButton.layer.borderWidth = 1.0
        refreshButton.layer.borderColor = UIColor.white.cgColor
        refreshButton.layer.cornerRadius = 12
    }
    
    
    
}


//MARK: - LOADER

extension PhotographersViewController {
    
    fileprivate func removeLoader() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
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



//MARK: - FETCHING PHOTOGRAPHERS

extension PhotographersViewController {
    
    
    fileprivate func fetchPhotographers() {
        // Note: this would be a network call to retrieve photographers most likely.
        // Just using a crude/quick way of setting up photographers
        preApprovedPhotographers = [
            Photographers(id: EnumPhotographers.alfredoliverani.rawValue, name: EnumPhotographers.alfredoliverani.displayName, url: EnumPhotographers.alfredoliverani.imageURL),
            Photographers(id: EnumPhotographers.dersascha.rawValue, name: EnumPhotographers.dersascha.displayName, url: EnumPhotographers.dersascha.imageURL),
            Photographers(id: EnumPhotographers.photographybytosh.rawValue, name: EnumPhotographers.photographybytosh.displayName, url: EnumPhotographers.photographybytosh.imageURL)
        ]
        
        refreshTableView()
        //fetchProfilePhotos(preApprovedPhotographers!)
    
    }
    
    /*
    fileprivate func fetchProfilePhotos(_ photographers: [Photographers]) {
        
        for photographer in photographers {
            URLSession.shared.dataTask(with: photographer.url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                
                guard let data = data, error == nil else {
                    DispatchQueue.main.async {
                        self.tableView.alpha = 0
                    }
                    
                    self.removeLoader()
                    return
                }
                guard let img = UIImage(data: data) else { return }
                
                //>> Update Profile Photo UIImage Array
                self.profilePhotos.append(img)
                   
                if photographer.id == photographers.last?.id {
                    self.refreshTableView()
                
                }
            }.resume()
            
        }
        
        print("photoCount: \(self.profilePhotos.count)")
        //self.refreshTableView()
    }
     */
    
    //FIXME: IMAGES often return in wrong order / could be related to tableView.deque.... Need to investigate further
}


//MARK: - TableView
extension PhotographersViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - TABLEVIEW HELPERS
    @objc fileprivate func hideTableView() {
        
        DispatchQueue.main.async {
            self.showLoader() //for UX
            self.tableView.alpha = 0
        }
        removeLoader() //for UX
    }
    
    fileprivate func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.alpha = 1
            self.tableView.reloadData()
            
            self.loadingView?.removeFromSuperview()
        }
        
    }
    
    //MARK: DATA SOURCE FUNCTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preApprovedPhotographers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EnumIdentifiers.photographers.cellId, for: indexPath) as? PhotographersTableViewCell else { return UITableViewCell() }
        
        //Cell settings:
        cell.profileImageView?.layer.cornerRadius = (cell.profileImageView?.bounds.height ?? imageViewHeight) / 2
        cell.profileImageView?.layer.borderWidth = 1.0
        cell.profileImageView?.layer.borderColor = EnumColours.greyThemeColour.colour.cgColor
        cell.profileImageView?.image = nil
        cell.profilePhoto = preApprovedPhotographers?[indexPath.row]
        
        return cell
    }
    
    
    //MARK: DELEGATE FUNCTIONS:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let selectedCell = self.tableView.cellForRow(at: indexPath) as? PhotographersTableViewCell else {
            return
        }
        
        
        goToPhotos(name:preApprovedPhotographers![indexPath.row].name,
                   id: preApprovedPhotographers![indexPath.row].id,
                   image: selectedCell.profileImageView?.image)
        
        
    }
}

//MARK: - SEGUE Action & Preparation
extension PhotographersViewController {
    
    private func goToPhotos(name: String, id: String, image: UIImage?) {
        selectedId    = id
        selectedName  = name
        
        image == nil ? (selectedImage = nil) : (selectedImage = image)
        //selectedImage = image
        performSegue(withIdentifier: EnumSegues.photographersToPhotos.segueIdentifier, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == EnumSegues.photographersToPhotos.segueIdentifier {
            
            if let destVc = segue.destination as? PhotoCollectionViewController {
                destVc.selectedPhotographerID    = selectedId
                destVc.selectedPhotographerName  = selectedName
                destVc.selectedPhotographerImage = selectedImage
            }
        }
    }
    
    
}
