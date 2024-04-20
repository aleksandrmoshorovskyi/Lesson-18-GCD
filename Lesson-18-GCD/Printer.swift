//
//  Printer.swift
//  Lesson-18-GCD
//
//  Created by Aleksandr Moroshovskyi on 18.04.2024.
//

import Foundation

class Printer {

    func printSomeText(text: String) {
        
        var counter = -99999
        
        while counter < 99999 {
            counter += 1
            debugPrint("\(text) - \(counter)")
        }
    }
}
