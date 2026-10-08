import SwiftUI
import FirebaseCore

@main
struct iClassicMsgApp: App {
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            MessagesListView()
                .preferredColorScheme(.light)
        }
    }
}
