import SwiftUI

struct MainView: View {
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

#if DEBUG
#Preview {
    let preview = Preview()
    preview.addExamples(History.sampleHistories)
    
    return MainView()
        .modelContainer(preview.modelContainer)
}
#endif
