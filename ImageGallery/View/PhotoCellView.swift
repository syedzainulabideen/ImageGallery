//
//  PhotoCellView.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import SwiftUI
import Combine

struct PhotoView: View {
    var currentPhoto:Presentable
    
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()
    @State var loading:Bool = false
    @State private var scaleValue = CGFloat(1)
    @State var showImageDetail:Bool = false

    var isVertical:Bool = false
    var currentURL:String {
        return self.currentPhoto.urltoPresent
    }

    init(with currentPhoto:Presentable, isVertical:Bool) {
        self.currentPhoto = currentPhoto
        self.imageLoader = ImageLoader()
        self.isVertical = isVertical
    }
    
    var body: some View {
        ZStack {
            if self.imageLoader.loading  {
                ActivityIndicator()
            }
            Image(uiImage: image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .onReceive(imageLoader.didChange) { data in
                    guard let image = UIImage(data: data) else {
                        return
                    }
                    self.image =  image
                }
                .onTapGesture {
                    withAnimation(.default) {
                        self.showImageDetail = true
                    }
                }
        }
        .sheet(isPresented: self.$showImageDetail) {
            GalleryImageDetailView(image: Image(uiImage: image))
        }
        .onAppear {
            if let validImageinCacheData = ImageCacheManager.shared.getCachedImage(for: currentURL), let validImageinCache = UIImage(data: validImageinCacheData as Data) {
                self.image = validImageinCache
            }
            else {
                self.imageLoader.loadURL(urlString: currentURL, completionHandler: nil)
            }
        }
        .frame(width:UIScreen.main.bounds.width/2.2, height: isVertical ? 300 : 200)
        .clipped()
        .background(
            RoundedRectangle(cornerRadius: 16).fill(ThemeManager.shared.currentTheme.componentBgColor)
        )
        .cornerRadius(16)
    }
}

