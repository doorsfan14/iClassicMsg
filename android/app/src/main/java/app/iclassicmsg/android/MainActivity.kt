package app.iclassicmsg.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.BasicTextField
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.ArrowBack
import androidx.compose.material.icons.filled.Search
import androidx.compose.material.icons.filled.Send
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.TextButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.getValue
import androidx.compose.runtime.setValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

private data class ChatMessage(val text: String, val outgoing: Boolean, val fromAndroid: Boolean)

private data class Conversation(
    val id: Int,
    val name: String,
    val preview: String,
    val time: String,
    val color: Color,
    val messages: List<ChatMessage>
)

private val seedConversations = listOf(
    Conversation(1, "Alex Morgan", "That sounds good! See you then.", "now", Color(0xFF4285F4), listOf(
        ChatMessage("Hey! Are we still meeting later?", false, false),
        ChatMessage("Yep, see you at 4!", true, false),
        ChatMessage("That sounds good! See you then.", false, false)
    )),
    Conversation(2, "Jordan Lee", "Sent you the photo", "9:41 AM", Color(0xFFEA8B32), listOf(
        ChatMessage("Did you get my last message?", false, true),
        ChatMessage("Just got it 👍", true, false),
        ChatMessage("Sent you the photo", false, true)
    )),
    Conversation(3, "Family Group", "Mom: Don't forget your bag!", "Yesterday", Color(0xFF8E63CE), listOf(
        ChatMessage("What time are we leaving?", true, false),
        ChatMessage("Don't forget your bag!", false, false)
    )),
    Conversation(4, "Sam Rivera", "Thanks!!", "Tuesday", Color(0xFFDE6A9A), listOf(
        ChatMessage("I sent you the notes.", true, false),
        ChatMessage("Thanks!!", false, false)
    ))
)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(modifier = Modifier.fillMaxSize(), color = Color(0xFFF8F9FA)) {
                    iClassicMsgApp()
                }
            }
        }
    }
}

@Composable
private fun iClassicMsgApp() {
    val conversations = remember { mutableStateListOf<Conversation>().apply { addAll(seedConversations) } }
    var selectedConversationId by remember { mutableStateOf<Int?>(null) }
    var query by remember { mutableStateOf("") }
    var showingNewConversation by remember { mutableStateOf(false) }
    var newRecipient by remember { mutableStateOf("") }
    var firstMessage by remember { mutableStateOf("") }
    val selected = conversations.firstOrNull { it.id == selectedConversationId }

    if (selected == null) {
        Box(modifier = Modifier.fillMaxSize()) {
            Column(modifier = Modifier.fillMaxSize()) {
                Text(
                    text = "iClassicMsg",
                    fontSize = 29.sp,
                    fontWeight = FontWeight.Bold,
                    color = Color(0xFF202124),
                    modifier = Modifier.padding(start = 22.dp, top = 24.dp, bottom = 14.dp)
                )
                TextField(
                    value = query,
                    onValueChange = { query = it },
                    modifier = Modifier.fillMaxWidth().padding(horizontal = 16.dp),
                    placeholder = { Text("Search conversations") },
                    leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                    singleLine = true,
                    shape = RoundedCornerShape(28.dp),
                    colors = TextFieldDefaults.colors(
                        focusedContainerColor = Color(0xFFE9EDF2),
                        unfocusedContainerColor = Color(0xFFE9EDF2),
                        focusedIndicatorColor = Color.Transparent,
                        unfocusedIndicatorColor = Color.Transparent
                    )
                )
                LazyColumn(modifier = Modifier.padding(top = 8.dp)) {
                    items(conversations.filter {
                        it.name.contains(query, ignoreCase = true) || it.preview.contains(query, ignoreCase = true)
                    }, key = { it.id }) { conversation ->
                        ConversationRow(conversation) { selectedConversationId = conversation.id }
                    }
                }
            }
            FloatingActionButton(
                onClick = { showingNewConversation = true },
                modifier = Modifier.align(Alignment.BottomEnd).padding(22.dp),
                containerColor = Color(0xFF1A73E8),
                contentColor = Color.White
            ) {
                Icon(Icons.Default.Add, contentDescription = "New conversation")
            }
        }
    } else {
        ConversationScreen(
            conversation = selected,
            onBack = { selectedConversationId = null },
            onSend = { text ->
                val updated = selected.copy(
                    preview = text,
                    time = "now",
                    messages = selected.messages + ChatMessage(text, outgoing = true, fromAndroid = false)
                )
                val index = conversations.indexOfFirst { it.id == selected.id }
                if (index >= 0) conversations[index] = updated
            }
        )
    }

    if (selected == null && showingNewConversation) {
        AlertDialog(
            onDismissRequest = { showingNewConversation = false },
            title = { Text("New conversation") },
            text = {
                Column(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                    androidx.compose.material3.OutlinedTextField(
                        value = newRecipient,
                        onValueChange = { newRecipient = it },
                        label = { Text("Contact name") },
                        singleLine = true
                    )
                    androidx.compose.material3.OutlinedTextField(
                        value = firstMessage,
                        onValueChange = { firstMessage = it },
                        label = { Text("First message") }
                    )
                }
            },
            confirmButton = {
                TextButton(onClick = {
                    val name = newRecipient.trim()
                    val message = firstMessage.trim()
                    if (name.isNotEmpty() && message.isNotEmpty()) {
                        val newId = (conversations.maxOfOrNull { it.id } ?: 0) + 1
                        val created = Conversation(
                            newId, name, message, "now", Color(0xFF4285F4),
                            listOf(ChatMessage(message, outgoing = true, fromAndroid = false))
                        )
                        conversations.add(0, created)
                        selectedConversationId = newId
                        newRecipient = ""
                        firstMessage = ""
                        showingNewConversation = false
                    }
                }) { Text("Create") }
            },
            dismissButton = {
                TextButton(onClick = { showingNewConversation = false }) { Text("Cancel") }
            }
        )
    }
}

