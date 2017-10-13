//
//  WPTQueue.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/12/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTQueue<T> {
    
    private var queue = [T]()
    
    func isEmpty() -> Bool {
        return queue.count == 0
    }
    
    func enqueue(_ val: T) {
        queue.append(val)
    }
    
    func dequeue() -> T? {
        if self.isEmpty() {
            return nil
        }
        let result = queue[0]
        queue.remove(at: 0)
        return result
    }
}
