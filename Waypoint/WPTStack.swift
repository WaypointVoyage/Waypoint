//
//  WPTStack.swift
//  Waypoint
//
//  Created by Cameron Taylor on 10/12/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

class WPTStack<T> {
    
    private var head: WPTLLNode? = nil
    
    func isEmpty() -> Bool {
        return head == nil
    }
    
    func push(_ val: T) {
        let node = WPTLLNode(val)
        node.next = self.head
        self.head = node
    }
    
    func pop() -> T? {
        if self.isEmpty() {
            return nil
        }
        let res = self.head!
        self.head = self.head!.next
        return res.val
    }
    
    private class WPTLLNode {
        let val: T
        var next: WPTLLNode? = nil
        init(_ val: T) {
            self.val = val
        }
    }
}
