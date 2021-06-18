//
//  Photo.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 14/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import Foundation

struct Photo: Equatable {
    let id: String
    let name: String
    let url: URL

    static func ==(lhs: Photo, rhs: Photo) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    init?(dictionary: NSDictionary) {
        guard
        let idString = dictionary.value(forKeyPath:"id") as? String,
        let nameString = dictionary.value(forKeyPath:"title") as? String,
        let originalString =
            dictionary.value(forKeyPath:"url_z") as? String ??
            dictionary.value(forKeyPath:"url_-") as? String,
        let url = URL(string: originalString)
        else {return nil}
        
        self.id   = idString
        self.name = nameString
        self.url  = url
    }
}

