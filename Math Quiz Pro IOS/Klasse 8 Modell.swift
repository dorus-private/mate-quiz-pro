//
//  Klasse 8 Modell.swift
//  Math Quiz Pro IOS
//
//  Created by Leon Șular on 04.08.23.
//

import Foundation
import SwiftUI

class Configuration {
    init(exerciseType: String, active: Bool) {
    }
}

class Exercise: Identifiable {
    let id = UUID()
    var description: String = ""
    var formula: String = ""
    var active: Bool = false
    
    init(description: String, active: Bool) {
        self.description = description
        self.active = active
    }
    
    func getDescription() -> String {
        return description
    }
    
    func getFormula() -> String {
        return formula
    }
}

class BinomischeFormeln: Exercise {
    init(active: Bool) {
        super.init(description: "Binomische Formeln", active: active)
        formula = binomischeFormelnAufgaben()
    }
    
    func binomischeFormelnAufgaben() -> String {
        let binomischeFormel = Int.random(in: 1...3)
        var task = ""
        if binomischeFormel == 1 {
            task = "(a + \(Int.random(in: 3...10)))2".superscripted
        } else if binomischeFormel == 2 {
            task = "(a - \(Int.random(in: 3...10)))2".superscripted
        } else {
            let rdNumber1 = Int.random(in: 2...20)
            task = "(a + \(rdNumber1)) * (a - \(rdNumber1))"
        }
        return task
    }
}

class TermeMitMehrerenVariablen: Exercise {
    init(active: Bool) {
        super.init(description: "Terme mit mehreren Variablen", active: active)
        formula = termeMitMehrerenVariablenAufgaben()
    }
    
    func termeMitMehrerenVariablenAufgaben() -> String {
        var task = ""
        let variables = ["x", "y", "z"]
        
        var taskComponents: [String] = []
        for _ in 1...3 {
            let variable = variables.randomElement()!
            let coefficient = Int.random(in: 1...10)
            taskComponents.append("\(coefficient)\(variable)")
        }
        
        for i in 0...taskComponents.count - 1 {
            if i == 0 {
                task = task + taskComponents[i] + " * "
            } else {
                let operatorVar = Int.random(in: 1...2)
                if i != taskComponents.count - 1 {
                    if operatorVar == 1 {
                        task = task + taskComponents[i] + " + "
                    } else {
                        task = task + taskComponents[i] + " - "
                    }
                } else {
                    task = task + taskComponents[i]
                }
            }
        }
        return task
    }
}
