//
//  BaseFactory.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 26/04/22.
//


import Foundation

extension HomeEndpoint {
    public func makeURL() -> URL {
        let urlString = baseURL.absoluteString + path
        guard let url = URL(string: urlString) else {
            fatalError("Failed to create URL for endpoint: \(urlString)")
        }
        return url
    }
    
    public func makeURLRequest() -> URLRequest {
        let url = makeURL()
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers
        return request
    }
}
