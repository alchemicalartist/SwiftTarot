@available(macOS 10.15, *)
public protocol CardValueProtocol: Comparable, RawRepresentable, CaseIterable {
    var rawValue: Int { get }
    var asString: String { get }
}

@available(macOS 10.15, *)
public protocol TarotCardProtocol {
    var suit: SwiftTarot.Suit { get }
    var faceUp: Bool { get set }
    var reversed: Bool { get set }
    var cardValue: any CardValueProtocol { get }
    var keywords: SwiftTarot.CardAspects { get }
    var cardDescription: SwiftTarot.CardAspects { get }
    var info: String { get }
}

@available(macOS 10.15, *)
extension SwiftTarot {
    public enum Suit: String, Decodable, Comparable {
        case wands, cups, pentacles, swords, major
        public static func < (lhs: Suit, rhs: Suit) -> Bool {
            lhs.rawValue < rhs.rawValue
        }
        public var asString: String {
            switch self {
                case .wands: return "Wands"
                case .cups: return "Cups"
                case .pentacles: return "Pentacles"
                case .swords: return "Swords"
                case .major: return "Major"
            }
        }
        public static var minors: [Suit] {
            [.wands, .cups, .swords, .pentacles]
        }
    }
    
    public struct TarotCard:  Hashable, Equatable, Comparable, CustomStringConvertible, TarotCardProtocol {
        public let suit: Suit
        public var faceUp = false
        public var reversed = false
        public let cardValue: any CardValueProtocol
        public let keywords: CardAspects
        public let cardDescription: CardAspects
        public let info: String
        internal init(suit s: Suit, cardValue cv: some CardValueProtocol){
            suit = s
            cardValue = cv
            keywords = CardAspects(upright: "", reversed: "")
            cardDescription = CardAspects(upright: "", reversed: "")
            info = ""
        }
        public init(_ id: String, _ suit: String, _ info: String, _ kwUpright: String, _ kwReversed: String, _ descUpright: String, _ descReversed: String ) {
            cardDescription = CardAspects(upright: descUpright, reversed: descReversed)
            let tempSuit = suit
            self.suit = Suit(rawValue: tempSuit)!
            if self.suit == .major {
                cardValue = MajorCard(rawValue: Int(id)!)!
            } else {
                cardValue = Rank(rawValue: Int(id)!)!
            }
            self.info = info
            keywords = CardAspects(upright: kwUpright, reversed: kwReversed)
        }
        static public func ==(lhs: Self, rhs: Self) -> Bool {
            lhs.suit.rawValue == rhs.suit.rawValue && lhs.cardValue.rawValue == rhs.cardValue.rawValue
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(suit.rawValue)
            hasher.combine(cardValue.rawValue)
        }
        public static func <(lhs: Self, rhs: Self) -> Bool {
            return lhs.cardValue.rawValue == rhs.cardValue.rawValue ? lhs.suit < rhs.suit : lhs.cardValue.rawValue < rhs.cardValue.rawValue
        }
        public static func >(lhs: Self, rhs: Self) -> Bool {
            return lhs.cardValue.rawValue == rhs.cardValue.rawValue ? lhs.suit > rhs.suit : lhs.cardValue.rawValue > rhs.cardValue.rawValue
        }
        internal var reverseString: String {
            reversed ? " (REVERSE)" : ""
        }
        public var description: String {
            if suit == .major {
                return cardValue.asString + reverseString
            }
            return cardValue.asString + " of " + suit.asString + reverseString
        }
    }
    
    public enum MajorCard: Int, CardValueProtocol {
        public typealias rawValue = Int
        public typealias RawRepresentable = Int
        case theFool = 0, theMagician, theHighPriestess, theEmpress, theEmporer, theHierophant, theLovers, theChariot, strength, theHermit, wheelOfFortune, justice, theHangedMan, death, temperance, theDevil, theTower, theStar, theMoon, theSun, judgement, theWorld
        public var asString: String {
            switch self {
                case .theFool: return "The Fool"
                case .theMagician: return "The Magician"
                case .theHighPriestess: return "The High Priestess"
                case .theEmpress: return "The Empress"
                case .theEmporer: return "The Emporer"
                case .theHierophant: return "The Hierophant"
                case .theLovers: return "The Lovers"
                case .theChariot: return "The Chariot"
                case .strength: return "Strength"
                case .theHermit: return "The Hermit"
                case .wheelOfFortune: return "Wheel of Fortune"
                case .justice: return "Justice"
                case .theHangedMan: return "The Hanged Man"
                case .death: return "Death"
                case .temperance: return "Temperance"
                case .theDevil: return "The Devil"
                case .theTower: return "The Tower"
                case .theStar: return "The Star"
                case .theMoon: return "The Moon"
                case .theSun: return "The Sun"
                case .judgement: return "Judgement"
                case .theWorld: return "The World"
            }
        }
        public static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case (_, _) where lhs == rhs:
                    return false
                case (.theFool, _):
                    return false
                default:
                    return lhs.rawValue < rhs.rawValue
            }
        }
    }
    
    public enum Rank: Int, CardValueProtocol {
        public typealias rawValue = Int
        public typealias RawRepresentable = Int
        case ace = 0, two, three, four, five, six, seven, eight, nine, ten, page, knight, queen, king
        public var asString: String {
            switch self {
                case .ace: return "ace"
                case .two: return "two"
                case .three: return "three"
                case .four: return "four"
                case .five: return "five"
                case .six: return "six"
                case .seven: return "seven"
                case .eight: return "eight"
                case .nine: return "nine"
                case .ten: return "ten"
                case .page: return "page"
                case .knight: return "knight"
                case .queen: return "queen"
                case .king: return "king"
            }
        }
        public static func < (lhs: Self, rhs: Self) -> Bool {
            switch (lhs, rhs) {
                case (_, _) where lhs == rhs:
                    return false
                case (.ace, _):
                    return false
                default:
                    return lhs.rawValue < rhs.rawValue
            }
        }
    }
    public struct CardAspects:  Hashable {
        public let upright: String
        public let reversed: String
        
        public init(upright: String, reversed: String) {
            self.upright = upright
            self.reversed = reversed
        }

    }
}
