//
//  decision-tree.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 5/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

enum Tree<T> {
    indirect case branch(T, [Tree])
    case leaf(T)
}

extension Array where Element: Equatable {
    
    func permutations() -> [Tree<Element>] {
        guard !isEmpty else { return [] }
        return map { e in
            let branches = filter { $0 != e }
            if branches.isEmpty {
                return .leaf(e)
            }
            return .branch(e, branches.permutations() + branches.map { .leaf($0) })
        }
    }
}

extension Tree where T: Hashable {
    
    func flatten() -> Set<[T]> {
        return flatten(acc: [])
    }
    
    private func flatten(acc: [T]) -> Set<[T]> {
        switch self {
        case let .leaf(t): return Set([acc + [t]])
        case let .branch(t, b): return Set(b.flatMap { $0.flatten(acc: acc + [t]) })
        }
    }
}

