import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CounterView()
                .tabItem {
                    Label("Counter", systemImage: "number.circle")
                }
            
            HistoryView()
                .tabItem {
                    Label("History", systemImage: "clock")
                }
        }

    }
}

#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)
    
    return ContentView()
        .modelContainer(preview.modelContainer)
}
