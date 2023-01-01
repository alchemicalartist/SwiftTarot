//
//  File.swift
//  
//
//  Created by Chris Denton on 12/30/22.
//

import Foundation
import Darwin

extension SwiftTarot {
    public static func random<T: BinaryInteger> (_ n: T) -> T {
        return numericCast( arc4random_uniform( numericCast(n)))
    }
}
