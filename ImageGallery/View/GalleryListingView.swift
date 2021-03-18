//
//  ContentView.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import SwiftUI
import Combine
import UIKit

struct GalleryListingView: View {
    @ObservedObject var galleryViewModel:ImageGalleryViewModel
    
    var values:[[Presentable]] {
        return self.galleryViewModel.currentLoadedImages.chunked(into: 2)
    }
    
    var body: some View {
        VStack {
            SearchBarView(searchText: self.$galleryViewModel.searchString, isLoading: self.$galleryViewModel.isloading)
            .onReceive(
                galleryViewModel.$searchString.debounce(for: .seconds(1), scheduler: DispatchQueue.main)
            )
            {
                guard !$0.isEmpty else {
                    return
                }
                self.galleryViewModel.clearUpSearch()
                self.galleryViewModel.isloading = true
                self.galleryViewModel.getPhotoForCurrentPage()
            }
            
            List {
                ForEach(self.values.indices, id:\.self) { idx in
                    HStack(alignment:.center) {
                        ForEach(self.values[idx].indices, id:\.self) { index in
                            let value = self.values[idx][index]
                            PhotoView(with: value, isVertical: (idx % 2 == 0 && idx != 0)).onAppear {
                                if self.galleryViewModel.currentLoadedImages.last?.uniqueIdentifier == value.uniqueIdentifier {
                                    self.galleryViewModel.getPhotoForCurrentPage()
                                }
                            }
                        }
                    }
                }
            }
            .frame(width:UIScreen.main.bounds.width)
            
            Spacer()
        }
        .onAppear {
            self.galleryViewModel.getPhotoForCurrentPage()
        }
    }
}
