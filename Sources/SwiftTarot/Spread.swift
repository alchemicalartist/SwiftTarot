import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension SwiftTarot {
    public struct Spread: Equatable, CustomStringConvertible, Sequence, Collection {
        public typealias Iterator = Set<Element>.Iterator
        public typealias Element = SpreadPosition
        public typealias SpreadIndex = Set<Element>.Index
        fileprivate var contents: Set<Element> = []
        fileprivate let spreadType: SpreadType
        public var name: String {
            spreadType.rawValue
        }
        public var size: Int {
            spreadType.size
        }
        public init(_ n: SpreadType) {
            contents = Set(n.positions)
            spreadType = n
        }
        public subscript(position: SpreadIndex) -> Element {
            precondition(contents.indices.contains(position), "out of bounds")
            return contents[position]
        }
        public subscript(idx: SpreadIndex) -> Element? {
            contents[idx]
        }
        public var startIndex: SpreadIndex {
            contents.startIndex
        }
        public var endIndex: SpreadIndex {
            contents.endIndex
        }
        public func index(after i: SpreadIndex) -> SpreadIndex {
            contents.index(after: i)
        }
        public func makeIterator() -> Iterator {
            contents.makeIterator()
        }
        public var description: String {
            var res = "***** Contents of Spread: \(contents.count) cards  *****\n"
            contents.forEach { pos in
                res += "\(pos.description): " + "\n"
            }
            return res
        }
    }
    public struct SpreadPosition: CustomStringConvertible, Hashable, Identifiable {
        public var id: AnyHashable {
            name.hashValue
        }
        public let name: String
        public var order: Int
        public var description: String
    }
    
    public enum SpreadType: CaseIterable, RawRepresentable, Identifiable {
        public typealias RawValue = String
        case none, celticcross, chakra, eagle, fiveCardSitch, threeCardSitch, oneCardDaily
        public init?(rawValue: String) {
            switch rawValue {
                case "none": self = .none
                case "celtic cross": self = .celticcross
                case "chakra": self = .chakra
                case "eagle": self = .eagle
                case "five card situational": self = .fiveCardSitch
                case "three card situational": self = .threeCardSitch
                case "one card random": self = .oneCardDaily
                default: self = .none
            }
        }
        public var id: AnyHashable {
            self.rawValue.hashValue
        }
        public var rawValue: String {
            switch self {
                case .none: return "none"
                case .celticcross: return "celtic cross"
                case .chakra: return "chakra"
                case .eagle: return "eagle"
                case .fiveCardSitch: return "five card situational"
                case .threeCardSitch: return "three card situational"
                case .oneCardDaily: return "one card random"
            }
        }
        public var size: Int {
            switch self {
                case .none: return 0
                case .celticcross: return 10
                case .chakra: return 7
                case .eagle: return 9
                case .fiveCardSitch: return 5
                case .threeCardSitch: return 3
                case .oneCardDaily: return 1
            }
        }
        public var positions: [SpreadPosition] {
            switch self {
                case .none: return Array<SpreadPosition>()
                case .celticcross: return [
                    SpreadPosition(name: "Context", order: 0, description: "context card"),
                    SpreadPosition(name: "Cross", order: 1, description: "crossing energies"),
                    SpreadPosition(name: "Sub-Conscious", order: 2, description: "sub-conscious influences"),
                    SpreadPosition(name: "Conscious", order: 3, description: "conscious thoughts"),
                    SpreadPosition(name: "Past", order: 4, description: "past influencing energies"),
                    SpreadPosition(name: "Future", order: 5, description: "future influencing energies"),
                    SpreadPosition(name: "Querant", order: 6, description: "questioner's influencing ways of being"),
                    SpreadPosition(name: "Environment", order: 7, description: "surrounding energies"),
                    SpreadPosition(name: "Hopes/Fears", order: 8, description: "that which is clung to or resisted"),
                    SpreadPosition(name: "Potential Outcome", order: 9, description: "potential outcome of this situation")
                ]
                case .chakra: return [
                    SpreadPosition(name: "Root", order: 0, description: "energies affecting your root chakra"),
                    SpreadPosition(name: "Sacral", order: 1, description: "energies affecting your sacral chakra"),
                    SpreadPosition(name: "Solar Plexus", order: 2, description: "energies affecting your Solar Plexus"),
                    SpreadPosition(name: "Heart", order: 3, description: "energies affecting your heart chakra"),
                    SpreadPosition(name: "Throat", order: 4, description: "energies affecting your throat chakra"),
                    SpreadPosition(name: "3rd Eye", order: 5, description: "energies affecting your 3rd Eye"),
                    SpreadPosition(name: "Crown", order: 6, description: "energies affecting your crownchakra")
                ]
                case .eagle: return [
                    SpreadPosition(name: "First Challenge", order: 0, description: "first challenge"),
                    SpreadPosition(name: "Second Challenge", order: 1, description: "second challenge"),
                    SpreadPosition(name: "First Gift", order: 2, description: "the gift that the first challenge brings"),
                    SpreadPosition(name: "Second Gift", order: 3, description: "the gift that the second challenge brings"),
                    SpreadPosition(name: "First Shift", order: 4, description: "the shift you need in order to receive the first gift"),
                    SpreadPosition(name: "Second Shift", order: 5, description: "the shift you need in order to receive the second gift"),
                    SpreadPosition(name: "Sign of Shift", order: 6, description: "what you will be experiencing if the shift is under way"),
                    SpreadPosition(name: "Sign to Shift", order: 7, description: "what you will be experiencing if you still need to find the shift"),
                    SpreadPosition(name: "Potential Outcome", order: 8, description: "the potential outcome of these situations")
                ]
                case .fiveCardSitch: return [
                    SpreadPosition(name: "Situation", order: 0, description: "the situation that this reading is about"),
                    SpreadPosition(name: "Challenge", order: 1, description: "the energies which are creating a challenge for you in this situation"),
                    SpreadPosition(name: "Action", order: 2, description: "the action you get to be in to shift this situation"),
                    SpreadPosition(name: "Focus", order: 3, description: "A focus which will support you in this action"),
                    SpreadPosition(name: "Potential Outcome", order: 4, description: "the potential outcome of this situation")
                ]
                case .threeCardSitch: return [
                    SpreadPosition(name: "Situation", order: 0, description: "the situation that this reading is about"),
                    SpreadPosition(name: "Action", order: 1, description: "the action you get to be in to shift this situation"),
                    SpreadPosition(name: "Potential Outcome", order: 2, description: "the potential outcome of this situation")
                ]
                case .oneCardDaily: return [SpreadPosition(name: "Daily Energies", order: 0, description: "energies affecting your day")]
            }
        }
    }
}
