//
//  EnumIdentifiers.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 17/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import Foundation


enum EnumIdentifiers {
    case photographers
    case photos
    
    var cellId: String {
        switch self {
        case .photographers:
            return "photographersCell"
        case .photos:
            return "PhotoCell"
        }
    }
}
