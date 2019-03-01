//
//  chord.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 4/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

struct Chord {
    
    enum Third {
        case major
        case minor
    }
    
    enum Fifth {
        case perfect
        case diminished
        case augmented
    }
    
    enum Seventh {
        case major
        case minor
        case diminished
    }
    
    enum Ninth {
        case dominant
        case diminished
        case augmented
    }
    
    let scale: Scale
    
    var third: Third
    var fifth: Fifth
    var seventh: Seventh?
    var ninth: Ninth?
    
    var notes: [Note] {
        return [
            scale.root,
            third.modifier(scale.third),
            fifth.modifier(scale.perfectFifth),
            seventh?.modifier(scale.seventh),
            ninth?.modifier(scale.second),
        ].compactMap { $0 }
    }
}

extension Chord.Third {
    
    var modifier: (Note) -> Note {
        switch self {
        case .major: return { $0 }
        case .minor: return { $0.flattened() }
        }
    }
}

extension Chord.Fifth {
    
    var modifier: (Note) -> Note {
        switch self {
        case .perfect: return { $0 }
        case .diminished: return { $0.flattened() }
        case .augmented: return { $0.sharpened() }
        }
    }
}

extension Chord.Seventh {
    
    var modifier: (Note) -> Note {
        switch self {
        case .major: return { $0 }
        case .minor: return { $0.flattened() }
        case .diminished: return { $0.flattened().flattened() }
        }
    }
}

extension Chord.Ninth {
    
    var modifier: (Note) -> Note {
        switch self {
        case .dominant: return { $0 }
        case .diminished: return { $0.flattened() }
        case .augmented: return { $0.sharpened() }
        }
    }
}

extension Chord: Lensable {}

extension Note {

    var maj: Chord {
        return Chord(
            scale: self.majorScale,
            third: .major,
            fifth: .perfect,
            seventh: nil,
            ninth: nil)
    }
    
    var min: Chord {
        return self.maj.lense { $0.third = .minor }
    }
    
    var maj7: Chord {
        return self.maj.lense { $0.seventh = .major }
    }
    
    var dom7: Chord {
        return self.maj.lense { $0.seventh = .minor }
    }
    
    var min7: Chord {
        return self.min.lense { $0.seventh = .minor }
    }
    
    var dim7: Chord {
        return self.min.b5.lense { $0.seventh = .diminished }
    }
    
    var maj9: Chord {
        return self.maj7.lense { $0.ninth = .dominant }
    }
    
    var dom9: Chord {
        return self.dom7.lense { $0.ninth = .dominant }
    }
    
    var min9: Chord {
        return self.min7.lense { $0.ninth = .dominant }
    }
    
    var add9: Chord {
        return self.maj.lense { $0.ninth = .dominant }
    }
}

extension Chord {
    
    var b5: Chord {
        var chord = self
        chord.fifth = .diminished
        return chord
    }
    
    var b9: Chord {
        var chord = self
        chord.ninth = .diminished
        return chord
    }
}
