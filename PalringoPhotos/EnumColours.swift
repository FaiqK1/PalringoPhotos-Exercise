//
//  EnumColours.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 20/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

enum EnumColours {
    case greyThemeColour
    
    var colour : UIColor {
        switch self {
            case .greyThemeColour:
                return UIColor(red: 41, green: 41, blue: 41, alpha: 1.0)
                
        }
    }
}
