import Combine
import UIKit

var cancellable = Set<AnyCancellable>()
let numbers = (1...20).publisher

//numbers
//    .print()
//    .prefix(7)
//    .sink { complete in
//        print("Completed With: \(complete)")
//    } receiveValue: { data in
//        print(data, "⭐️")
//    }
//    .store(in: &cancellable)

//let willBeCancelledSubject = PassthroughSubject<Int, Never>()
//
////numbers.subscribe(willBeCancelledSubject)
//
//let subscription = willBeCancelledSubject
//    .handleEvents(receiveCancel: {
//        print("Cancelled. No way!")
//    })
//    .sink(receiveCompletion: {
//        print("Completed:", $0)
//    }, receiveValue: {
//        print("Is it cancelled?:", $0)
//    })
//
//willBeCancelledSubject.send(4)
//willBeCancelledSubject.send(completion: .finished)
///// Complete 이 된 상태에서는 cancel 이 되지 않는다.
//subscription.cancel()



//numbers
//    .dropFirst(50)
//    .prefix(20)
//    .filter({ $0 % 2 == 0 })
//    .sink(receiveValue: { print($0) })
//    .store(in: &cancellable)



//enum AnyCustomError: Error {
//    case upload
//    case donwload
//    case tokenAccess
//}
//
//final class SomeNetworkPublisher<T>: Publisher {
//    
//    typealias Output = T
//    typealias Failure = AnyCustomError
//    
//    func receive<S>(subscriber: S) where S : Subscriber, AnyCustomError == S.Failure, T == S.Input {
//    }
//}


let newPassthroughSubject = PassthroughSubject<Int, Never>()
let newArray = [1,2,3,4,5,6,nil].publisher

newArray
    .compactMap{ $0 }
    .print()
    .contains(3)
    .sink(receiveCompletion: {
        print("Completed", $0)
    }, receiveValue: {
        print("🚩", $0)
    })


