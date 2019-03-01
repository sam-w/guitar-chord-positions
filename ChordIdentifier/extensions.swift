//
//  utilities.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

extension Int {
    
    func wrapped(limit: Int, allowZero: Bool) -> Int {
        if self == 0 || self == limit, !allowZero {
            return limit
        } else if self > 0 {
            return self % limit
        } else {
            return (limit + self).wrapped(limit: limit, allowZero: allowZero)
        }
    }
}

extension Array where Element == Int {
    
    func sum() -> Element {
        return reduce(0, { $0 + $1 })
    }
    
    func mean() -> Double {
        return map { Double($0) }.mean()
    }
    
    func meanDeviation() -> Double {
        return map { Double($0) }.meanDeviation()
    }
}

extension Array where Element == Double {
    
    func sum() -> Element {
        return reduce(0, { $0 + $1 })
    }
    
    func mean() -> Double {
        return Double(sum()) / Double(count)
    }
    
    func meanDeviation() -> Double {
        let m = mean()
        return self.map { e -> Double in
            let d = e - m
            return Swift.max(d, -d)
        }.mean()
    }
}

extension Comparable {
    
    func compare(to other: Self) -> ComparisonResult {
        switch (self, other) {
        case let (l, r) where l > r: return .orderedDescending
        case let (l, r) where l == r: return .orderedSame
        default: return .orderedAscending
        }
    }
}
