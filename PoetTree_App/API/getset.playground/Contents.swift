import UIKit

//protocol MyProtocol {
//    var myVar1: String { get set }
//    var myVar2: String { get }
//}
//
//struct MyStruct: MyProtocol {
//
//    var myVar1: String = ""
//
//    var myVar2: String = ""
//
//}
//
//
//var testStruct = MyStruct()
//
//testStruct.myVar1 = "hi"
//testStruct.myVar2 = "bye"
//
//
//var testProtocol: MyProtocol = MyStruct()
//testProtocol.myVar1 = "apple"
//
//
//
//protocol Flyable {
//
//    var speedLimit: Int { get set }
//
//    func fly()
//
//}
//
//extension Flyable {
//
//    func fly(){
//        print("Fly with speed limit \(speedLimit)")
//    }
//
//}
////
//class AirPlane: Flyable {
//
//    var speedLimit: Int = 10
//
//}
//
//class Helicopter: Flyable {
//    var speedLimit: Int = 20
//
//}

//class SpeedLimitUpdater {
//
//    static func reduceSpeedLimit(of flyables: [Flyable], by value: Int) {
//
//        for var flyable in flyables {
//            flyable.speedLimit -= value
//        }
//
//    }
//
//    static func increaseSpeedLimit(of flyables: [Flyable], by value: Int) {
//
//        for var flyable in flyables {
//            flyable.speedLimit -= value
//        }
//
//    }
//}
//
//class Bird: Flyable {
//    var speedLimit: Int = 20
//}
//
//protocol Flyable {
//    var speedLimit: Int { get }
//
//    func fly()
//}
//
//extension Flyable {
//    func fly(){
//        print("I'm flying")
//    }
//}
//
//
//
//class Bird: Flyable {
//
//    private(set) var speedLimit: Int = 20
//
//}
//
//
//class SpeedLimitUpdater {
//
//    static func reduceSpeedLimit(of flyables: [Flyable], by value: Int) {
//
//        for flyable in flyables {
//            if let helicopter = flyable as? Helicopter {
//                helicopter.speedLimit -= value
//            } else if let airplane = flyable as? AirPlane {
//                airplane.speedLimit -= value
//            }
//        }
//
//    }
//
//
//    static func increaseSpeedLimit(of flyables: [Flyable], by value: Int) {
//
//        for flyable in flyables {
//
//            if let helicopter = flyable as? Helicopter {
//                helicopter.speedLimit += value
//            } else if let airplane = flyable as? AirPlane {
//                airplane.speedLimit += value
//            }
//        }
//    }
//}
//

protocol Flyable: class {
    
    /// Limit the speed of flyable
    var speedLimit: Int { get }
    
    func fly()
}

extension Flyable {
    func fly() {
        print("Fly with speed limit: \(speedLimit)mph")
    }
}

class Airplane: Flyable {
    var speedLimit = 500
}

class Helicopter: Flyable {
    var speedLimit = 150
}

class SpeedLimitUpdater {
    
    
    
    static func reduceSpeedLimit(of flyables: [Flyable], by value: Int) {
        // Only update speedLimit of Helicopter & Airplane
        for flyable in flyables {
            if let helicopter = flyable as? Helicopter {
                helicopter.speedLimit -= value
            } else if let airplane = flyable as? Airplane {
                airplane.speedLimit -= value
            }
        }
        
    }
    
    static func increaseSpeedLimit(of flyables: [Flyable], by value: Int) {
        // Only update speedLimit of Helicopter & Airplane
        for flyable in flyables {
            if let helicopter = flyable as? Helicopter {
                helicopter.speedLimit += value
            } else if let airplane = flyable as? Airplane {
                airplane.speedLimit += value
            }
        }
    }
}

class Bird: Flyable {
    private(set) var speedLimit = 20
}

// Let's test the code above
let flyable1 = Bird()
let flyable2 = Airplane()
let flyable3 = Helicopter()

let flyableArray: [Flyable] = [flyable1, flyable2, flyable3]

SpeedLimitUpdater.reduceSpeedLimit(of: flyableArray, by: 10)

for flyable in flyableArray {
    flyable.fly()
}


protocol limit {
    
    var limit: Int { get }
    
    func ride()
    
}

extension limit {
    func ride(){
        print("I'm riding")
    }
}

class Car: limit {
    
    var limit: Int = 10
    
}

class Bus: limit {
    var limit: Int = 20
}

class Taxi: limit {
    private(set) var limit: Int = 5
}

class LimitSpeed {
    
    static func reduceLimit(of transportations: [limit], by value: Int) {
            
        for var transportation in transportations {
            
            if let trans = transportation as? Car {
                trans.limit += 10
            } else if let trans = transportation as? Bus {
                trans.limit += 20
            }
            
            
        }
        
        
    }
    
}
