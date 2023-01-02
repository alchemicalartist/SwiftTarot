import Foundation


extension SwiftTarot {
    @available(iOS 13.0, *)
    @available(macOS 10.15, *)
    public class Reader: ObservableObject, CustomStringConvertible  {
        public typealias DeckSlice = ArraySlice<TarotCard>
        public private(set) var deck = Deck.setupDeck()
        public private(set) var spread = Spread()
        public private(set) var remainingCards = ArraySlice<TarotCard>()
        public var spreadType: SpreadType = .none
        public init() {}
        public init(_ s: SpreadType){
            deck = Deck.setupDeck()
            let idx = deck.lastIndex { card in
                card.suit == .major
            }
            spread.newSpreadType(s, witchCards: deck[0..<s.size], andClarifiers: deck[idx..<deck.count])
            remainingCards = deck[s.size..<idx]
            spreadType = s
        }
        public func chooseSpread(spreadType s: SpreadType) {
            deck = Deck.setupDeck()
            let idx = deck.lastIndex { card in
                card.suit == .major
            }
            spread.newSpreadType(s, witchCards: deck[0..<s.size], andClarifiers: deck[idx..<deck.count])
            remainingCards = deck[s.size..<idx]
            spreadType = s
        }
        public var description: String {
            var res = String(describing: spread)
            res += "\n"
            res += "***** Contents of Remaining Cards: \(remainingCards.count) cards  *****\n"
            remainingCards.forEach { card in
                res += String(describing: card) + "\n"
            }
            res += "\n"
            res += "***** Contents of Entire Deck: \(deck.count) cards  *****\n"
            deck.forEach { card in
                res += String(describing: card) + "\n"
            }
            return res
        }
    }
    
    public struct UprightSpreadPos: Hashable {
        public let card: TarotCard
        public let position: SpreadPosition
    }
}
