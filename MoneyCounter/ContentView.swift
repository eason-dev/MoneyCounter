import SwiftUI

struct Coin: Identifiable {
    let id = UUID()
    let name: String
    let image: String
    let value: Int
}

struct ContentView: View {
    @State private var counts: [UUID: Int] = [:]
    
    let coins = [
        Coin(name: "100", image: "dollar", value: 10000),
        Coin(name: "50", image: "dollar", value: 5000),
        Coin(name: "20", image: "dollar", value: 2000),
        Coin(name: "10", image: "dollar", value: 1000),
        Coin(name: "5", image: "dollar", value: 500),
        Coin(name: "2", image: "toonie", value: 200),
        Coin(name: "1", image: "loonie", value: 100),
        Coin(name: "0.5", image: "quarter", value: 50),
        Coin(name: "0.25", image: "quarter", value: 25),
        Coin(name: "0.1", image: "dime", value: 10),
        Coin(name: "0.05", image: "nickel", value: 5),
        Coin(name: "0.01", image: "penny", value: 1)
    ]
    
    private func subtotal(for coin: Coin) -> Double {
        let count = counts[coin.id] ?? 0
        return Double(count) * (Double(coin.value) / 100)
    }
    
    private var total: Double {
        coins.reduce(0.0) { $0 + subtotal(for: $1) }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(coins) { coin in
                    HStack {
                        Text(coin.name)
                            .font(.headline)
                            .frame(width: 80, alignment: .leading)
                        
                        Spacer()

                        Button("-") {
                            if let currentCount = counts[coin.id], currentCount > 0 {
                                counts[coin.id] = currentCount - 1
                            }
                        }
                        .padding(.horizontal, 5)
                        .buttonStyle(BorderlessButtonStyle())

                        TextField("0", text: Binding(
                            get: { String(counts[coin.id] ?? 0) },
                            set: { counts[coin.id] = Int($0) ?? 0 }
                        ))
                        .keyboardType(.numberPad)
                        .frame(width: 50)
                        .multilineTextAlignment(.center)
                        
                        Button("+") {
                            counts[coin.id] = (counts[coin.id] ?? 0) + 1
                        }
                        .padding(.horizontal, 5)
                        .buttonStyle(BorderlessButtonStyle())

                        Spacer()
                        
                        Text(String(format: "$%.2f", subtotal(for: coin)))
                            .frame(width: 80, alignment: .trailing)
                    }
                }

                HStack {
                    Spacer()
                    Text("Total: ")
                        .font(.headline)
                    Text(String(format: "$%.2f", total))
                        .font(.headline)
                        .bold()
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Coin Counter")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
