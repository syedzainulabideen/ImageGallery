//
//  ImageDetailView.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 18/03/2021.
//

import SwiftUI

struct GalleryImageDetailView: View {
    var image:Image
    var body: some View {
        image.resizable()
            .aspectRatio(contentMode: .fill)
    }
}
