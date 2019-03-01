//
//  note.swift
//  ChordIdentifier
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import Foundation

enum Note: Int {
    case A = 1
    case As = 2
    case B = 3
    case C = 4
    case Cs = 5
    case D = 6
    case Ds = 7
    case E = 8
    case F = 9
    case Fs = 10
    case G = 11
    case Gs = 12
    
    static let Bb = Note.As
    static let Db = Note.Cs
    static let Eb = Note.Ds
    static let Gb = Note.Fs
    static let Ab = Note.Gs
    
    func sharpened() -> Note {
        return Note(rawValue: (rawValue + 1).wrapped(limit: 12, allowZero: false))!
    }
    
    func flattened() -> Note {
        return Note(rawValue: (rawValue - 1).wrapped(limit: 12, allowZero: false))!
    }
}


