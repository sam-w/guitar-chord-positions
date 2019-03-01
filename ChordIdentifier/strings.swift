//
//  strings.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 4/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

struct Guitar {
    
    enum String: Int {
        case E
        case A
        case D
        case G
        case B
        case e
    }
    
    static let strings: [String] = [.E, .A, .D, .G, .B, .e]
    
    struct Position {
        let chord: Chord
        let strings: [String.Position]
    }
}

extension Guitar.String {
    
    struct Position {
        typealias Fret = Int
        
        let string: Guitar.String
        let fret: Fret
        
        var note: Note {
            return Note(rawValue: (string.open.rawValue + self.fret).wrapped(limit: 12, allowZero: false))!
        }
    }
    
    typealias Range = [Position]
    
    var open: Note {
        switch self {
        case .E: return .E
        case .A: return .A
        case .D: return .D
        case .G: return .G
        case .B: return .B
        case .e: return .E
        }
    }
    
    var range: Range {
        return (0...12)
            .map { Position(string: self, fret: $0) }
    }
}

extension Guitar {
    
    fileprivate static let stringPermutations = Guitar.strings.permutations().flatMap { $0.flatten() }
    
    static func positions(for chord: Chord, favourOpen: Bool = true, strictRoot: Bool = true) -> [Guitar.Position] {
        assert(Guitar.strings.count >= chord.notes.count)
        
        func assign(note: Note, to string: String) -> String.Position {
            return .init(string: string, fret: string.range.first(where: { $0.note == note })!.fret)
        }
        
        func assign(notes: [Note], to strings: [String]) -> [String.Position] {
            return zip((notes + notes + notes), strings).map { assign(note: $0.0, to: $0.1) }
        }
        
        let positions = Set(Guitar.stringPermutations
            .filter { $0.count >= chord.notes.count }
            .map {
                assign(notes: chord.notes, to: $0)
                    .sorted { $0.string.rawValue < $1.string.rawValue }
            }).filter {
                guard let root = $0.first else { return false }
                let rooted = root.note == chord.scale.root
                let gaps = zip($0, $0.dropFirst())
                    .map { $1.string.rawValue - $0.string.rawValue }
                let multiGap = gaps.filter { $0 > 1 }.count > 1
                let weirdGap = gaps.dropFirst().contains { $0 > 1 }
                let playable = /*$0.excludeOpens().fretSpacing() < 4
                    &&*/ !multiGap && !weirdGap
                return strictRoot ? rooted && playable : playable
            }.sorted { l, r in
                l.isBetter(than: r)
        }
        
        return positions.map { Guitar.Position(chord: chord, strings: $0) }
    }
}

extension Array where Element == Guitar.String.Position {
    
    func excludeOpens() -> [Element] {
        return self.filter { $0.fret != 0 }
    }
    
    func onlyOpens() -> [Element] {
        return self.filter { $0.fret == 0 }
    }
    
    func fretSpacing() -> Int {
        let frets = map { $0.fret }
        return frets.max()! - frets.min()!
    }
    
    func meanDeviation() -> Double {
        let frets = map { $0.fret }
        return frets.meanDeviation()
    }
    
    func isBetter(than other: [Guitar.String.Position]) -> Bool {
        let selfExcludingOpens = excludeOpens()
        let otherExcludingOpens = other.excludeOpens()
        switch (
            selfExcludingOpens.fretSpacing().compare(to: otherExcludingOpens.fretSpacing()),
            selfExcludingOpens.meanDeviation().compare(to: otherExcludingOpens.meanDeviation()),
            self.count.compare(to: other.count)
        ) {
        case (.orderedAscending, _, _),
             (.orderedSame, .orderedAscending, _),
             (.orderedSame, .orderedSame, .orderedDescending):
            return true
        default:
            return false
        }
    }
}

extension Collection where Element == [Guitar.String.Position] {
    
    var csvRepresentation: String {
        return self.map {
            $0.map { "\($0.fret)" }.joined(separator: ",")
            }.joined(separator: "\n")
    }
}

extension Guitar.String.Position: Equatable, Hashable {
    
    var hashValue: Int {
        return string.rawValue << 8 + fret
    }
    
    static func == (lhs: Guitar.String.Position, rhs: Guitar.String.Position) -> Bool {
        return lhs.string == rhs.string && lhs.fret == rhs.fret
    }
}
