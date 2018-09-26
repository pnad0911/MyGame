//
//  Queues.swift
//  MyGame
//
//  Created by Duy Pham on 9/25/18.
//  Copyright © 2018 Duy Pham. All rights reserved.
//

import Foundation
import SpriteKit

struct Queue {
    
    var items:[CGPoint] = []

    mutating func enqueue(element: CGPoint)
    {
        items.append(element)
    }
    
    mutating func dequeue()
    {
        if !items.isEmpty {
            items.remove(at: 0)
        } else {
            print("Error info: Removing an empty queue")
        }
    }
    mutating func peek() -> CGPoint? {
        if !items.isEmpty {
            return items.first
        }
        else{
            return nil
        }
    }
    
    mutating func isEmpty() -> Bool? {
        return items.isEmpty
    }
    
    mutating func array() -> [CGPoint] {
        return items
    }
    
    mutating func update() {
        for var i in items {
            i.y -= 0.2
        }
    }
}
