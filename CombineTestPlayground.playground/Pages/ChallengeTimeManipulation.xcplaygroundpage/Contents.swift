import Combine
import UIKit

/**
 Challenge - Timing
 - A subject emits integers
 - A function call that feeds the subject with mysterious data
 - Group Data by batches of 0.5 seconds
 - Turn the grouped data into a string
 - If there is a pause longer than 0.9 senconds in the feed, print the 👀 emoji. Hints: Create a second publihser for this step and merge it with the first publisher in your subscription.
 - Print it.
 */

/**
 👉🏻 깨달은 점:
 모든 걸 한번에 넣을 필요는 없다.
 즉 지금까지는, 코드로 넘어가게 되면 어쨋거나 ARC 관리를 위해서 모두 그냥 disposeBag 에 넣는 개념으로 생각하고 있었는데, subscribe 를 진행하지 않으면서 (여기서는 sink, assign), complete 을 하는 걸 기준으로 생각하니깐 조금 더 상세하게 생각할 수 있다. 좋다!
 */

struct TapModel {
    let timeInterval: TimeInterval
    let intervalData: Int
}

var cancellable = Set<AnyCancellable>()
let samplesData: [TapModel] = [
    (0.05, 67), (0.10, 111), (0.15, 109),
    (0.20, 98), (0.25, 105), (0.30, 110),
    (0.35, 101), (1.50, 105), (1.55, 115),
    (2.60, 99), (2.65, 111), (2.70, 111),
    (2.75, 108), (2.80, 33)
].map(TapModel.init)

let subject = PassthroughSubject<Int, Never>()

/// Publihser
let strings = subject
    .collect(.byTime(DispatchQueue.main, .seconds(0.5)))
    .map { array in
        String(array.map({ Character(Unicode.Scalar($0) ?? "_") }))
    }

/// Publisher
let spaces = subject
    .measureInterval(using: DispatchQueue.main)
    .map { interval in
        interval > 0.9 ? "👀": ""
    }

let subscription = strings
    .merge(with: spaces)
    .filter { !$0.isEmpty }
    .sink {
        print($0)
    }
    
func startFeeding<T>(subject: T) where T: Subject, T.Output == Int {
    var lastDelay: TimeInterval = 0
    for time in samplesData {
        lastDelay = time.timeInterval
        DispatchQueue.main.asyncAfter(deadline: .now()+time.timeInterval) {
            subject.send(time.intervalData)
        }
    }
    DispatchQueue.main.asyncAfter(deadline: .now()+lastDelay+0.5) {
        subject.send(completion: .finished)
    }
}

startFeeding(subject: subject)
