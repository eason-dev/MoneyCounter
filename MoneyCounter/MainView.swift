import SwiftUI

struct MainView: View {
    var body: some View {
        HistoryView()
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
