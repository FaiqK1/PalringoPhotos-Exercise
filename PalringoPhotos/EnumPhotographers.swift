//
//  Photographers.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 17/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

//NOTES:
//Brought into seperate file
//Also changed the http to https - to avoid slower decode of http

import Foundation

enum EnumPhotographers: String {
    case alfredoliverani
    case dersascha
    case photographybytosh

    var displayName: String {
        switch self {
        case .alfredoliverani:
            return "Alfredo Liverani"
        case .dersascha:
            return "Sascha Gebhardt"
        case .photographybytosh:
            return "Martin Tosh"
        }
    }

    var imageURL: URL {
        switch self {
        case .alfredoliverani:
            return URL(string: "https://farm4.staticflickr.com/3796/buddyicons/41569704@N00_l.jpg")!
        case .dersascha:
            return URL(string: "https://farm6.staticflickr.com/5489/buddyicons/26383637@N06_r.jpg")!
        case .photographybytosh:
            return URL(string: "https://farm9.staticflickr.com/8756/buddyicons/125551752@N05_r.jpg")!
        }
    }
}
