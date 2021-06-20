//
//  PhotoComment.swift
//  PalringoPhotos
//
//  Created by Benjamin Briggs on 16/10/2016.
//  Copyright © 2016 Palringo. All rights reserved.
//

import Foundation

struct PhotoComment {
    let id: String
    let author: String
    let comment: NSAttributedString
    
    
    init?(dictionary: NSDictionary) {
        guard
            let idString = dictionary.value(forKeyPath:"id") as? String,
            let authorString = dictionary.value(forKeyPath:"authorname") as? String,
            let commentString = dictionary.value(forKeyPath:"_content") as? String
            else { return nil }

        guard let convertedString = commentString.htmlToAttributedString else { return nil }
        
        self.id      = idString
        self.author  = authorString
        self.comment = convertedString
    }
}


