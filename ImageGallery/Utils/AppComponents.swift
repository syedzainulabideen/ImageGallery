//
//  AppUtils.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import SwiftUI

struct AppComponents {
    
    struct Strings {
        static let searchPlaceHolder:String = "Search here"
        static let keyAPI = "563492ad6f91700001000001ede55d41d1a74ae4a1ba88d541831b71"
    }
   
    struct Images {
        static let searchMagnifierIcon:Image = Image(systemName: "magnifyingglass")
        static let xmarkIcon:Image = Image(systemName: "xmark")
    }
    
    struct URLs {
        static let baseURL:String = "https://api.pexels.com"
    }
}


public struct ActivityIndicator: UIViewRepresentable {
    public init() {
        
    }
    public typealias UIView = UIActivityIndicatorView
    var isAnimating: Bool = true
    fileprivate var configuration = { (indicator: UIView) in }

    public func makeUIView(context: UIViewRepresentableContext<Self>) -> UIView { UIView() }
    public func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<Self>) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
        configuration(uiView)
    }
}
