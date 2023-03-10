import Foundation


@available(macOS 10.15, *)
@available(iOS 13.0, *)
public class SwiftTarot: ObservableObject {
    public typealias DeckSlice = ArraySlice<TarotCard>
    @Published public private(set) var deck = Deck()
    @Published public private(set) var spread = Spread(.none)
    public private(set) var remainingCards = ArraySlice<TarotCard>()
    public private(set) var spreadCards = ArraySlice<TarotCard>()
    public private(set) var clarifierCards = ArraySlice<TarotCard>()
    public let dataHelper: any TarotHelperProtocol
    public init(helper dh: some TarotHelperProtocol) {
        dataHelper = dh
        let s: SpreadType = .none
        var tmpDeck = dh.populateDeck()
        tmpDeck.shuffle()
        deck = tmpDeck
        let idx = deck.lastMajor()
        spread = Spread(s)
        spreadCards = deck[0..<s.size]
        clarifierCards = deck[idx..<deck.count]
        remainingCards = deck[s.size..<idx]
    }
    public convenience init (){
        self.init(helper: DefaultHelper())
    }
    public func setSpread(spreadType s: SpreadType) {
        var tmpDeck = dataHelper.populateDeck()
        tmpDeck.shuffle()
        deck = tmpDeck
        let idx = deck.lastMajor()
        spread = Spread(s)
        spreadCards = deck[0..<s.size]
        clarifierCards = deck[idx..<deck.count]
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

@available(macOS 10.15, *)
@available(iOS 13.0, *)
public protocol TarotHelperProtocol {
    func populateDeck() -> SwiftTarot.Deck
}
