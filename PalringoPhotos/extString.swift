//
//  extString.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 18/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .unicode) else { return nil }
        do {
            return try NSAttributedString(
                data: data,
                options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue],
                documentAttributes: nil)
        } catch {
            return nil
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
