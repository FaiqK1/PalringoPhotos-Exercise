//
//  Photographers.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 17/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import Foundation



struct Photographers: Equatable {
    let id: String
    let name: String
    let url: URL
    
    static func ==(lhs: Photographers, rhs: Photographers) -> Bool {
        return lhs.id == rhs.id
    }
}