@Composable
private fun ConversationRow(conversation: Conversation, onClick: () -> Unit) {
    Row(
        modifier = Modifier.fillMaxWidth().clickable(onClick = onClick).padding(horizontal = 18.dp, vertical = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Box(
            modifier = Modifier.size(54.dp).background(conversation.color, CircleShape),
            contentAlignment = Alignment.Center
        ) {
            Text(
                conversation.name.split(" ").take(2).mapNotNull { it.firstOrNull() }.joinToString(""),
                color = Color.White,
                fontSize = 17.sp,
                fontWeight = FontWeight.Medium
            )
        }
        Column(modifier = Modifier.weight(1f).padding(start = 14.dp)) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(conversation.name, fontSize = 16.sp, fontWeight = FontWeight.SemiBold, color = Color(0xFF202124))
                Spacer(modifier = Modifier.weight(1f))
                Text(conversation.time, fontSize = 12.sp, color = Color(0xFF70757A))
            }
            Text(
                conversation.preview,
                fontSize = 14.sp,
                color = Color(0xFF5F6368),
                modifier = Modifier.padding(top = 4.dp)
            )
        }
    }
}

@Composable
private fun ConversationScreen(conversation: Conversation, onBack: () -> Unit, onSend: (String) -> Unit) {
    var draft by remember(conversation.id) { mutableStateOf("") }
    Column(modifier = Modifier.fillMaxSize().background(Color(0xFFF8F9FA))) {
        Row(
            modifier = Modifier.fillMaxWidth().background(Color.White).padding(horizontal = 12.dp, vertical = 14.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(Icons.Default.ArrowBack, contentDescription = "Back", modifier = Modifier.clickable(onClick = onBack).padding(6.dp))
            Box(
                modifier = Modifier.padding(start = 8.dp).size(38.dp).background(conversation.color, CircleShape),
                contentAlignment = Alignment.Center
            ) {
                Text(conversation.name.take(1), color = Color.White, fontWeight = FontWeight.SemiBold)
            }
            Text(conversation.name, modifier = Modifier.padding(start = 12.dp), fontSize = 18.sp, fontWeight = FontWeight.SemiBold)
        }
        LazyColumn(
            modifier = Modifier.weight(1f).fillMaxWidth().padding(horizontal = 12.dp, vertical = 10.dp),
            verticalArrangement = Arrangement.spacedBy(9.dp)
        ) {
            items(conversation.messages) { message ->
                Row(
                    modifier = Modifier.fillMaxWidth(),
                    horizontalArrangement = if (message.outgoing) Arrangement.End else Arrangement.Start
                ) {
                    Text(
                        message.text,
                        modifier = Modifier.background(
                            when {
                                message.outgoing -> Color(0xFF1A73E8)
                                message.fromAndroid -> Color(0xFF188038)
                                else -> Color(0xFFE5E7EB)
                            },
                            RoundedCornerShape(18.dp)
                        ).padding(horizontal = 14.dp, vertical = 10.dp),
                        color = if (message.outgoing || message.fromAndroid) Color.White else Color(0xFF202124),
                        fontSize = 16.sp
                    )
                }
            }
        }
        Row(
            modifier = Modifier.fillMaxWidth().background(Color.White).padding(10.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            BasicTextField(
                value = draft,
                onValueChange = { draft = it },
                modifier = Modifier.weight(1f).background(Color(0xFFF1F3F4), RoundedCornerShape(24.dp)).padding(horizontal = 16.dp, vertical = 12.dp),
                decorationBox = { inner ->
                    if (draft.isEmpty()) Text("Text message", color = Color(0xFF777777))
                    inner()
                }
            )
            Icon(
                Icons.Default.Send,
                contentDescription = "Send message",
                tint = if (draft.isBlank()) Color(0xFF9AA0A6) else Color(0xFF1A73E8),
                modifier = Modifier.padding(start = 12.dp).clickable {
                    val text = draft.trim()
                    if (text.isNotEmpty()) {
                        onSend(text)
                        draft = ""
                    }
                }.padding(8.dp)
            )
        }
    }
}