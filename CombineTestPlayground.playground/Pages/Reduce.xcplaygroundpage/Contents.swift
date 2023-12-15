import Foundation
import Combine

var cancellable = Set<AnyCancellable>()
let publisher = ["Hello", " world", " but it'", "s", " quite ", "cold", " ", "world"].publisher

publisher
    .reduce("", +)
    .sink(receiveCompletion: {
        print("Completed:", $0)
    }, receiveValue: {
        print("I hope the results printed only once.", $0)
    })
    .store(in: &cancellable)

let submissivePublisher = PassthroughSubject<String, Never>()

submissivePublisher
    .scan("", { return $0 + $1})
    .sink (receiveCompletion: {
        print("Completed with:", $0)
    }){
        print("->", $0)
    }

submissivePublisher.send("q")
submissivePublisher.send("we")
submissivePublisher.send("rty")
submissivePublisher.send("uiop")
submissivePublisher.send("123")
submissivePublisher.send("45")
submissivePublisher.send(completion: .finished)

