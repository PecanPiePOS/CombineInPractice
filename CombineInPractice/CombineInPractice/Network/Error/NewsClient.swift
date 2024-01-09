//
//  NewsClient.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 1/6/24.
//

import Foundation

import ComposableArchitecture

struct NewsClient {
    var fetch: (Int) async throws -> String
}

/**
 값을 2개를 가져올떄는 어떻게 해야하지?
 - liveValue 안에서 모두 처리하거나 아니면 따로 매번 처리해야하나?
 */
extension NewsClient: DependencyKey {
    
    static let liveValue = Self (
        fetch: { id in
            let (data, _) = try await URLSession.shared
                .data(from: NetworkEndpoint.story(id).url)
            return String(decoding: data, as: UTF8.self)
        }
    )
}

extension DependencyValues {
    var singleStoryData: NewsClient {
        get {
            self[NewsClient.self]
        }
        set {
            
        }
    }
}
