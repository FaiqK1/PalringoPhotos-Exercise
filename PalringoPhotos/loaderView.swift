//
//  loaderView.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 18/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

func loadingCenter(forView view: UIView, count: Int = 0) -> CGPoint {
    var y: CGFloat = 0
    count > 0 ? (y = (view.bounds.maxY) - 60) : (y = (view.bounds.maxY))
    return CGPoint(x: (view.bounds.midX ?? 0), y: y)
}
