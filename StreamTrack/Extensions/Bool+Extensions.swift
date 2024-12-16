//
//  Bool+Extensions.swift
//  StreamTrack
//
//  Created by Michael Knych on 12/8/24.
//

import Foundation

extension Bool: @retroactive Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        // the only true inequality is false < true
        !lhs && rhs
    }
}
