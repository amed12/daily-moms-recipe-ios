//
//  BaseEndPoint.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 26/04/22.
//

import UIKit

public enum HomeEndpoint {
    case home
}

extension HomeEndpoint {
    
    public var baseURL: URL {
        // swiftlint:disable force_unwrapping
        return URL(string: Constants.Network.baseUrlPath)!
        // swiftlint:enable force_unwrapping
    }
    
    public var path: String {
        switch self {
        case .home:
            return Constants.Network.searchPath
        }
    }
    
    public var method: String {
        return "GET"
    }
    public var headers: [String: String]? {
        return nil
    }
}
