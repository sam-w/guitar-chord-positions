//
//  circle-of-fifths.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

struct CircleOfFifths {
    
    private static let cMaj = Scale([.C, .D, .E, .F, .G, .A, .B])
    private static let circle = Dictionary<Note, Scale>(
        (0...11).map { majorScale(atClockPosition: $0) },
        uniquingKeysWith: { l, _ in l }
    )

    static func majorScale(forRoot root: Note, clockPosition: Int) -> Scale {
        var notes = cMaj.notes
        (0...clockPosition)
            .filter { $0 > 0 }
            .forEach {
                let position = (($0 * 3) + ($0 - 1)).wrapped(limit: 7, allowZero: true)
                notes[position] = notes[position].sharpened()
        }
        let scale = notes.sorted {
            if $0.rawValue >= root.rawValue && $1.rawValue < root.rawValue {
                return true
            } else if $1.rawValue >= root.rawValue && $0.rawValue < root.rawValue {
                return false
            } else {
                return $0.rawValue < $1.rawValue
            }
        }
        return Scale(scale)
    }

    static func majorScale(atClockPosition clockPosition: Int) -> (root: Note, scale: Scale) {
        let root = Note(rawValue: (Note.C.rawValue - (clockPosition * 5)).wrapped(limit: 12, allowZero: false))!
        let scale = majorScale(forRoot: root, clockPosition: clockPosition)
        return (root, scale)
    }
    
    static func majorScale(forRoot root: Note) -> Scale {
        return circle[root]!
    }
}

extension Note {
    
    var majorScale: Scale {
        return CircleOfFifths.majorScale(forRoot: self)
    }
}
