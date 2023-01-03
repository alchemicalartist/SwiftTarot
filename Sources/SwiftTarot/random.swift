//
//  File.swift
//  
//
//  Created by Chris Denton on 12/30/22.
//

import Foundation
import Darwin

public extension Collection {
    func shuffled() -> [Iterator.Element] {
        var array = Array(self)
        array.shuffle()
        return array
    }
}

public extension MutableCollection {
    mutating func shuffle() {
        var i = startIndex
        var n = count
        
        while n > 1 {
            let j = index(i, offsetBy: SwiftTarot.random(n))
            swapAt(i, j)
            formIndex(after: &i)
            n -= 1
        }
    }
}

extension SwiftTarot {
    public static func random<T: BinaryInteger> (_ n: T) -> T {
        return numericCast( arc4random_uniform( numericCast(n)))
    }
}
