import UIKit

struct NumberOfPassengers {
    var adult = 1
    var teen = 0
    var child = 0
    var infant = 0
    
    var isValidEntry: Bool {
        get {
            adult > 0 && infant <= adult &&
            !(adult > 6 || teen > 6 || child > 6)
        }
    }
    
    func formattedPassengers() -> String? {
        var passengerStrings = [String]()
        
        if adult > 0 {
            passengerStrings.append("\(adult) Adult\(adult > 1 ? "s" : "")")
        }
        if teen > 0 {
            passengerStrings.append("\(teen) Teen\(teen > 1 ? "s" : "")")
        }
        if child > 0 {
            passengerStrings.append("\(child) Child\(child > 1 ? "ren" : "")")
        }
        if infant > 0 {
            passengerStrings.append("\(infant) Infant\(infant > 1 ? "s" : "")")
        }
        
        return passengerStrings.joined(separator: ", ")
    }
}
