import Combine
import Foundation

/**
 Let's fetch a method getting data from a URL.
 Then try handleEvents()
 */

let urlString: String = "https://cat-fact.herokuapp.com/facts/random?animal_type=cat&amount=10"
let url = URL(string: urlString)!
var subscriptions = Set<AnyCancellable>()


func gettingDataWithOutHandlingEffects() {
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Retrieving data failed with error: \(error)")
            }
        } receiveValue: { data, response in
            print("Data size: \(data.count), response of = \(response)")
        }
        .store(in: &subscriptions)
}

func gettingDataWithHandlingEffects() {
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .print("publisher")
        .handleEvents(receiveSubscription: { _ in
            print("------Network request will start------")
        }, receiveOutput: { _ in
            print("------Network data of response received------")
        }, receiveCancel: {
            print("------Network request cancelled------")
        })
        .sink { completion in
            if case .failure(let error) = completion {
                print("Retrieving data failed with error: \(error)")
            }
        } receiveValue: { data, response in
            print("Data size: \(data.count), response of = \(response)")
        }
}

func gettingDataWithBreakpoint() {
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .breakpoint(receiveOutput: { result in
            return result.data.count > 300
        })
        .sink { completion in
            if case .failure(let error) = completion {
                print("Retrieving data failed with error: \(error)")
            }
        } receiveValue: { data, response in
            print("Data size: \(data.count), response of = \(response)")
        }
}

gettingDataWithBreakpoint()









public class TimeLogger: TextOutputStream {
    
    private var previous = Date()
    private let formatter = NumberFormatter()
    
    public init() {
        formatter.maximumFractionDigits = 5
        formatter.minimumFractionDigits = 5
    }
    
    public func write(_ string: String) {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        let now = Date()
        print("+\(formatter.string(for: now.timeIntervalSince(previous))!)s: \(string)")
        previous = now
    }
}
