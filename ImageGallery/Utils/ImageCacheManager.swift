//
//  ImageCacheManager.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import UIKit

class ImageCacheManager: NSObject, NSCacheDelegate {
    static let shared = ImageCacheManager()
    var imageCache = NSCache<NSString, NSData>()
    
    private override init() { }
    
    func addImage(for urlValue:String, image:NSData) {
        imageCache.setObject(image, forKey:NSString(string: urlValue))
    }
    
    func getCachedImage(for urlValue:String) -> NSData? {
        return imageCache.object(forKey: NSString(string: urlValue))
    }
    
    func clearupCache() {
        imageCache.removeAllObjects()
    }
    
}
