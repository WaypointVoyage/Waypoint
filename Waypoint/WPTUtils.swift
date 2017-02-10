//
//  WPTUtils.swift
//  Waypoint
//
//  Created by Cameron Taylor on 2/10/17.
//  Copyright © 2017 cpe436group. All rights reserved.
//

import Foundation

func clamp<T: Comparable>(_ value: inout T, min: T, max: T) {
    value = value < min ? min : value > max ? max : value
}
