//
//  scale.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

struct Scale {
    
    var notes: [Note]
    
    init(_ notes: [Note]) {
        assert(notes.count == 7)
        self.notes = notes
    }
    
    var root: Note { return notes[0] }
    var second: Note { return notes[1] }
    var third: Note { return notes[2] }
    var fourth: Note { return notes[3] }
    var perfectFifth: Note { return notes[4] }
    var sixth: Note { return notes[5] }
    var seventh: Note { return notes[6] }
}

extension Scale {
    
    public static func == (lhs: Scale, rhs: Scale) -> Bool {
        return lhs.notes == rhs.notes
    }
}
