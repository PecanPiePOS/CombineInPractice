//
//  NetworkEndpoint.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 1/6/24.
//

import Combine
import Foundation

enum NetworkEndpoint {
    
    static let baseURL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
    
    case stories
    case story(Int)
    
    var url: URL {
        switch self {
        case .stories:
            return NetworkEndpoint.baseURL.appending(path: "newstories.json")
        case .story(let id):
            return NetworkEndpoint.baseURL.appending(path: "item/\(id).json")
        }
    }
}
