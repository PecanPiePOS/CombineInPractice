import Combine
import Foundation

let numbersToShare = [1,2,3,4,5,6,7,8,9,10]


/// struct - Publishers.Sequence
let publisher = numbersToShare.publisher


/// class - Publishers.Share
/// => Publishers.Multicast 와 PassthroughSubject 의 Combination 으로 만들어진 Publisher 이다.
/// 내부를 살펴보면...
 
/**
 
1. share()
 public func share() -> Publishers.Share<Self>
 
2. Publishers.Share
 final public class Share<Upstream> : Publisher, Equatable where Upstream : Publisher { ... }
 
 */
let sharingPublihser = numbersToShare.publisher.share()


/**
 
 - "Future" is One another way to share the result of a computation.
 - "Futrue" is Class. Combine-Future.
 */

func performSomeWork() throws -> Int {
    print("----- Doing some works:")
    return (1...5).randomElement()!
}

/// fullfill is the closure "Promise"
let future = Future<Int, Error> { fullfill in
    do {
        let result = try performSomeWork()
        fullfill(.success(result))
    } catch let error {
        fullfill(.failure(error))
    }
}
    .print("#Future: Publihser")

print("----- Subscribing to Future Instance...")

let subscription1 = future
    .print("#1: ")
    .sink { _ in
        print("Subscription1 is Completed")
    } receiveValue: {
        print("Subscription1 received: \($0)")
    }

let subscription2 = future
    .print("#2: ")
    .sink { _ in
        print("Subscription2 is Completed")
    } receiveValue: {
        print("Subscription2 received: \($0)")
    }

