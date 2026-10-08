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

private enum ClassicMessagesStyle {
    static let blue = Color(red: 0.0, green: 0.478, blue: 1.0)
    static let green = Color(red: 0.20, green: 0.68, blue: 0.36)
    static let separator = Color(white: 0.86)
    static let search = Color(red: 0.94, green: 0.94, blue: 0.96)
    static let secondary = Color(white: 0.48)
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
        ZStack {
            Color.white.ignoresSafeArea()

            Group {
                if let chat = selectedChat {
                    ConversationView(
                        chat: chat,
                        onBack: {
                            withAnimation(.easeInOut(duration: 0.24)) {
                                selectedChat = nil
                            }
                        },
                        onUpdate: updateChat
                    )
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                } else if showingCompose {
                    ComposeMessageView(
                        onCancel: {
                            withAnimation(.easeInOut(duration: 0.22)) {
                                showingCompose = false
                            }
                        },
                        onSend: createConversation
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                } else {
                    messagesHome
                        .transition(.opacity)
                }
            }
        }
        .tint(ClassicMessagesStyle.blue)
        .foregroundStyle(.black)
        .preferredColorScheme(.light)
    }

    private var messagesHome: some View {
        VStack(spacing: 0) {
            HStack(alignment: .center) {
                Button("Edit") {}
                    .font(.system(size: 17))
                    .foregroundStyle(ClassicMessagesStyle.blue)

                Spacer()

                Button {
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                        showingCompose = true
                    }
                } label: {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 21, weight: .regular))
                        .frame(width: 34, height: 34)
                        .contentShape(Rectangle())
                }
                .accessibilityLabel("New message")
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)

            HStack {
                Text("Messages")
                    .font(.system(size: 34, weight: .bold, design: .default))
                    .tracking(0.25)
                Spacer()
            }
            .padding(.horizontal, 18)
            .padding(.top, 8)
            .padding(.bottom, 12)

            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundStyle(ClassicMessagesStyle.secondary)

                TextField("Search", text: $searchText)
                    .font(.system(size: 17))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .submitLabel(.search)

                if !searchText.isEmpty {
                    Button {
                        withAnimation(.easeOut(duration: 0.18)) {
                            searchText = ""
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color(white: 0.65))
                    }
                    .transition(.scale.combined(with: .opacity))
                    .accessibilityLabel("Clear search")
                }
            }
            .padding(.horizontal, 10)
            .frame(height: 36)
            .background(ClassicMessagesStyle.search)
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .padding(.horizontal, 16)
            .padding(.bottom, 8)

            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(filteredChats) { chat in
                        Button {
                            withAnimation(.spring(response: 0.38, dampingFraction: 0.9)) {
                                selectedChat = chat
                            }
                        } label: {
                            ChatRow(chat: chat)
                        }
                        .buttonStyle(.plain)
                        .padding(.leading, 16)
                        .padding(.trailing, 18)
                        .padding(.vertical, 9)
                        .contentShape(Rectangle())
                        .transition(.asymmetric(
                            insertion: .move(edge: .top).combined(with: .opacity),
                            removal: .opacity
                        ))

                        Rectangle()
                            .fill(ClassicMessagesStyle.separator.opacity(0.85))
                            .frame(height: 0.5)
                            .padding(.leading, 82)
                    }
                }
                .animation(.easeInOut(duration: 0.2), value: searchText)
            }
            .scrollIndicators(.hidden)
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
        withAnimation(.spring(response: 0.38, dampingFraction: 0.88)) {
            chats.insert(newChat, at: 0)
            showingCompose = false
            selectedChat = newChat
        }
    }
}

