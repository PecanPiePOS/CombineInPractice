//
//  ThreadCheckView.swift
//  CombineInPractice
//
//  Created by KYUBO A. SHIM on 1/3/24.
//

import Combine
import SwiftUI

struct ThreadCheckView: View {
    
    @State var number: Int = 0
    private let generator = RandomNumberGenerator()
    
    var body: some View {
        VStack {
            Button("Generate") {
                generator.generateNewNumber()
            }
            .padding()
            
            Text("\(number)")
                .onReceive(generator.subject, perform: { data in
                    number = data
                })
            
            Button("Complete") {
                generator.completeGenerator()
            }
            
            Button("CancelTest") {
                cancelSomeCancellable()
            }
            .padding()
        }
    }
    
    func cancelSomeCancellable() {
        let someCancellable = [20].publisher
            .handleEvents(receiveRequest:  { _ in
                print("Received Cancel - \(Thread.current)")
            })
            .delay(for: 50, scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.global())
            .sink { someValue in
                print("Value: \(someValue)")
            }
        
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            someCancellable.cancel()
        }
    }
}

final class RandomNumberGenerator {
    
    private var subscriptions = Set<AnyCancellable>()
    private let subscriber: AnySubscriber<Int, Never>
    let subject = CurrentValueSubject<Int, Never>(11)
//    let subject = PassthroughSubject<Int, Never>()
        
    init() {
        subscriber = AnySubscriber(receiveSubscription: { subscription in
            print("------------------------\n📬 Subscription has been received. - Thread of \(Thread.current)")
            subscription.request(.unlimited)
        }, receiveValue: { value in
            print("☀️ \(value) has been received. - Thread of \(Thread.current)")
            return .none
        }, receiveCompletion: { _ in
            print("🖌️ Completed - Thread of \(Thread.current)\n-------------")
        })
        
        subject
            .handleEvents(receiveSubscription: { _ in
                print("-: Received Subscription - Thread of \(Thread.current)")
            }, receiveOutput: { _ in
                print("-:: Received Output - Thread of \(Thread.current)")
            }, receiveCompletion: { _ in
                print("-::: Received Completion - Thread of \(Thread.current)")
            }, receiveCancel: {
                print("-:::: Cancelled - Thread of \(Thread.current)")
            }, receiveRequest: { _ in
                print("-::::: Received Request - Thread of \(Thread.current)")
            })
            .receive(on: DispatchQueue.global())
            .subscribe(subscriber)
    }
    
    func generateNewNumber() {
        print("\n\(#function) called. Thread of \(Thread.current)")
        subject.send(Int.random(in: -10...10))
    }
    
    func completeGenerator() {
        print("\n\(#function) called. Thread of \(Thread.current)")
        subject.send(completion: .finished)
    }
}

#Preview {
    ThreadCheckView()
}
