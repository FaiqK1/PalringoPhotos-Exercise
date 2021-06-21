//
//  Endpoint.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 20/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import Foundation

protocol Endpoint {
    /// HTTP or HTTPS
    var scheme: String { get }
    
    // Example: "api.flicker.com"
    var baseURL: String { get }
    
    // "/services/rest"
    var path: String { get }
    
    // [URLQueryItem(name: "api_key", value: API_KEY)]
    var parameters: [URLQueryItem] { get }
    
    // "GET"
    var httpMethod: String { get }
    
}
