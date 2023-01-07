import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension SwiftTarot {
    public struct Deck:  Equatable, CustomStringConvertible, Sequence, Collection {
        public typealias DeckIndex = Int
        public typealias Index = Int
        public typealias Element = SwiftTarot.TarotCard
        public typealias Cards = [SwiftTarot.TarotCard]
        public typealias DeckIndexRange = Range<Index>
        public typealias DeckSlice = ArraySlice<Element>
        public typealias Iterator = SwiftTarot.Deck.Cards.Iterator
        fileprivate var cards: Cards = []
        public let deckSize = 78
        public init(_ cards: [Element]) {
            self.cards = cards
        }
        public init(arrayLiteral elements: Element...) {
            self.init(elements)
        }
        public subscript(position: Index) -> Element {
            precondition(cards.indices.contains(position), "out of bounds")
            return self.cards[position]
        }
        public subscript(bounds: Range<Index>) -> ArraySlice<Element> {
            self.cards[bounds]
        }        
        private mutating func cutDeckAt(_ i: Index) {
            var new: [TarotCard] = []
            new.append(contentsOf: cards[i...cards.endIndex])
            new.append(contentsOf: cards[cards.startIndex..<i])
            cards = new
        }
        public mutating func faceUp(at idx: Index) {
            var card = cards[idx]
            cards.remove(at: idx)
            card.faceUp = true
            cards.insert(card, at: idx)
        }
        public mutating func shuffle() {
            var shuffled = self.cards.shuffled()
            var g: [Int] = []
            (0..<(Int.random(in: 0..<deckSize) % 7)).forEach { _ in
                let r = Int.random(in: 0..<deckSize)
                while g.contains(r) == true {
                    r = Int.random(in: 0..<deckSize)
                }
                g.append(r)
                var revCard = cards[r]
                revCard.reversed.toggle()
                shuffled.replaceSubrange(r...r, with: [revCard])
            }
            self.cards = shuffled
        }
        public var count: Int {
            self.cards.count
        }
        internal func randomCard() -> TarotCard {
            self.cards.randomElement()!
        }
        fileprivate mutating func insert(_ c: Element, at i: Index) {
            self.cards.insert(c, at: i)
        }
        fileprivate mutating func remove(at i: Index) {
            self.cards.remove(at: i)
        }
        fileprivate mutating func append(_ c: Element) {
            self.cards.append(c)
        }
        public mutating func lastIndex(where p: @escaping ((Element) -> Bool)) -> Index {
            self.cards.lastIndex(where: @escaping p)!
        }
        public var description: String {
            var res = ""
            self.cards.forEach { card in
                res += String(describing: card) + "\n"
            }
            return res
        }
        public func makeIterator() -> Iterator {
            self.cards.makeIterator()
        }
        public var startIndex: Index {
            self.cards.startIndex
        }
        public var endIndex: Index {
            self.cards.endIndex
        }
        
        public func index(after i: Index) -> Index {
            return self.cards.index(after: i)
        }
        
    }
    
}
