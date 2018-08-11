//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Анастасия Латыш on 06/08/2018.
//  Copyright © 2018 Fabric. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {

   
    @IBOutlet weak var tweetImage: UIImageView!
    // MARK: - Public API
    var imageUrl: URL? {
        didSet {updateUI()}
    }
    
    private func updateUI() {
        if let url = imageUrl {
            
            DispatchQueue.global(qos: .userInitiated).async {
                
                let contentsOfURL = try? Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    if url == self.imageUrl {
                        if let imageData = contentsOfURL {
                            
                            self.tweetImage?.image = UIImage(data: imageData)
                        }
                    }
                }
            }
        }
    }
    
}
