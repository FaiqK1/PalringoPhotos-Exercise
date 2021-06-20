//
//  FlickrFetcher.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 20/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

class FlickrFetcher {
    
    static let shared = FlickrFetcher()
    
    
    func getPhotosUrls(endpoint: Endpoint, completion: @escaping ([Photo])->()) {
        
        //compile components:
        var components = URLComponents()
        components.scheme     = endpoint.scheme
        components.host       = endpoint.baseURL
        components.path       = endpoint.path
        components.queryItems = endpoint.parameters
        
        guard let url = components.url?.absoluteURL else { return }
        
        request(url: url) { (object) in
            DispatchQueue.global().async {
                let photos = object.value(forKeyPath: "photos.photo") as? [NSDictionary]
                let returnPhotos = photos?
                    .map({ Photo(dictionary: $0) })
                    .filter({ $0 != nil })
                    as? [Photo] ?? []
                
                DispatchQueue.main.async {
                    completion(returnPhotos)
                }
                
            }
        }
    }
    
    
    func getPhotoComments(endpoint: Endpoint, completion: @escaping ([PhotoComment])->()) {

        //compile components:
        var components = URLComponents()
        components.scheme     = endpoint.scheme
        components.host       = endpoint.baseURL
        components.path       = endpoint.path
        components.queryItems = endpoint.parameters
//
        guard let url = components.url?.absoluteURL else { return }
        

        request(url: url) { (object) in
            DispatchQueue.global().async {
                let comments = object.value(forKeyPath: "comments.comment") as? [NSDictionary]
                let returnComments = comments?
                    .map({ PhotoComment(dictionary: $0) })
                    .filter({ $0 != nil })
                    as? [PhotoComment] ?? []

                DispatchQueue.main.async {
                    completion(returnComments)
                }
            }
        }
        
    }
    
    
    
    private func request(url: URL, completion: @escaping (NSDictionary) -> ()) {
        
        _ = CachedRequest.request(url: url) { data, isCached in
            guard let data = data else { return }
            
            if let jsonDictionary = self.processJSON(data: data) {
                completion(jsonDictionary)
            }
        }
        
    }
    
    
    private func processJSON(data: Data) -> NSDictionary? {
        let dataString = String(data: data, encoding: String.Encoding.utf8)
        
        guard let jsonString = dataString?
            .replacingOccurrences(of: "jsonFlickrApi(", with: "")
                .replacingOccurrences(of: ")", with: "").data(using: .utf8) else { return [:] }
        
        do {
            let result = try JSONSerialization.jsonObject(with: jsonString,options: .mutableContainers)
            return result as? NSDictionary
        } catch {
            print(error)
        }
        return nil
    }
}


