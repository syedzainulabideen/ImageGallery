//
//  RequestBuilder.swift
//  ImageGallery
//
//  Created by Syed Zain ul Abideen on 17/03/2021.
//

import Foundation
import UIKit

enum SearchType:String {
    case image = "/v1/search"
    case video = "/videos/search"
    case curated = "/v1/curated"
}

enum HttpMethod:String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum RequestBuilderError: Error {
    case unableToGenerateURL
}

class RequestBuilder {
    
    var searchType:SearchType = .image
    var httpMethod:HttpMethod = .get
    var queryParam:[String:String]?
    var authroizationValue:String?
    
    func withType(_ searchType:SearchType) -> RequestBuilder {
        self.searchType = searchType
        return self
    }
    
    func httpMethod(_ httpMethod:HttpMethod) -> RequestBuilder {
        self.httpMethod = httpMethod
        return self
    }
    
    func queryParam(_ queryParam:[String:String]) -> RequestBuilder {
        self.queryParam = queryParam
        return self
    }
    
    func authroizationValue(_ stringAuth:String) -> RequestBuilder {
        self.authroizationValue = stringAuth
        return self
    }
    
    func build() -> (request:URLRequest? , requestError:RequestBuilderError?) {
        var baseURLString = "\(AppComponents.URLs.baseURL)\(self.searchType.rawValue)"
        
        if let validQueryParam = self.queryParam, validQueryParam.count > 0 {
            var params: [String] = []
            validQueryParam.forEach { (key: String, value: String) in
                let param = "\(key)=\(value)"
                params.append(param)
            }
            let queryString = params.joined(separator: "&")
            baseURLString.append("?\(queryString)")
        }
        
        guard let baseURL = URL(string: baseURLString) else {
            return (nil, .unableToGenerateURL)
        }
        
        var reqest = URLRequest(url: baseURL)
        reqest.httpMethod = self.httpMethod.rawValue
        
        if let validAuthorization = self.authroizationValue {
            reqest.addValue(validAuthorization, forHTTPHeaderField: "Authorization")
        }
        
        return (reqest, nil)
    }
}
