//
//  Storage.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 12/17/23.
//

import Combine
import Foundation

struct CombineManager {
    let sharingPublisher = [1,2,3].publisher.share()
    let fff = Future<Int, Never> { promise in
        print("")
    }
}
