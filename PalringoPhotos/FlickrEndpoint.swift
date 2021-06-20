//
//  FlickrEndpoint.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 20/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import Foundation

enum FlickrEndpoint: Endpoint {
    case getPhotos(id: String, page: Int, _ per_page: Int = 20)
    case getPhotoComments(photoId: String)
    
    //SCHEME
    var scheme: String {
        switch self {
        default:
            return "https"
        }
    }
    //BASE URL
    var baseURL: String {
        switch self {
        default:
            return "api.flickr.com" //re-use base url by assigning it to default
        }
    }
    
    //PATH
    var path: String {
        switch self {
        case .getPhotos:
            return "/services/rest/"
        case .getPhotoComments:
            return "/services/rest/"
        }
    }
    
    //QUERY ITEMS
    var parameters: [URLQueryItem] {
        let apiKey = "409c210c52dc34ed07fcc512b82e859b" //NOT SAFE TO HAVE IT EXPOSED HERE
        //Perhaps store this away from the client side.
        //Would prefer to have a more rigorous authentication flow.
        
        switch self {
            case .getPhotos(let id, let page, let per_page):
                return [
                    URLQueryItem(name: "method", value: "flickr.people.getPhotos"),
                    URLQueryItem(name: "api_key", value: apiKey),
                    URLQueryItem(name: "format", value: "json"),
                    URLQueryItem(name: "user_id", value: id),
                    URLQueryItem(name: "page", value: "\(page)"),
                    URLQueryItem(name: "per_page", value: "\(per_page)"),
                    URLQueryItem(name: "extras", value: "url_-,url_z")
                    
                ]
            case .getPhotoComments(let photoId):
                return [
                    URLQueryItem(name: "method", value: "flickr.photos.comments.getList"),
                    URLQueryItem(name: "api_key", value: apiKey),
                    URLQueryItem(name: "format", value: "json"),
                    URLQueryItem(name: "photo_id", value: photoId)
                    
                ]
        }
    }
            
    var httpMethod: String {
        switch self {
        case .getPhotos:
            return "GET"
        case .getPhotoComments:
            return "GET"
        }
    }
                
}
