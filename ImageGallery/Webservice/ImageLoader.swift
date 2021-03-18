//
//  ImageLoader.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 18/03/2021.
//

import Foundation
import SwiftUI
import Combine

typealias ImageLoadingCompletionHandler = ((Data?) -> (Void))

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    @State var loading:Bool = false
    
    var data = Data() {
        didSet {
            loading = false
            didChange.send(data)
        }
    }
    
    func loadURL(urlString:String, completionHandler: ImageLoadingCompletionHandler?) {
        guard let url = URL(string: urlString) else {
            completionHandler?(nil)
            return
        }
        loading = true
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completionHandler?(nil)
                return
            }
            DispatchQueue.main.async {
                self.data = data
                ImageCacheManager.shared.addImage(for: urlString, image: NSData(data: self.data))
                completionHandler?(data)
            }
        }
        task.resume()
    }
}

