import Foundation


@available(macOS 10.15, *)
public class SwiftTarot: ObservableObject {
    public typealias DeckSlice = ArraySlice<TarotCard>
    public private(set) var deck = Deck()
    public private(set) var spread = Spread(.none)
    public private(set) var remainingCards = ArraySlice<TarotCard>()
    public private(set) var spreadCards = ArraySlice<TarotCard>()
    public private(set) var clarifierCards = ArraySlice<TarotCard>()
    public let dataHelper: any DataHelperProtocol
    public init(dataHelper dh: some DataHelperProtocol) {
        self.dataHelper = dh
    }
    public func setSpread(spreadType s: SpreadType) {
        var tmpDeck = dataHelper.populateDeck()
        tmpDeck.shuffle()
        deck = tmpDeck
        let idx = deck.lastIndex { card in
            card.suit == .major
        }
        spread = Spread(s)
        spreadCards = deck[deck.startIndex..<spread.size]
        clarifierCards = deck[idx...deck.endIndex]
        remainingCards = deck[s.size..<idx]
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


public protocol DataHelperProtocol {
    @available(macOS 10.15, *)
    func populateDeck() -> SwiftTarot.Deck
}
