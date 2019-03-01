//
//  ChordIdentifierTests.swift
//  ChordIdentifierTests
//
//  Created by Sam Warner on 2/9/18.
//  Copyright © 2018 Sam Warner. All rights reserved.
//

import XCTest
@testable import ChordIdentifier

class CircleOfFifthsTests: XCTestCase {
    
    let majorScales = Dictionary<Note, Scale>([
        (.Gb, Scale([.Gb, .Ab, .Bb, .B, .Db, .Eb, .F])),
        (.Db, Scale([.Db, .Eb, .F, .Gb, .Ab, .Bb, .C])),
        (.Ab, Scale([.Ab, .Bb, .C, .Db, .Eb, .F, .G])),
        (.Eb, Scale([.Eb, .F, .G, .Ab, .Bb, .C, .D])),
        (.Bb, Scale([.Bb, .C, .D, .Eb, .F, .G, .A])),
        (.F,  Scale([.F, .G, .A, .Bb, .C, .D, .E])),
        
        (.C,  Scale([.C, .D, .E, .F, .G, .A, .B])),
        
        (.G,  Scale([.G, .A, .B, .C, .D, .E, .Fs])),
        (.D,  Scale([.D, .E, .Fs, .G, .A, .B, .Cs])),
        (.A,  Scale([.A, .B, .Cs, .D, .E, .Fs, .Gs])),
        (.E,  Scale([.E, .Fs, .Gs, .A, .B, .Cs, .Ds])),
        (.B,  Scale([.B, .Cs, .Ds, .E, .Fs, .Gs, .As])),
        (.Fs, Scale([.Fs, .Gs, .As, .B, .Cs, .Ds, .F]))
        ], uniquingKeysWith: { assert($0 == $1); return $0 })
    
    func testGeneration() {
        let generatedMajorScales = Dictionary<Note, Scale>(
            (0...12).map { clockPosition in CircleOfFifths.majorScale(atClockPosition: clockPosition) },
            uniquingKeysWith: { assert($0 == $1); return $0 }
        )
        XCTAssert(generatedMajorScales.prettyDescription == majorScales.prettyDescription)
    }
}
