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


func basicOfGettingDataFrom(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    let subscription = URLSession.shared.dataTaskPublisher(for: url)
        .sink { completion in
            if case .failure(let error) = completion {
                print("Retrieving data failed with error: \(error)")
            }
        } receiveValue: { data, response in
            print("Data size: \(data.count), response of = \(response)")
        }
}

