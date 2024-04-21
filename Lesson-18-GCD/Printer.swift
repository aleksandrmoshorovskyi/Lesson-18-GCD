//
//  Printer.swift
//  Lesson-18-GCD
//
//  Created by Aleksandr Moroshovskyi on 18.04.2024.
//

import Foundation

class Printer {

    var completion: (((text: String, count: Float)) -> ())?
    
    func printSomeTextWithCounter(text: String) {
        
        var progresInt: Float = 0.0
        var counter = -99999
        
        while counter < 99999 {
            counter += 1
            let text = "\(text) - \(counter)"
            //для плавності
            if counter % 1000 == 0 {
                
                switch counter {
                case -99999...0:
                    progresInt = 0.5 - (Float(counter * (-1)) * 50.0) / 99999 / 100
                case 0:
                    progresInt = 0.5
                case 0...99999:
                    progresInt = 0.5 + (Float(counter) * 50.0) / 99999 / 100
                case 99999:
                    progresInt = 1
                default:
                    progresInt = 0
                }
                
                completion?((text, progresInt))
            }
            debugPrint(text)
        }
    }
    
    func printSomeText(text: String) {
        
        var counter = -99999
        
        while counter < 99999 {
            counter += 1
            debugPrint("\(text) - \(counter)")
        }
    }
}
