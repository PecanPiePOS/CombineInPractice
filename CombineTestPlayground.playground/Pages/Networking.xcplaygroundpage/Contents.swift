import Foundation
import Combine

/**
 - URLSession
 - Json Data with Codable
 */

/**
 URLSession 에는 다음과 같은 것들이 있다.
 
 1. Data transfer tasks - Content of URL
 2. Download tasks - Content of URL and save it to a file
 3. Upload tasks - Upload 'files and data' to a URL
 4. Stream tasks - Stream data between two parties
 5. Websocket tasks - Connect to websockets
 
이 중, Data transfer tasks 만 Combine 메서드가 있다.
 
 */

/**
 Subscriber 의 내부 enum "Completion" 에는 2 개의 케이스가 있다.
 1. .finished
 2. .failure(Error)
 
 */

struct MyModel: Codable {
    let id: Int
    let contents: [String]
}

let urlString: String = "https://cat-fact.herokuapp.com/facts/random"
let url = URL(string: urlString)!
var subscriptions = Set<AnyCancellable>()

func basicOfGettingDataFrom() {
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Retrieving data failed with error: \(error)")
            }
        } receiveValue: { data, response in
            print("Data size: \(data.count), response of = \(response)")
        }
}

func tryDecodingAddedMethod() {
    /// 매번 JSONDecoder 인스턴스를 생성한다.
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .tryMap { data, _ in
            try JSONDecoder().decode(MyModel.self, from: data)
        }
        .sink { completion in
            if case .failure(let error) = completion {
                print("Error occured: \(error)")
            }
        } receiveValue: { result in
            print("Retrieved data: \(result)")
        }
}

func reducedAPIGetMethod() {
    /// "map - decode" 를 사용하면, response 는 사용하지 못하는건가?? -> 그렇다.
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .decode(type: MyModel.self, decoder: JSONDecoder())
        .sink { completion in
            if case .failure(let error) = completion {
                print("Error occured: \(error)")
            }
        } receiveValue: { result in
            print("Shorten Method is used and the result is: \(result)")
        }
}

    /**
     ⭐️ .multicast 는 "ConnectablePublisher" Protocol 을 채택하는 Publisher 로 .connect() 메서드를 사용해야만, publish 가 시작된다.!
     */
func multicastedAPIGetMethod() {
    /// .multicast 는 해당 publisher 에 subscriber 가 붙으면 새로운 Subject 를 만든다.
    let multiPublisher = URLSession.shared.dataTaskPublisher(for: url)
        .map(\.data)
        .multicast { PassthroughSubject<Data, URLError>() }
    
    let subsription1 = multiPublisher
        .sink { completion in
            if case .failure(let error) = completion {
                print("From subs1, error occured: \(error)")
            }
        } receiveValue: { result in
            print("Result for 1 is: \(result)")
        }
    
    let subscription2 = multiPublisher
        .sink { completion in
            if case .failure(let error) = completion {
                print("From subs1, error occured: \(error)")
            }
        } receiveValue: { result in
            print("Result for 2 is: \(result)")
        }
    
    /// 그러면 여기는 우선 두개를 이어놓은 다음에 connect 를 시작한건가?
    /// 책의 설명을 봐보자.
    /// 그렇다. subscribe 를 해놓는다고 바로 통신 시작이 되지 않는 것을 보여줬다.
    let subscription = multiPublisher.connect()
}

multicastedAPIGetMethod()
