//
//  Extensions.swift
//  Chat app
//
//  Created by Jane Hsieh on 1/23/17.
//  Copyright © 2017 Shooting Stars. All rights reserved.
//


import UIKit

let imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    
    func loadImageUsingCache(urlString: String) {
        
        self.image = nil
        
        // check cache for image first
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            self.image = cachedImage
            return
        }
        
        
        // otherwise fire off a new download
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            if error != nil {
                print (error!)
                return
            }
            DispatchQueue.main.async( execute: {
                
                if let downloadedImage = UIImage(data: data!) {
                
                imageCache.setObject(downloadedImage, forKey: urlString as NSString)
                
                self.image = downloadedImage
                }
                    
                    
            })
            
        }).resume()
    }
    
}
