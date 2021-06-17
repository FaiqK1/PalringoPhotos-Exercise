//
//  Photographers.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 17/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

//Brought into seperate file
//Also changed the http to https - to avoid slode decode of http
import Foundation

enum Photographers: String {
    case dersascha
    case alfredoliverani
    case photographybytosh

    var displayName: String {
        switch self {
        case .dersascha:
            return "Sascha Gebhardt"
        case .alfredoliverani:
            return "Alfredo Liverani"
        case .photographybytosh:
            return "Martin Tosh"
        }
    }

    var imageURL: URL {
        switch self {
        case .dersascha:
            return URL(string: "https://farm6.staticflickr.com/5489/buddyicons/26383637@N06_r.jpg")!
        case .alfredoliverani:
            return URL(string: "https://farm4.staticflickr.com/3796/buddyicons/41569704@N00_l.jpg")!
        case .photographybytosh:
            return URL(string: "https://farm9.staticflickr.com/8756/buddyicons/125551752@N05_r.jpg")!
        }
    }
}
