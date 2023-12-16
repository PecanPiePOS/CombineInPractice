import Combine
import Foundation
import PlaygroundSupport

// MARK: - Setting API Struct
print("------API START------")

public struct API {
    
    var maxStories = 10
    
    private let decoder = JSONDecoder()
    private var apiQueue: DispatchQueue
    
    enum Error: LocalizedError {
        case addressUnreachable(URL)
        case invalidResponse
        
        var errorDescription: String? {
            switch self {
            case .addressUnreachable(let url):
                return "Invalid URL: -- original url: \(url)"
            case .invalidResponse:
                return "Invalid responses from the server."
            }
        }
    }
    
    enum EndPoint {
        static let baseURL: URL = URL(string: "https://hacker-news.firebaseio.com/v0/")!
        
        case stories
        case story(Int)
        
        var url: URL {
            switch self {
            case .stories:
                return EndPoint.baseURL.appending(path: "newstories.json")
            case .story(let id):
                return EndPoint.baseURL.appending(path: "item/\(id).json")
            }
        }
    }
    
    init(queueLabel: String = "API", defaultMaximumStories maxStories: Int = 10, at queue: DispatchQueue.Attributes = .concurrent, with qos: DispatchQoS = .default) {
        self.maxStories = maxStories
        self.apiQueue = DispatchQueue(label: queueLabel, qos: .default, attributes: queue)
    }
}

extension API {
    
    func story(id: Int) -> AnyPublisher<Story, Error> {
        URLSession.shared.dataTaskPublisher(for: EndPoint.story(id).url)
            .receive(on: apiQueue)
            .map(\.data)
            .decode(type: Story.self, decoder: decoder)
            .catch { _ in
                Empty<Story, Error>()
            }
            .eraseToAnyPublisher()
    }
    
    func mergedStories(ids storyIDs: [Int]) -> AnyPublisher<Story, Error> {
        let storyIDs = Array(storyIDs.prefix(maxStories))
        precondition(!storyIDs.isEmpty)
        
        let initialPublisher = story(id: storyIDs[0])
        let remainder = Array(storyIDs.dropFirst())
        
        return remainder.reduce(initialPublisher) { combined, id in
            return combined
                .merge(with: story(id: id))
                .eraseToAnyPublisher()
        }
    }
    
    func stories() -> AnyPublisher<[Story], Error> {
        URLSession.shared
            .dataTaskPublisher(for: EndPoint.stories.url)
            .map(\.data)
            .decode(type: [Int].self, decoder: decoder)
            .mapError { error -> API.Error in
                switch error {
                case is URLError:
                    return Error.addressUnreachable(EndPoint.stories.url)
                default:
                    return Error.invalidResponse
                }
            }
            .filter { !$0.isEmpty }
            .flatMap { storyIDs in
                return self.mergedStories(ids: storyIDs)
            }
            .scan([]) { stories, story -> [Story] in
                return stories + [story]
            }
            .map { $0.sorted() }
            .eraseToAnyPublisher()
    }
}

// MARK: - Executing

let api = API()
var subscriptions = Set<AnyCancellable>()

api.stories()
    .sink {
        print("✅ Completed: \($0)")
    } receiveValue: {
        print("---- Received some news: \n\($0)")
    }
    /// Why the API Call doesn't work when it isn't stored in AnyCancellables?
    /// Shouldn't it just work?
    .store(in: &subscriptions)

PlaygroundPage.current.needsIndefiniteExecution = true
