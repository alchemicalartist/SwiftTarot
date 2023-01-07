import Foundation

@available(macOS 10.15, *)
extension SwiftTarot {
    public struct Deck:  Equatable, CustomStringConvertible, Sequence, Collection {
        public typealias DeckIndex = Int
        public typealias Element = TarotCard
        public typealias Cards = [TarotCard]
        public typealias DeckIndexRange = Range<DeckIndex>
        public typealias DeckSlice = ArraySlice<TarotCard>
        public typealias Iterator = DeckIterator
        fileprivate var cards: Cards = []
        public let deckSize = 78
        public init(_ cards: [TarotCard]) {
            self.cards = cards
        }
        public init(arrayLiteral elements: TarotCard...) {
            self.init(elements)
        }
        public subscript(position: DeckIndex) -> TarotCard {
            precondition(cards.indices.contains(position), "out of bounds")
            return cards[position]
        }
        public subscript(bounds: DeckIndexRange) -> DeckSlice {
            cards[bounds]
        }        
        private mutating func cutDeckAt(_ i: Int) {
            var new: [TarotCard] = []
            new.append(contentsOf: cards[i...cards.endIndex])
            new.append(contentsOf: cards[cards.startIndex..<i])
            cards = new
        }
        public mutating func faceUp(at idx: Int) {
            var card = cards[idx]
            cards.remove(at: idx)
            card.faceUp = true
            cards.insert(card, at: idx)
        }
        public mutating func shuffle() {
            var shuffled = cards.shuffled()
            (0..<(Int.random(in: 0..<deckSize) % 7)).forEach { _ in
                var revCard = cards.randomElement()!
                let index = shuffled.firstIndex(of: revCard)!
                revCard.reversed.toggle()
                shuffled.replaceSubrange(index...index, with: [revCard])
            }
            cards = shuffled
        }
        public var count: Int {
            cards.count
        }
        internal func randomCard() -> TarotCard {
            cards.randomElement()!
        }
        fileprivate mutating func insert(_ c: TarotCard, at i: Int) {
            cards.insert(c, at: i)
        }
        fileprivate mutating func remove(at i: Int) {
            cards.remove(at: i)
        }
        fileprivate mutating func append(_ c: TarotCard) {
            cards.append(c)
        }
        public mutating func lastIndex(where p: ((TarotCard) -> Bool)) -> Int {
            cards.lastIndex(where: p)!
        }
        public var description: String {
            var res = ""
            cards.forEach { card in
                res += String(describing: card) + "\n"
            }
            return res
        }
        public func makeIterator() -> DeckIterator {
            DeckIterator(self)
        }
        public var startIndex: DeckIndex {
            cards.startIndex
        }
        public var endIndex: DeckIndex {
            cards.endIndex
        }
        
        public func index(after i: Int) -> Int {
            precondition(cards.indices.contains(i), "out of bound")
            return cards.index(after: i)
        }
        
    }
    
    public struct DeckIterator: IteratorProtocol {
        public typealias Element = TarotCard
        let deck: Deck
        var idx = 0
        init(_ d: Deck) {
            self.deck = d
        }
        public mutating func next() -> Self.Element? {
            guard idx < deck.count else { return nil }
            let card = deck[idx]
            idx += 1
            return card
        }
    }
}
