//
//  pretty-print.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

extension Dictionary where Key == Note, Value == Scale {
    
    var prettyDescription: String {
        return """
        [
        \(map { (key, value) in "key: \(key), scale: \(value.notes)" }
        .sorted()
        .joined(separator: "\n  "))
        ]
        """
    }
}

extension Note: CustomDebugStringConvertible {
    
    var debugDescription: String {
        switch self {
        case .A: return "A"
        case .As: return "A♯/B♭"
        case .B: return "B"
        case .C: return "C"
        case .Cs: return "C♯/D♭"
        case .D: return "D"
        case .Ds: return "D♯/E♭"
        case .E: return "E"
        case .F: return "F"
        case .Fs: return "F♯/G♭"
        case .G: return "G"
        case .Gs: return "G♯/A♭"
        }
    }
}

extension Chord: CustomStringConvertible {
    
    var description: String {
        return String(describing: scale.root) + {
            let third = String(describing: self.third)
            switch (self.third, seventh, ninth) {
            case (.major, nil, nil):
                return ""
            case (.minor, nil, nil):
                return third
                
            case let (.major, .major?, nine?), let (.minor, .minor?, nine?):
                return third + String(describing: nine)
            case (.major, .minor?, .dominant?):
                return "9"
            case (.major, nil, .dominant?):
                return "add9"
            case (.minor, nil, .dominant?):
                return third + "add9"
                
            case let (.major, .minor?, nine?), let (.minor, .diminished?, nine?):
                return String(describing: self.seventh) + String(describing: nine)
            case (.major, .minor?, nil), (.minor, .diminished?, nil):
                return String(describing: self.seventh)
            case (.major, .major?, nil), (.minor, .minor?, nil):
                return third + "7"
            
            case let (_, nil, nine?):
                return "\(third)\(nine)"

            case (.minor, .major?, _):
                return "!!" //!!!
            case (.major, .diminished?, _):
                return ""
            }
        }() + String(describing: fifth)
    }
}

extension Chord.Third: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .major: return "maj"
        case .minor: return "min"
        }
    }
}

extension Chord.Fifth: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .perfect: return ""
        case .diminished: return "♭5"
        case .augmented: return "♯5"
        }
    }
}

extension Chord.Seventh: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .major: return "maj7"
        case .minor: return "7"
        case .diminished: return "°7"
        }
    }
}

extension Chord.Ninth: CustomStringConvertible {
    
    var description: String {
        switch self {
        case .dominant: return "9"
        case .diminished: return "♭9"
        case .augmented: return "♯9"
        }
    }
}
