import SwiftUI

@main
struct iClassicMsgApp: App {
    var body: some Scene {
        WindowGroup {
            MessagesListView()
                .preferredColorScheme(.light)
        }
    }
}