//
//  SearchBarView.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var searchText:String
    @Binding var isLoading:Bool
        
    var body: some View {
        ZStack {
            HStack {
                HStack(spacing: 10) {
                    AppComponents.Images.searchMagnifierIcon
                    
                    TextField(AppComponents.Strings.searchPlaceHolder, text: self.$searchText)
                    
                    if self.searchText.count > 0 {
                        if isLoading {
                            ActivityIndicator()
                        }
                        else {
                            AppComponents.Images.xmarkIcon.resizable().frame(width: 12, height: 12, alignment: .center).padding(.trailing, 10).onTapGesture {
                                self.searchText = ""
                            }
                        }
                    }
                }
                .padding(.horizontal, 15)
                .frame(height:50)
                .background(
                    RoundedRectangle(cornerRadius: 16).fill(ThemeManager.shared.currentTheme.componentBgColor)
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

