//
//  extUIButton.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 19/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

extension UIButton {
    func preventRepeatedPresses(inNext seconds: Double = 1) { 
        self.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            self.isUserInteractionEnabled = true
        }
    }
}
