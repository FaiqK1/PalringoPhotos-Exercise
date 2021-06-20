//
//  extString.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 18/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

//DEV NOTES:
///resources: https://github.com/apple/swift/blob/main/docs/StringManifesto.md#high-performance-string-processing
//Conversion was taking place at CellForRow on comments TableView as a quick implementation. But decided to move this conversion code in PhotoComment.swift model's init instead.

extension String {
    
    var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return nil }
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
