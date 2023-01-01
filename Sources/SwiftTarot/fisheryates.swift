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
