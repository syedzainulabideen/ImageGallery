//
//  ImageGalleryViewModel.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import SwiftUI
import Combine

typealias ImageSearchCompletion = (PexelAPIResponse, NetworkingError) -> (Void)

protocol Presentable {
    var urltoPresent:String { get }
    var uniqueIdentifier:Int? { get }
}

extension Photo:Presentable {
    var uniqueIdentifier: Int? {
        return self.id ?? 0
    }
    
    var urltoPresent: String {
        return self.src?.large ?? ""
    }
}


class ImageGalleryViewModel: ObservableObject {
    static let shared = ImageGalleryViewModel()
    
    @Published var currentLoadedImages:[Photo] = [Photo]()
    @Published var isloading:Bool = false
    @Published var searchString:String = "" {
        didSet {
            if searchString == "" {
                self.clearUpSearch()
            }
        }
    }
    
    var currentPage:Int = 1
    var serviceManager:ServiceManager = ServiceManager<PexelAPIResponse>()
    var loadedPages:[Int] = [Int]()
    
    var responseObject:PexelAPIResponse? {
        didSet {
            if let validResponse = responseObject {
                currentLoadedImages.append(contentsOf: validResponse.photos ?? [])
                self.loadedPages.append(currentPage)
                
                currentPage += 1
            }
        }
    }
    
    func clearUpSearch() {
        self.currentLoadedImages = []
        self.currentPage = 1
        self.responseObject = nil
        self.loadedPages = []
        ImageCacheManager.shared.clearupCache()
    }
    
    func getPhotoForCurrentPage() {
        guard !self.loadedPages.contains(currentPage) else {
            return
        }
        
        print("LOADING PAGE \(currentPage)")
        if let request = RequestBuilder()
            .httpMethod(.get)
            .withType(self.searchString.count > 0 ? .image : .curated)
            .authroizationValue(AppComponents.Strings.keyAPI)
            .queryParam([
                "query":searchString,
                "per_page": "20",
                "page": "\(currentPage)"
            ])
            .build().request {
            
            serviceManager.requestCombine(with: request)
                .sink { (completion) in
                    self.handleServicesError(completion: completion)
                }
                receiveValue: { (value:PexelAPIResponse) in
                    self.isloading = false
                    self.responseObject = value
                }
                .store(in: &serviceManager.cancellables)
            
        }
        else {
            
        }
    }
    
    func handleServicesError(completion: Subscribers.Completion<NetworkingError>) {
        self.isloading = false
        print(completion)
    }
    
}
