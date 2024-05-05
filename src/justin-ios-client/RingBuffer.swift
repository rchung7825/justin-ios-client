//
//  RingBuffer.swift
//  justin-ios-client
//
//  Created by Raymond Yongsub Chung on 5/5/24.
//

import Foundation

struct RingBuffer<T: Hashable> {
    private var array: [T?]
    private var writeIndex = 0
    
    init(count: Int) {
        array = Array(repeating: nil, count: count)
    }
    
    mutating func append(_ element: T) {
        array[writeIndex] = element
        writeIndex = (writeIndex + 1) % array.count
    }
    
    func isFull() -> Bool {
        return array.allSatisfy { $0 != nil }
    }
    
    func containsUniqueElement() -> Bool {
        let uniqueElements = Set(array.compactMap { $0 })
        return uniqueElements.count == 1
    }
    
    mutating func clear() {
        array = Array(repeating: nil, count: array.count)
        writeIndex = 0
    }
    
    func mostRecentEvent() -> T? {
        guard let lastElement = array[(writeIndex + array.count - 1) % array.count] else {
            return nil
        }
        return lastElement
    }
    
    func eventBeforeMostRecent() -> T? {
        let index = (writeIndex + array.count - 2) % array.count
        guard let element = array[index] else {
            // If buffer is not full, return nil
            return nil
        }
        return element
    }
    
}

