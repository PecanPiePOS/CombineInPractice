import Combine
import Foundation


/// TimeLogger 같이 TextOutputStream 를 채택하여 custom 으로 만들어보자!
let subscription = (1...10).publisher
    .print("publisher", to: TimeLogger())
    .sink { _ in }

/*
 PRINT -> 
 +0.00214s: publisher: receive subscription: (1...10)
 +0.00013s: publisher: request unlimited
 +0.00002s: publisher: receive value: (1)
 +0.00001s: publisher: receive value: (2)
 +0.00000s: publisher: receive value: (3)
 +0.00001s: publisher: receive value: (4)
 +0.00000s: publisher: receive value: (5)
 +0.00000s: publisher: receive value: (6)
 +0.00000s: publisher: receive value: (7)
 +0.00000s: publisher: receive value: (8)
 +0.00000s: publisher: receive value: (9)
 +0.00001s: publisher: receive value: (10)
 +0.00001s: publisher: receive finished
 */
