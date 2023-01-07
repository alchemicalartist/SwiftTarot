
# Swift Tarot

A helper library for tarot apps written in Swift



[![MIT License](https://img.shields.io/static/v1?style=for-the-badge&label=license&message=MIT&color=cyan&labelColor=orange)](https://choosealicense.com/licenses/mit/)


## Deployment

To use this package, import with Swift Package Manager and then import SwiftTarot.

NOTE: You must impletement a structure which complies to the TarotHelperProtocol if you want to have descriptions and keywords available for your deck.

```swift
import SwiftUI
import SwiftTarot

struct tarotHelper: TarotHelperProtocol {
    public func populateDeck() -> SwiftTarot.Deck {
        //data fetching method to instatiate SwiftTarot.TarotCards and your Deck
    }
}

@main
struct MyApp: App {
    @StateObject var tarot = SwiftTarot(helper: tarotHelper())
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(tarot)
        }
    }
}


struct AnotherView: View {
    @EnvironmentObject var tarot
    @State var spread: SwiftTarot.SpreadType {
        didSet: {
            tarot.setSpread(spread)
        }
    }
    var body: some View {
        VStack {
            Picker("Choose your spread", selection: $spread) {
                ForEach(SwiftTarot.SpreadType.allCases, id:\.self) { st in
                    Text("\(String(describing: st))").tag(st)
                }
            }
            if spread != .none {
                Button(action: {
                    spreadView()
                }, label: {
                    Text("Present Spread)
                })
            }
        }
    }
}
```


## Contributing

Contributions are always welcome!

See `contributing.md` for ways to get started.

Please adhere to this project's `code of conduct`.

