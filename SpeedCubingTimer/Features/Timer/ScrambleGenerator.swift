//
//  ScrambleGenerator.swift
//  SpeedCubingTimer
//
//  Created by Jan Babák on 16.03.2023.
//

import Foundation

final class ScrambleGenerator {
    
    static func generate() -> String {
        return generateThreeByThree()
    }
    
    //generate scramble for 3x3 cube
    static func generateThreeByThree() -> String {
        var scramble: [String] = []
        
        //randomly choose moves of faces
        while (scramble.count < 20) {
            var symbol: String
            
            switch (Int.random(in: 0...5)) {
            case 0:
                symbol = "U"
            case 1:
                symbol = "D"
            case 2:
                symbol = "R"
            case 3:
                symbol = "L"
            case 4:
                symbol = "F"
            case 5:
                symbol = "B"
            default:
                symbol = ""
            }
            
            if scramble.last == symbol {
                continue //forbid 2 same symbols after each other
            }
            
            scramble.append(symbol)
        }
        
        //ranomly choose number of rotations for every move
        for i in 0..<scramble.count {
            switch (Int.random(in: 0...2)) {
            case 0:
                scramble[i] += "'"
            case 1:
                scramble[i] += "2"
            case 2:
                break
            default:
                break
            }
        }
        
        return scrambleToString(scramble)
    }
    
    private static func scrambleToString(_ scramble: [String]) -> String {
        var result = ""
        
        for i in 0..<scramble.count {
            result += (i == 0 ? "" : " ") + scramble[i]
        }
        
        return result
    }
}
