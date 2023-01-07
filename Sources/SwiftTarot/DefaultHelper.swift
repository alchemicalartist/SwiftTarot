//
//  File.swift
//  
//
//  Created by Chris Denton on 1/6/23.
//

import Foundation

@available(macOS 10.15, *)
@available(iOS 13.0, *)
extension SwiftTarot {
    struct DefaultHelper: TarotHelperProtocol {
        public func populateDeck() -> SwiftTarot.Deck {
            var cards: [TarotCard] = []
            Suit.minors.forEach { s in
                Rank.allCases.forEach { rank in
                    cards.append(TarotCard(suit: s, cardValue: rank))
                }
            }
            MajorCard.allCases.forEach { major in
                cards.append(TarotCard(suit: .major, cardValue: major))
            }
            return Deck(cards)
        }
    }
}
