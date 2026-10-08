import SwiftUI

private enum ChatPlatform {
    case iPhone
    case android
}

private struct Chat: Identifiable {
    let id = UUID()
    var name: String
    var preview: String
    var time: String
    var initials: String
    var color: Color
    var platform: ChatPlatform
    var unread = false
    var messages: [ChatMessage]
}

private struct ChatMessage: Identifiable {
    let id = UUID()
    var text: String
    var isOutgoing: Bool
    var platform: ChatPlatform
}

struct MessagesListView: View {
    @State private var searchText = ""
    @State private var selectedChat: Chat?
    @State private var showingCompose = false
    @State private var chats: [Chat] = [
        Chat(name: "Alex Morgan", preview: "That sounds good! See you then.", time: "now",
             initials: "AM", color: .blue, platform: .iPhone, unread: true,
             messages: [
                ChatMessage(text: "Hey! Are we still meeting later?", isOutgoing: false, platform: .iPhone),
                ChatMessage(text: "Yep, see you at 4!", isOutgoing: true, platform: .iPhone),
                ChatMessage(text: "That sounds good! See you then.", isOutgoing: false, platform: .iPhone)
             ]),
        Chat(name: "Jordan Lee (Android)", preview: "Sent you the photo", time: "9:41 AM",
             initials: "JL", color: .orange, platform: .android,
             messages: [
                ChatMessage(text: "Did you get my last message?", isOutgoing: false, platform: .android),
                ChatMessage(text: "Just got it 👍", isOutgoing: true, platform: .iPhone),
                ChatMessage(text: "Sent you the photo", isOutgoing: false, platform: .android)
             ]),
        Chat(name: "Family Group", preview: "Mom: Don't forget your bag!", time: "Yesterday",
             initials: "FG", color: .purple, platform: .iPhone,
             messages: [
                ChatMessage(text: "What time are we leaving?", isOutgoing: true, platform: .iPhone),
                ChatMessage(text: "Don't forget your bag!", isOutgoing: false, platform: .iPhone)
             ]),
        Chat(name: "Sam Rivera", preview: "Thanks!!", time: "Tuesday",
             initials: "SR", color: .pink, platform: .iPhone,
             messages: [
                ChatMessage(text: "I sent you the notes.", isOutgoing: true, platform: .iPhone),
                ChatMessage(text: "Thanks!!", isOutgoing: false, platform: .iPhone)
             ])
    ]

    private var filteredChats: [Chat] {
        guard !searchText.isEmpty else { return chats }
        return chats.filter { $0.name.localizedCaseInsensitiveContains(searchText) || $0.preview.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredChats) { chat in
                    Button {
                        selectedChat = chat
                    } label: {
                        ChatRow(chat: chat)
                    }
                    .buttonStyle(.plain)
                    .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .safeAreaInset(edge: .top, spacing: 0) {
                VStack(spacing: 8) {
                    HStack(alignment: .firstTextBaseline) {
                        Button("Edit") {}
                            .font(.system(size: 17))
                        Spacer()
                        Text("Messages")
                            .font(.system(size: 17, weight: .semibold))
                        Spacer()
                        Button {
                            showingCompose = true
                        } label: {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 21, weight: .regular))
                        }
                        .accessibilityLabel("New message")
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)

                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .foregroundStyle(.secondary)
                        TextField("Search", text: $searchText)
                            .font(.system(size: 17))
                        if !searchText.isEmpty {
                            Button {
                                searchText = ""
                            } label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding(.horizontal, 9)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                }
                .background(Color(.systemBackground))
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedChat) { chat in
                ConversationView(chat: chat) { updatedChat in
                    if let index = chats.firstIndex(where: { $0.id == updatedChat.id }) {
                        chats[index] = updatedChat
                    }
                }
            }
            .sheet(isPresented: $showingCompose) {
                ComposeMessageView { name, text, platform in
                    let newChat = Chat(
                        name: name,
                        preview: text,
                        time: "now",
                        initials: String(name.split(separator: " ").prefix(2).compactMap(\.first)),
                        color: .blue,
                        platform: platform,
                        messages: [ChatMessage(text: text, isOutgoing: true, platform: .iPhone)]
                    )
                    chats.insert(newChat, at: 0)
                    showingCompose = false
                    selectedChat = newChat
                }
            }
        }
        .tint(Color(red: 0.0, green: 0.48, blue: 1.0))
    }
}

