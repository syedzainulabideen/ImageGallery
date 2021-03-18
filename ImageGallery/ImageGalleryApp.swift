//
//  ImageGalleryApp.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import SwiftUI

@main
struct ImageGalleryApp: App {
    @ObservedObject var galleryViewModel = ImageGalleryViewModel()
    var body: some Scene {
        WindowGroup {
            GalleryListingView(galleryViewModel: self.galleryViewModel)
        }
    }
}