private struct ChatRow: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(chat.color.gradient)
                Text(chat.initials)
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white)
            }
            .frame(width: 52, height: 52)
            .overlay(Circle().stroke(Color.black.opacity(0.035), lineWidth: 0.5))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text(chat.name)
                        .font(.system(size: 17, weight: chat.unread ? .semibold : .regular))
                        .foregroundStyle(.black)
                        .lineLimit(1)

                    Spacer(minLength: 4)

                    Text(chat.time)
                        .font(.system(size: 14))
                        .foregroundStyle(ClassicMessagesStyle.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 5) {
                    if chat.unread {
                        Circle()
                            .fill(ClassicMessagesStyle.blue)
                            .frame(width: 7, height: 7)
                            .transition(.scale.combined(with: .opacity))
                    }

                    Text(chat.preview)
                        .font(.system(size: 15))
                        .foregroundStyle(ClassicMessagesStyle.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Spacer(minLength: 0)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color(white: 0.78))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }
}

private struct ConversationView: View {
    let chat: Chat
    var onBack: () -> Void
    var onUpdate: (Chat) -> Void
    @State private var messages: [ChatMessage]
    @State private var draft = ""
    @State private var showingAttachments = false
    @FocusState private var composerFocused: Bool

    init(chat: Chat, onBack: @escaping () -> Void, onUpdate: @escaping (Chat) -> Void) {
        self.chat = chat
        self.onBack = onBack
        self.onUpdate = onUpdate
        _messages = State(initialValue: chat.messages)
    }

