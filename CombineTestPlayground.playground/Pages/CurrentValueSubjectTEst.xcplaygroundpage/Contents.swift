import Foundation
import Combine

let currentSubject = CurrentValueSubject<[Int], Never>([0])

print("First:", currentSubject.value)

currentSubject.send([4])

print("Second:", currentSubject.value)

currentSubject.value.append(5)

print("Third:", currentSubject.value)
