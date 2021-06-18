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
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - PROPERTIES:
    private var preApprovedPhotographers : [Photographers]?
    private var profilePhotos = [UIImage]()
    private var selectedId    = String()
    private var selectedName  = String()
    private var selectedImage = UIImage()
    
    
}

//MARK: - VC Life Cycle
extension PhotographersViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Tap to browse photos"
        fetchPhotographers()
    }
    
    //MARK: - FETCHING PHOTOGRAPHERS
    fileprivate func fetchPhotographers() {
        // Note: this would be a network call to retrieve photographers most likely.
        // Just using a crude/quick way of setting up photographers
        preApprovedPhotographers = [
            Photographers(id: EnumPhotographers.alfredoliverani.rawValue, name: EnumPhotographers.alfredoliverani.displayName, url: EnumPhotographers.alfredoliverani.imageURL),
            Photographers(id: EnumPhotographers.dersascha.rawValue, name: EnumPhotographers.dersascha.displayName, url: EnumPhotographers.dersascha.imageURL),
            Photographers(id: EnumPhotographers.photographybytosh.rawValue, name: EnumPhotographers.photographybytosh.displayName, url: EnumPhotographers.photographybytosh.imageURL)
        ]
        fetchPhotos(preApprovedPhotographers!)
    
    }
    
    func fetchPhotos(_ photographers: [Photographers]) {
        
        for photographer in photographers {
            //print("NAME: \(photographer.name) URL: \(photographer.url)")
            
            //Thought i would utilize the CURRENT CachedRequest Class here
            _ = CachedRequest.request(url: photographer.url) { data, isCached in
                guard let data = data else { return }
                guard let img = UIImage(data: data) else { return }
                
                if isCached {
                    self.profilePhotos.append(img)
                    
                } else {
                    self.profilePhotos.append(img)
                }
                self.refreshTableView()
                //FIXME: This approach is risky, cache could send back images in a different order
            }
        }
    }
    
    //MARK: - REFRESH TABLEVIEW
    fileprivate func refreshTableView() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


//MARK: - TableView
extension PhotographersViewController: UITableViewDataSource, UITableViewDelegate {
    
    //MARK: DATA SOURCE FUNCTIONS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preApprovedPhotographers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.separatorStyle = .none
        
        let cell = tableView.dequeueReusableCell(withIdentifier: EnumIdentifiers.photographers.cellId, for: indexPath)
        //Cell Settings:
        cell.textLabel?.textColor   = .white
        cell.imageView?.contentMode = .scaleToFill
        
        guard let photographer = preApprovedPhotographers?[indexPath.row] else {
            cell.imageView?.image = nil
            cell.textLabel?.text = "Error retrieving name"
            return cell
        }
        
        //APPLY IMAGES when they have all been loaded
        //Note i would not adopt this approach but i went with this as i already had preApprovedPhotographers data in place.
        if profilePhotos.count == preApprovedPhotographers?.count {
            cell.imageView?.image = profilePhotos[indexPath.row]
            cell.textLabel?.text  = photographer.name//preApprovedPhotographers?[indexPath.row].name
        } else {
            cell.imageView?.image = nil
            cell.textLabel?.text  = photographer.name//preApprovedPhotographers?[indexPath.row].name
        }
        
        return cell
    }
    
    
    //MARK: DELEGATE FUNCTIONS:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //print("\(preApprovedPhotographers![indexPath.row].name)")
        
        goToPhotos(name:preApprovedPhotographers![indexPath.row].name, id: preApprovedPhotographers![indexPath.row].id, image: profilePhotos[indexPath.row])
    }
}

//MARK: - SEGUE Action & Preparation
extension PhotographersViewController {
    
    private func goToPhotos(name: String, id: String, image: UIImage) {
        selectedId    = id
        selectedName  = name
        selectedImage = image
        
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
