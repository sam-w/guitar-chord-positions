//
//  main.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

let argCount = CommandLine.argc

print(Guitar.positions(for: Note.A.maj))
/*print(Note.Fs.min9.b5)
print(Guitar.positions(for: Note.Eb.dom9)[0...10])*/

let allChords: [Chord] = (1...12)
    .map { Note(rawValue: $0)! }
    .flatMap { n -> [Chord] in
        let c1 = [
            n.maj,
            n.min,
            n.maj7
        ]
        let c2 = [
            n.dom7,
            n.min7,
            n.maj9
        ]
        let c3 = [
            n.dom9,
            n.min9,
            n.add9
        ]
        return c1 + c2 + c3
    }.flatMap {
        [$0, $0.b5, $0.b9, $0.b5.b9]
    }
    
/*let allPositions = allChords
    .flatMap { Guitar.positions(for: $0) }*/

extension Chord {
    
    static func chords(for notes: [Note]) -> [Chord] {
        let notesSet = Set(notes)
        return allChords.sorted {
            switch (
                notesSet.symmetricDifference($0.notes).count.compare(to: notesSet.symmetricDifference($1.notes).count),
                notesSet.intersection($0.notes).count.compare(to: notesSet.intersection($1.notes).count)
            ) {
            case (.orderedAscending, _),
                 (.orderedSame, .orderedAscending):
                return true
            default:
                return false
                
            }
        }
    }
}

extension Guitar {
    
    static func chords(for position: [String.Position]) -> [Chord] {
        return Chord.chords(for: position.map { $0.note })
    }
}

let position: [Guitar.String.Position] = [
//.init(string: .E, fret: 5),
.init(string: .A, fret: 0),
.init(string: .D, fret: 2),
.init(string: .G, fret: 4),
.init(string: .B, fret: 2),
//.init(string: .e, fret: 5),
]

let possibilities =  Guitar.chords(for: position)
print(possibilities[0...5])

/*guard argCount > 1 else {
 fputs("expected argument", stderr)
    exit(1)
}

let argument = CommandLine.arguments[1]
let strings = argument.split(separator: ",")

guard strings.count == 6 else {
    fputs("expected 6 strings", stderr)
    exit(1)
}*/












