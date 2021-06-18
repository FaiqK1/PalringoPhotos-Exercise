//
//  ImageBarButton.swift
//  PalringoPhotos
//
//  Created by Faiq Khan on 18/06/2021.
//  Copyright © 2021 Palringo. All rights reserved.
//

import UIKit

class ImageBarButton : UIView {
    var button: UIButton!
    var imageView: UIImageView!

    convenience init(withImage image: UIImage? = nil, frame: CGRect = CGRect(x: 0, y: 0, width: 40, height: 40), padding: CGFloat = 4) {
        
        //Set up image frame
        self.init(frame: frame)
        
        //Apply padding so image sits better on NavBar
        let paddedFrame              = CGRect(x: frame.origin.x - padding, y: frame.origin.y - padding, width: frame.width - padding, height: frame.height - padding)
        imageView                    = UIImageView(frame: paddedFrame)
        imageView.backgroundColor    = .white
        imageView.layer.cornerRadius = paddedFrame.height/2
        imageView.clipsToBounds      = true
        imageView.contentMode        = .scaleAspectFill
        imageView.clipsToBounds      = true
        addSubview(imageView)

        //Clear button on top
        button = UIButton(frame: frame)
        button.backgroundColor = .clear
        button.setTitle("", for: .normal)
        addSubview(button)

        //Set Image
        if let image = image {
            self.imageView.image = image
        }
        
    }

    func barButtonItem()-> UIBarButtonItem {
        return UIBarButtonItem(customView: self)
    }
}
