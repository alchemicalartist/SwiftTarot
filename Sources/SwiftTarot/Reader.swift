import Foundation


extension SwiftTarot {
    @available(macOS 10.15, *)
    public class Reader: ObservableObject, CustomStringConvertible  {
        public typealias DeckSlice = ArraySlice<TarotCard>
        public private(set) var deck = Deck.setupDeck()
        public private(set) var spread = Spread()
        public private(set) var remainingCards = ArraySlice<TarotCard>()
        public var spreadType: SpreadType = .none
        public init() {}
        public func chooseSpread(spreadType s: SpreadType) {
            deck = Deck.setupDeck()
            let idx = deck.lastIndex { card in
                card.suit == .major
            }
            spread.newSpread(s, witchCards: deck[0..<s.size], andClarifiers: deck[idx..<deck.count])
            remainingCards = deck[s.size..<idx]
            spreadType = s
        }
        public func getSpreadCard(row r: Int, col c: Int) -> TarotCard {
            deck[((r * 3) + c)]
        }
        public func readNextInSpread() -> UprightSpreadPos? {
            let i = spread.spreadCards.firstIndex { card in
                card.faceUp == false
            }
            if i == nil { return nil }
            let idx = i!
            deck.faceUp(at: idx)
            spread.spreadCards = deck[0..<spreadType.size]
            return UprightSpreadPos(card: deck[idx], position: spread.spread[idx])
        }
        public func readNextClarifier() -> TarotCard? {
            let i = spread.clarifiers.firstIndex { card in
                card.faceUp == false
            }
            if i == nil { return nil }
            let idx = i!
            deck.faceUp(at: idx)
            let cl = deck.count - spread.clarifiers.count
            spread.clarifiers = deck[cl...deck.endIndex]
            return spread.clarifiers[idx]
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
