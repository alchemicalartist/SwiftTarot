import Foundation

extension SwiftTarot {
    public struct Deck: Equatable, CustomStringConvertible, Sequence, Collection, ExpressibleByArrayLiteral  {
        public typealias DeckIndex = Int
        public typealias DeckIndexRange = Range<DeckIndex>
        public typealias DeckSlice = ArraySlice<TarotCard>
        public typealias Iterator = DeckIterator
        fileprivate var cards: [TarotCard]
        public let deckSize = 78
        public init(_ cards: [TarotCard]) {
            self.cards = cards
        }
        public init(arrayLiteral elements: TarotCard...) {
            self.init(elements)
        }
        public subscript(position: DeckIndex) -> Iterator.Element {
            precondition(cards.indices.contains(position), "out of bounds")
            return cards[position]
        }
        public subscript(bounds: DeckIndexRange) -> DeckSlice {
            cards[bounds]
        }
        public static func setupDeck() -> Deck {
            var cards: [TarotCard] = []
            for rank in Rank.allCases {
                for suit in Suit.minors {
                    cards.append(TarotCard(suit: suit, cardValue: rank))
                }
            }
            for major in MajorCard.allCases {
                cards.append(TarotCard(suit: .major, cardValue: major))
            }
            return Deck(cards)
        }
        
        private mutating func cutDeckAt(_ i: Int) {
            var new = [TarotCard]()
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
            let shuffleNum = Int(random(UInt(73)) % 13)
            for _ in 0..<shuffleNum {
                cards.shuffle()
                let revNum = Int(random(UInt(31)) % 3)
                var revCards = [TarotCard]()
                for _ in 0..<revNum {
                    revCards.append(randomCard())
                }
                revCards.forEach { card in
                    var revCard = card
                    revCard.reversed.toggle()
                    let idx = cards.firstIndex(of: card)!
                    cards.remove(at: idx)
                    cards.insert(revCard, at: idx)
                }
            }
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
            let c = cards[i]
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
        public func makeIterator() -> Iterator {
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
        var times = 0
        init(_ d: Deck) {
            self.deck = d
        }
        public mutating func next() -> TarotCard? {
            guard times < deck.count else { return nil }
            let card = deck[times]
            times += 1
            return card
        }
    }
}
