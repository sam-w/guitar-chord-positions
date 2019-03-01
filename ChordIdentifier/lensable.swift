//
//  lensable.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 5/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

protocol Lensable {
    
    var lense: ((inout Self) -> ()) -> Self { get }
}

extension Lensable {
    
    var lense: ((inout Self) -> ()) -> Self {
        return {
            var lensed = self
            $0(&lensed)
            return lensed
        }
    }
}