private struct ChatRow: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle().fill(chat.color.gradient)
                Text(chat.initials)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)

            VStack(alignment: .leading, spacing: 5) {
                HStack(spacing: 6) {
                    Text(chat.name)
                        .font(.system(size: 17, weight: chat.unread ? .semibold : .regular))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                    Spacer(minLength: 4)
                    Text(chat.time)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                }
                HStack(spacing: 6) {
                    Text(chat.preview)
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(.tertiaryLabel))
                }
            }
        }
        .contentShape(Rectangle())
    }
}

private struct ConversationView: View {
    @Environment(\.dismiss) private var dismiss
    @State var chat: Chat
    @State private var draft = ""
    var onUpdate: (Chat) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        Text("iClassicMsg")
                            .font(.system(size: 12))
                            .foregroundStyle(.secondary)
                            .padding(.top, 14)
                        ForEach(chat.messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: chat.messages.count) {
                    if let last = chat.messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }

            Divider()
            HStack(alignment: .bottom, spacing: 9) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 27, weight: .regular))
                    .foregroundStyle(.secondary)
                TextField("iMessage", text: $draft, axis: .vertical)
                    .lineLimit(1...5)
                    .font(.system(size: 16))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .overlay(Capsule().stroke(Color(.systemGray3), lineWidth: 1))
                Button {
                    sendMessage()
                } label: {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 29))
                        .foregroundStyle(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color(.systemGray3) : Color(red: 0, green: 0.48, blue: 1))
                }
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Color(.systemBackground))
        }
        .background(Color(.systemBackground))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack(spacing: 2) {
                    Circle().fill(chat.color.gradient).frame(width: 30, height: 30)
                        .overlay(Text(chat.initials).font(.system(size: 10, weight: .semibold)).foregroundStyle(.white))
                    Text(chat.name)
                        .font(.system(size: 12))
                        .foregroundStyle(.primary)
                }
            }
        }
    }

    private func sendMessage() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        chat.messages.append(ChatMessage(text: text, isOutgoing: true, platform: .iPhone))
        chat.preview = text
        chat.time = "now"
        draft = ""
        onUpdate(chat)
    }
}

private struct MessageBubble: View {
    let message: ChatMessage

    private var bubbleColor: Color {
        if message.isOutgoing { return Color(red: 0.0, green: 0.48, blue: 1.0) }
        return message.platform == .android ? Color(red: 0.20, green: 0.68, blue: 0.36) : Color(.systemGray5)
    }

    var body: some View {
        HStack {
            if message.isOutgoing { Spacer(minLength: 56) }
            Text(message.text)
                .font(.system(size: 16))
                .foregroundStyle(message.isOutgoing || message.platform == .android ? .white : .primary)
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(bubbleColor)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            if !message.isOutgoing { Spacer(minLength: 56) }
        }
        .frame(maxWidth: .infinity)
    }
}

private struct ComposeMessageView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var recipient = ""
    @State private var message = ""
    @State private var isAndroid = false
    var onSend: (String, String, ChatPlatform) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("To:") {
                    TextField("Name", text: $recipient)
                    Toggle("Android contact", isOn: $isAndroid)
                }
                Section("Message") {
                    TextField("Text message", text: $message, axis: .vertical)
                        .lineLimit(2...5)
                }
            }
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Send") {
                        let name = recipient.trimmingCharacters(in: .whitespacesAndNewlines)
                        let text = message.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !name.isEmpty, !text.isEmpty else { return }
                        onSend(name, text, isAndroid ? .android : .iPhone)
                    }
                    .disabled(recipient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}