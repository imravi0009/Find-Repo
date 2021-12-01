//
//  NetworkClient.swift
//  Find Repo
//
//  Created by Ravi Kumar on 30/11/21.
//

import Foundation

enum NetworkError: Error {
    case notModified
    case unprocessableEntity
    case serviceUnavailable
    case other
}

class NetworkClient {
    var task: URLSessionTask!
    
    func makeSearchRequestFor(text: String, handler:@escaping (RepositoryResponse? ,NetworkError?)-> Void) {
        guard let escapedString = text.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: "https://api.github.com/search/repositories?q=\(escapedString)&per_page=50") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        if task != nil {
            task.cancel()
        }
         task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
            do {
                
                if error != nil {
                    handler(nil, NetworkError.other)
                    return
                }
                if response?.httpStatusCode == 200 {
                    guard let data = data else {
                        handler(nil,NetworkError.other)
                        return
                    }
                    let repositryResponse = try? JSONDecoder().decode(RepositoryResponse.self, from: data)
                    handler(repositryResponse,nil)
                }
                else if response?.httpStatusCode == 304  {
                    handler(nil, NetworkError.notModified)
                }
                else if response?.httpStatusCode == 422 {
                    handler(nil, NetworkError.unprocessableEntity)
                }
                else if response?.httpStatusCode == 503 {
                    handler(nil, NetworkError.serviceUnavailable)
                }
                else {
                    handler(nil, NetworkError.other)
                }
            }
        })
        task.resume()
    }
}


extension NetworkError: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notModified:
            return "The specified item could not be found."
        case .unprocessableEntity:
            return "The specified item could not be found."
        case .serviceUnavailable:
            return "The specified Service not available at the moment."
        case .other:
            return "An unexpected error occurred."
        }
    }
}

public extension URLResponse {
    var httpStatusCode: Int {
        guard let statusCode = (self as? HTTPURLResponse)?.statusCode else {
            return 0
        }
        return statusCode
    }
}
