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
        return chats.filter {
            $0.name.localizedCaseInsensitiveContains(searchText) ||
            $0.preview.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        Group {
            if let chat = selectedChat {
                ConversationView(
                    chat: chat,
                    onBack: { selectedChat = nil },
                    onUpdate: updateChat
                )
            } else if showingCompose {
                ComposeMessageView(
                    onCancel: { showingCompose = false },
                    onSend: createConversation
                )
            } else {
                messagesHome
            }
        }
        .tint(Color(red: 0.0, green: 0.48, blue: 1.0))
        .background(Color.white.ignoresSafeArea())
        .preferredColorScheme(.light)
    }

    private var messagesHome: some View {
        VStack(spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Button("Edit") {}
                    .font(.system(size: 17))
                Spacer()
                Text("Messages")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
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
            .padding(.bottom, 12)

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(Color.gray)
                TextField("Search", text: $searchText)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                if !searchText.isEmpty {
                    Button {
                        searchText = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(Color.gray)
                    }
                }
            }
            .padding(.horizontal, 9)
            .padding(.vertical, 8)
            .background(Color(red: 0.93, green: 0.93, blue: 0.95))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredChats) { chat in
                        Button {
                            selectedChat = chat
                        } label: {
                            ChatRow(chat: chat)
                        }
                        .buttonStyle(.plain)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)

                        Divider()
                            .padding(.leading, 80)
                    }
                }
            }
        }
        .background(Color.white)
    }

    private func updateChat(_ updatedChat: Chat) {
        if let index = chats.firstIndex(where: { $0.id == updatedChat.id }) {
            chats[index] = updatedChat
        }
        selectedChat = updatedChat
    }

    private func createConversation(name: String, text: String, platform: ChatPlatform) {
        let initials = String(name.split(separator: " ").prefix(2).compactMap(\.first))
        let newChat = Chat(
            name: name,
            preview: text,
            time: "now",
            initials: initials.isEmpty ? "?" : initials,
            color: .blue,
            platform: platform,
            messages: [ChatMessage(text: text, isOutgoing: true, platform: .iPhone)]
        )
        chats.insert(newChat, at: 0)
        showingCompose = false
        selectedChat = newChat
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
                        .foregroundStyle(.black)
                        .lineLimit(1)
                    Spacer(minLength: 4)
                    Text(chat.time)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.gray)
                }
                HStack(spacing: 6) {
                    Text(chat.preview)
                        .font(.system(size: 15))
                        .foregroundStyle(Color.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(white: 0.78))
                }
            }
        }
        .contentShape(Rectangle())
    }
}

private struct ConversationView: View {
    let chat: Chat
    var onBack: () -> Void
    var onUpdate: (Chat) -> Void
    @State private var messages: [ChatMessage]
    @State private var draft = ""

    init(chat: Chat, onBack: @escaping () -> Void, onUpdate: @escaping (Chat) -> Void) {
        self.chat = chat
        self.onBack = onBack
        self.onUpdate = onUpdate
        _messages = State(initialValue: chat.messages)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: onBack) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .medium))
                        Text("Messages")
                            .font(.system(size: 17))
                    }
                }
                Spacer()
                VStack(spacing: 3) {
                    Circle().fill(chat.color.gradient)
                        .frame(width: 34, height: 34)
                        .overlay(
                            Text(chat.initials)
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundStyle(.white)
                        )
                    Text(chat.name)
                        .font(.system(size: 12))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                }
                Spacer()
                Button {} label: {
                    Image(systemName: "video")
                        .font(.system(size: 20))
                }
                .accessibilityLabel("Video call")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.white)

            Divider()

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(spacing: 10) {
                        Text("iClassicMsg")
                            .font(.system(size: 12))
                            .foregroundStyle(Color.gray)
                            .padding(.top, 14)
                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                }
                .onChange(of: messages.count) {
                    if let last = messages.last { proxy.scrollTo(last.id, anchor: .bottom) }
                }
            }
            .background(Color.white)

            Divider()
            HStack(alignment: .bottom, spacing: 9) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 27))
                    .foregroundStyle(Color.gray)
                TextField("iMessage", text: $draft, axis: .vertical)
                    .lineLimit(1...5)
                    .font(.system(size: 16))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 9)
                    .overlay(Capsule().stroke(Color(white: 0.78), lineWidth: 1))
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 29))
                        .foregroundStyle(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? Color(white: 0.78) : Color(red: 0, green: 0.48, blue: 1))
                }
                .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 9)
            .background(Color.white)
        }
        .background(Color.white)
    }

    private func sendMessage() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        messages.append(ChatMessage(text: text, isOutgoing: true, platform: .iPhone))
        draft = ""
        var updated = chat
        updated.messages = messages
        updated.preview = text
        updated.time = "now"
        onUpdate(updated)
    }
}

private struct MessageBubble: View {
    let message: ChatMessage

    private var bubbleColor: Color {
        if message.isOutgoing { return Color(red: 0.0, green: 0.48, blue: 1.0) }
        return message.platform == .android ? Color(red: 0.20, green: 0.68, blue: 0.36) : Color(white: 0.91)
    }

    var body: some View {
        HStack {
            if message.isOutgoing { Spacer(minLength: 56) }
            Text(message.text)
                .font(.system(size: 16))
                .foregroundStyle(message.isOutgoing || message.platform == .android ? .white : .black)
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
    var onCancel: () -> Void
    var onSend: (String, String, ChatPlatform) -> Void
    @State private var recipient = ""
    @State private var message = ""
    @State private var isAndroid = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button("Cancel", action: onCancel)
                    .font(.system(size: 17))
                Spacer()
                Text("New Message")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.black)
                Spacer()
                Button("Send") {
                    let name = recipient.trimmingCharacters(in: .whitespacesAndNewlines)
                    let text = message.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty, !text.isEmpty else { return }
                    onSend(name, text, isAndroid ? .android : .iPhone)
                }
                .font(.system(size: 17, weight: .semibold))
                .disabled(recipient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)
            Divider()
            FormFieldRow(label: "To:") {
                TextField("Name", text: $recipient)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
            }
            Divider()
            Toggle(isOn: $isAndroid) {
                Text("Android contact")
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
            }
            .tint(Color(red: 0.0, green: 0.48, blue: 1.0))
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            Divider()
            TextField("Text message", text: $message, axis: .vertical)
                .lineLimit(3...8)
                .font(.system(size: 17))
                .foregroundStyle(.black)
                .padding(16)
            Spacer()
        }
        .background(Color.white)
    }
}

private struct FormFieldRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .foregroundStyle(Color.gray)
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}