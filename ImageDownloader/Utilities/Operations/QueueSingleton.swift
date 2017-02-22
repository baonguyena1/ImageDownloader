//
//  QueueSingleton.swift
//  ImageDownloader
//
//  Created by Bao Nguyen on 2/22/17.
//  Copyright © 2017 Bao Nguyen. All rights reserved.
//

import Foundation

struct Stack<Element> {
    fileprivate var array: [Element] = []
    
    mutating func push(_ element: Element) {
        array.append(element)
    }
    
    mutating func pop() -> Element? {
        return array.popLast()
    }
    
    func peek() -> Element? {
        return array.last
    }
}

public struct Queue<T> {
    
    fileprivate var list: [T] = []
    
    public var isEmpty: Bool {
        return list.isEmpty
    }
    
    public mutating func enqueue(_ element: T) {
        list.append(element)
    }
    
    public mutating func dequeue() -> T? {
        guard !list.isEmpty, let element = list.first else { return nil }
        
        list.remove(at: 0)
        
        return element
    }
}

class QueueSingleton {
    static let singleton: DispatchQueue = {
        return DispatchQueue(label: "download queue", attributes: [])
    }()
    
    static let queueStack: Stack<Photo> = {
       return Stack<Photo>()
    }()
    
    static var maxConcurrentOperationCount = 1
    static var currentConcurentOperation = 0
    
    func addJob() {
        if (QueueSingleton.currentConcurentOperation >= QueueSingleton.maxConcurrentOperationCount) { // Queue is full
            return
        }
        
    }
}