    var body: some View {
        VStack(spacing: 0) {
            conversationHeader

            Rectangle()
                .fill(ClassicMessagesStyle.separator.opacity(0.65))
                .frame(height: 0.5)

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 9) {
                        Text("iMessage")
                            .font(.system(size: 12))
                            .foregroundStyle(ClassicMessagesStyle.secondary)
                            .padding(.top, 14)
                            .padding(.bottom, 3)

                        ForEach(messages) { message in
                            MessageBubble(message: message)
                                .id(message.id)
                                .transition(.asymmetric(
                                    insertion: .scale(scale: 0.88, anchor: message.isOutgoing ? .bottomTrailing : .bottomLeading)
                                        .combined(with: .opacity),
                                    removal: .opacity
                                ))
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                }
                .scrollIndicators(.hidden)
                .onChange(of: messages.count) {
                    guard let last = messages.last else { return }
                    withAnimation(.spring(response: 0.36, dampingFraction: 0.86)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
            .background(Color.white)

            if showingAttachments {
                attachmentTray
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            Rectangle()
                .fill(ClassicMessagesStyle.separator.opacity(0.65))
                .frame(height: 0.5)

            composer
        }
        .background(Color.white)
        .animation(.spring(response: 0.32, dampingFraction: 0.88), value: showingAttachments)
    }

    private var conversationHeader: some View {
        HStack(alignment: .center) {
            Button(action: onBack) {
                HStack(spacing: 4) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 20, weight: .medium))
                    Text("Messages")
                        .font(.system(size: 17))
                }
                .foregroundStyle(ClassicMessagesStyle.blue)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Spacer(minLength: 4)

            VStack(spacing: 4) {
                Circle()
                    .fill(chat.color.gradient)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(chat.initials)
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.white)
                    )
                HStack(spacing: 4) {
                    Text(chat.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.black)
                        .lineLimit(1)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(ClassicMessagesStyle.secondary)
                }
                .frame(maxWidth: 150)
            }
            .frame(maxWidth: .infinity)

            Spacer(minLength: 4)

            Button {} label: {
                Image(systemName: "video")
                    .font(.system(size: 20, weight: .regular))
                    .frame(width: 30, height: 36)
            }
            .accessibilityLabel("Video call")
        }
        .padding(.horizontal, 12)
        .padding(.top, 6)
        .padding(.bottom, 8)
        .background(Color.white)
    }

    private var composer: some View {
        HStack(alignment: .bottom, spacing: 9) {
            Button {
                composerFocused = false
                withAnimation(.spring(response: 0.32, dampingFraction: 0.86)) {
                    showingAttachments.toggle()
                }
            } label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 29, weight: .regular))
                    .foregroundStyle(ClassicMessagesStyle.secondary)
                    .rotationEffect(.degrees(showingAttachments ? 45 : 0))
                    .frame(width: 31, height: 35)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(showingAttachments ? "Hide attachments" : "Show attachments")

            TextField("iMessage", text: $draft, axis: .vertical)
                .lineLimit(1...5)
                .font(.system(size: 16))
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(Color.white)
                .overlay(Capsule().stroke(Color(white: 0.78), lineWidth: 1))
                .focused($composerFocused)
                .submitLabel(.send)
                .onSubmit(sendMessage)

            Button(action: sendMessage) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 29))
                    .foregroundStyle(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                                     ? Color(white: 0.78)
                                     : ClassicMessagesStyle.blue)
                    .scaleEffect(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.94 : 1)
                    .frame(width: 31, height: 35)
            }
            .buttonStyle(.plain)
            .disabled(draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .animation(.spring(response: 0.24, dampingFraction: 0.65), value: draft.isEmpty)
            .accessibilityLabel("Send message")
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 9)
        .background(Color.white)
    }

    private var attachmentTray: some View {
        VStack(spacing: 0) {
            attachmentRow("Camera", symbol: "camera.fill", color: .gray)
            attachmentRow("Photos", symbol: "photo.on.rectangle", color: .green)
            attachmentRow("Stickers", symbol: "face.smiling", color: .orange)
            attachmentRow("Location", symbol: "location.fill", color: .blue)
        }
        .padding(.vertical, 6)
        .background(Color.white)
    }

    private func attachmentRow(_ title: String, symbol: String, color: Color) -> some View {
        Button {} label: {
            HStack(spacing: 13) {
                RoundedRectangle(cornerRadius: 9, style: .continuous)
                    .fill(color.gradient)
                    .frame(width: 34, height: 34)
                    .overlay(
                        Image(systemName: symbol)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.white)
                    )
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(white: 0.72))
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 7)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    private func sendMessage() {
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }

        let newMessage = ChatMessage(text: text, isOutgoing: true, platform: .iPhone)
        withAnimation(.spring(response: 0.34, dampingFraction: 0.78)) {
            messages.append(newMessage)
            draft = ""
            showingAttachments = false
        }

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
        if message.isOutgoing { return ClassicMessagesStyle.blue }
        return message.platform == .android ? ClassicMessagesStyle.green : Color(white: 0.91)
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
                .frame(maxWidth: 290, alignment: message.isOutgoing ? .trailing : .leading)

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
    @FocusState private var recipientFocused: Bool

    private var canSend: Bool {
        !recipient.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

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
                    guard canSend else { return }
                    onSend(name, text, isAndroid ? .android : .iPhone)
                }
                .font(.system(size: 17, weight: .semibold))
                .disabled(!canSend)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.white)

            Rectangle()
                .fill(ClassicMessagesStyle.separator.opacity(0.7))
                .frame(height: 0.5)

            FormFieldRow(label: "To:") {
                TextField("Name or number", text: $recipient)
                    .font(.system(size: 17))
                    .focused($recipientFocused)
                    .textContentType(.name)
            }

            Rectangle()
                .fill(ClassicMessagesStyle.separator.opacity(0.7))
                .frame(height: 0.5)

            Toggle(isOn: $isAndroid) {
                Text("Android contact")
                    .font(.system(size: 16))
                    .foregroundStyle(.black)
            }
            .tint(ClassicMessagesStyle.blue)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            Rectangle()
                .fill(ClassicMessagesStyle.separator.opacity(0.7))
                .frame(height: 0.5)

            TextField("Text message", text: $message, axis: .vertical)
                .lineLimit(3...8)
                .font(.system(size: 17))
                .padding(16)
                .submitLabel(.send)

            Spacer()
        }
        .background(Color.white)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                recipientFocused = true
            }
        }
    }
}

private struct FormFieldRow<Content: View>: View {
    let label: String
    @ViewBuilder var content: Content

    var body: some View {
        HStack(spacing: 12) {
            Text(label)
                .foregroundStyle(ClassicMessagesStyle.secondary)
            content
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.white)
    }
}