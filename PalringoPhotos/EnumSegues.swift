//
//  EnumSegues.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 17/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import Foundation

enum EnumSegues {
    case photographersToPhotos
    
    var segueIdentifier : String {
        switch self {
            case .photographersToPhotos:
                return "goToPhotos"
        }
    }
}
