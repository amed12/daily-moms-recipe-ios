//
//  BaseService.swift
//  DailyMomsRecipe
//
//  Created by Achmad Fathullah on 26/04/22.
//

import Foundation
import Combine

public struct HttpStatusCode {
    public struct Informational {
        static let range = 100..<200
    }
    
    public struct Success {
        static let range = 200..<300
    }
    
    public struct Redirection {
        static let range = 300..<400
    }
    
    public struct ClientError {
        static let range = 400..<500
        static let badRequest = 400
        static let notFoundError = 401
    }
    
    public struct ServerError {
        static let range = 500..<600
    }
}

public protocol HomeService: AnyObject {
    func home() -> AnyPublisher<Data, Error>
//    func home() async throws -> Data?
    func performRequest(urlRequest: URLRequest) -> AnyPublisher<Data, Error>
//    func performRequest(urlRequest: URLRequest) async throws -> Data?
}

public class BaseService: HomeService{
    
    let session: URLSession
        
    public init(session: URLSession = URLSession.shared) {
            self.session = session
        }
    
    public func home() -> AnyPublisher<Data, Error> {
        let endpoint = HomeEndpoint.home
        return performRequest(urlRequest: endpoint.makeURLRequest())
    }

    public func performRequest(urlRequest: URLRequest) -> AnyPublisher<Data, Error> {
        return session.dataTaskPublisher(for: urlRequest)
                   .tryMap { data, response -> Data in
                       guard let httpResponse = response as? HTTPURLResponse else {
                           throw HTTPError
                               .invalidResponse(HttpStatusCode.ClientError.badRequest)
                       }
                       guard (HttpStatusCode.Success.range).contains(httpResponse.statusCode) else {
                           if httpResponse.statusCode == HttpStatusCode.ClientError.notFoundError {
                               throw HTTPError.notFoundResponse
                           } else {
                               throw HTTPError.invalidResponse(httpResponse.statusCode)
                           }
                       }
                       return data
                   }
                   .eraseToAnyPublisher()
    }
    
    
}

public enum HTTPError: Equatable {
    case statusCode(Int)
    case invalidResponse(Int)
    case notFoundResponse
}

extension HTTPError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidResponse(let int):
            let statusCode = String(int)
            return NSLocalizedString("Error: \(statusCode)", comment: statusCode)
        case .notFoundResponse:
            return NSLocalizedString(Constants.Translations.Error.notFound, comment: "401")
        case .statusCode(let int):
            return String(int)
        }
    }
}
