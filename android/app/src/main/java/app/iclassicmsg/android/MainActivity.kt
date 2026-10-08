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
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Search
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.material3.TextFieldDefaults
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp

private data class Conversation(val name: String, val preview: String, val time: String, val color: Color)

private val seedConversations = listOf(
    Conversation("Alex Morgan", "That sounds good! See you then.", "now", Color(0xFF4285F4)),
    Conversation("Jordan Lee", "Sent you the photo", "9:41 AM", Color(0xFFEA8B32)),
    Conversation("Family Group", "Mom: Don't forget your bag!", "Yesterday", Color(0xFF8E63CE)),
    Conversation("Sam Rivera", "Thanks!!", "Tuesday", Color(0xFFDE6A9A))
)

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MaterialTheme {
                Surface(modifier = Modifier.fillMaxSize(), color = Color(0xFFF8F9FA)) {
                    ConversationList()
                }
            }
        }
    }
}

@Composable
private fun ConversationList() {
    var query by remember { mutableStateOf("") }
    val conversations = seedConversations.filter {
        it.name.contains(query, ignoreCase = true) || it.preview.contains(query, ignoreCase = true)
    }

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
                items(conversations) { conversation ->
                    ConversationRow(conversation)
                }
            }
        }
        FloatingActionButton(
            onClick = { },
            modifier = Modifier.align(Alignment.BottomEnd).padding(22.dp),
            containerColor = Color(0xFF1A73E8),
            contentColor = Color.White
        ) {
            Icon(Icons.Default.Add, contentDescription = "New conversation")
        }
    }
}

@Composable
private fun ConversationRow(conversation: Conversation) {
    Row(
        modifier = Modifier.fillMaxWidth().clickable { }.padding(horizontal = 18.dp, vertical = 12.dp),
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