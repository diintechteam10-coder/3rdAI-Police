import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:shimmer/shimmer.dart';
import '../../bloc/ai_chat_bloc.dart';
import '../../bloc/ai_chat_event.dart';
import '../../bloc/ai_chat_state.dart';
import '../../models/chat_model.dart';
import '../../../../../../widgets/shimmer_widgets.dart';
class AiChatScreen extends StatefulWidget {
  final String agentId;
  final String agentName;
  final String firstMessage;

  const AiChatScreen({
    super.key,
    required this.agentId,
    required this.agentName,
    required this.firstMessage,
  });

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? _chatId;
  late List<MessageModel> _initialMessages;

  // Tracks messages for current "active" chat (only used when drawer history is loaded)
  List<MessageModel>? _historyMessages;
  String? _historyChatId;

  @override
  void initState() {
    super.initState();
    _initialMessages = widget.firstMessage.isNotEmpty
        ? [
            MessageModel(
              id: 'first_msg',
              role: 'assistant',
              content: widget.firstMessage,
            ),
          ]
        : [];
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ─── View the drawer ─────────────────────────────────────────────────────────
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
    // Fetch all chats when drawer opens
    context.read<AiChatBloc>().add(LoadAllChatsEvent());
  }

  // ─── Send message ─────────────────────────────────────────────────────────────
  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    // Clear loaded history if user starts a new message
    _historyMessages = null;
    _historyChatId = null;

    context.read<AiChatBloc>().add(
      SendMessageEvent(message: text, agentId: widget.agentId, chatId: _chatId),
    );
  }

  // ─── End chat ─────────────────────────────────────────────────────────────────
  void _showEndChatDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF132B4C),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'End Chat?',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          'Are you sure you want to end this chat?\nYour next message will start a new conversation.',
          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _endChat();
            },
            child: Text(
              'End Chat',
              style: GoogleFonts.poppins(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _endChat() {
    setState(() {
      _chatId = null;
      _historyMessages = null;
      _historyChatId = null;
    });
    context.read<AiChatBloc>().add(ResetChatEvent());
  }

  // ─── Load history from drawer ─────────────────────────────────────────────────
  void _loadChatHistory(String chatId) {
    Navigator.pop(context); // close drawer
    setState(() {
      _historyChatId = chatId;
      _chatId = chatId; // continue from this chat if user messages
    });
    context.read<AiChatBloc>().add(LoadChatHistoryEvent(chatId: chatId));
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D1B2A),
      // ── Drawer ────────────────────────────────────────────────────────────────
      drawer: _ChatHistoryDrawer(onChatTap: _loadChatHistory),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1B2A),
        elevation: 0,
        // Left: hamburger menu
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded, color: Colors.white),
          onPressed: _openDrawer,
        ),
        title: Text(
          widget.agentName.isNotEmpty ? widget.agentName : 'AI Police Chat',
          style: GoogleFonts.poppins(
            color: const Color(0xFFD4AF37),
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
          ),
        ),
        centerTitle: true,
        actions: [
          BlocBuilder<AiChatBloc, AiChatState>(
            builder: (context, state) {
              final isHistoryView = state is ChatHistoryLoaded;
              final isReset = state is ChatReset;
              final isEnded = isHistoryView || isReset;

              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: OutlinedButton(
                  onPressed: isEnded ? null : _showEndChatDialog,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: isEnded ? Colors.white24 : Colors.redAccent,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                  ),
                  child: Text(
                    isEnded ? "Ended" : "End Chat",
                    style: TextStyle(
                      color: isEnded ? Colors.white24 : Colors.redAccent,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocConsumer<AiChatBloc, AiChatState>(
        listener: (context, state) {
          if (state is MessageSent) {
            _chatId = state.chatId;
            _scrollToBottom();
          }
          if (state is MessageSending) {
            _chatId = state.chatId;
            _scrollToBottom();
          }
          if (state is ChatHistoryLoaded) {
            _historyMessages = state.chat.messages;
            _historyChatId = state.chat.id;
            _chatId = state.chat.id;
            _scrollToBottom();
          }
          if (state is ChatReset) {
            // Nothing extra needed — build() will render empty state
          }
          if (state is AiChatError) {
            _chatId = state.chatId;
            debugPrint('❌ [AiChat] Error: ${state.message}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade700,
              ),
            );
            _scrollToBottom();
          }
        },
        builder: (context, state) {
          // Loading history from drawer
          if (state is ChatHistoryLoading) {
            return ShimmerWidgets.alertDetailsShimmer();
          }

          // Hide input for history view (read-only) and after reset
          final isHistoryView = state is ChatHistoryLoaded;
          final isReset = state is ChatReset;
          final isSending = state is MessageSending;
          final messages = _resolveMessages(state);
          final showInput = !isReset && !isHistoryView;

          return Column(
            children: [
              if (isReset) _NewChatBanner(),
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        itemCount: messages.length + (isSending ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (isSending && index == messages.length) {
                            return _buildTypingIndicator();
                          }
                          return _MessageBubble(message: messages[index]);
                        },
                      ),
              ),
              if (showInput)
                _buildInputField(isSending)
              else if (isHistoryView || isReset)
                _buildEndedIndicator(),
            ],
          );
        },
      ),
    );
  }

  List<MessageModel> _resolveMessages(AiChatState s) {
    if (s is ChatReset) return [];
    if (s is ChatHistoryLoaded) return [..._initialMessages, ...s.chat.messages];
    if (s is ChatHistoryLoading) return _historyMessages ?? [];
    if (s is MessageSending) return [..._initialMessages, ...s.messages];
    if (s is MessageSent) return [..._initialMessages, ...s.messages];
    if (s is AiChatError && s.messages.isNotEmpty) {
      return [..._initialMessages, ...s.messages];
    }
    if (_historyMessages != null) return _historyMessages!;
    return _initialMessages;
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFF2C5EA8),
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            'Start a conversation\nwith your AI Police assistant',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF132B4C),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            const SizedBox(width: 4),
            _Dot(delay: 200),
            const SizedBox(width: 4),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(bool isSending) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF101F30),
        border: Border(top: BorderSide(color: Color(0xFF1E3A5A), width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              enabled: !isSending,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 14.sp),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: GoogleFonts.poppins(
                  color: Colors.white30,
                  fontSize: 14.sp,
                ),
                filled: true,
                fillColor: const Color(0xFF1A2D43),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _SendButton(onPressed: isSending ? null : _sendMessage),
        ],
      ),
    );
  }

  Widget _buildEndedIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF101F30),
        border: Border(top: BorderSide(color: Color(0xFF1E3A5A), width: 1)),
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white10),
        ),
        child: Text(
          'Chat Ended',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: Colors.white24,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ─── New chat banner ─────────────────────────────────────────────────────────

class _NewChatBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: const Color(0xFF1E2F45),
      child: Text(
        '✨ New chat started. Previous messages cleared.',
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          color: const Color(0xFFD4AF37),
          fontSize: 12.sp,
        ),
      ),
    );
  }
}

// ─── Chat History Drawer ─────────────────────────────────────────────────────

class _ChatHistoryDrawer extends StatelessWidget {
  final void Function(String chatId) onChatTap;

  const _ChatHistoryDrawer({required this.onChatTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF0D1B2A),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Drawer Header ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF132B4C), Color(0xFF0D1B2A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.history_rounded,
                  color: Color(0xFFD4AF37),
                  size: 32,
                ),
                const SizedBox(height: 10),
                Text(
                  'Chat History',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Your previous conversations',
                  style: GoogleFonts.poppins(
                    color: Colors.white54,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Color(0xFF1E3A5A), height: 1),

          // ── Chat List ─────────────────────────────────────────────────────
          Expanded(
            child: BlocBuilder<AiChatBloc, AiChatState>(
              buildWhen: (prev, curr) =>
                  curr is ChatsLoading ||
                  curr is ChatsLoaded ||
                  curr is AiChatError,
              builder: (context, state) {
                if (state is ChatsLoading) {
                  return const _ChatListShimmer();
                }

                if (state is ChatsLoaded) {
                  if (state.chats.isEmpty) {
                    return _buildEmptyDrawer();
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: state.chats.length,
                    separatorBuilder: (_, __) => const Divider(
                      color: Color(0xFF1E3A5A),
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                    ),
                    itemBuilder: (context, index) {
                      final chat = state.chats[index];
                      return _ChatHistoryTile(
                        chat: chat,
                        onTap: () => onChatTap(chat.id),
                      );
                    },
                  );
                }

                if (state is AiChatError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 36,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.message,
                          style: GoogleFonts.poppins(
                            color: Colors.white54,
                            fontSize: 12.sp,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        TextButton(
                          onPressed: () => context.read<AiChatBloc>().add(
                            LoadAllChatsEvent(),
                          ),
                          child: Text(
                            'Retry',
                            style: GoogleFonts.poppins(
                              color: const Color(0xFFD4AF37),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return _buildEmptyDrawer();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyDrawer() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chat_bubble_outline,
            color: Color(0xFF2C5EA8),
            size: 40,
          ),
          const SizedBox(height: 12),
          Text(
            'No chat history yet.\nStart a new conversation!',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(color: Colors.white38, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }
}

// ─── Shimmer Loading ─────────────────────────────────────────────────────────

class _ChatListShimmer extends StatelessWidget {
  const _ChatListShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF132B4C),
      highlightColor: const Color(0xFF1E3A5A),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 8,
        separatorBuilder: (_, __) => const Divider(
          color: Color(0xFF1E3A5A),
          height: 1,
          indent: 16,
          endIndent: 16,
        ),
        itemBuilder: (_, __) => const _ChatTileShimmer(),
      ),
    );
  }
}

class _ChatTileShimmer extends StatelessWidget {
  const _ChatTileShimmer();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: const CircleAvatar(
        radius: 20,
        backgroundColor: Colors.white,
      ),
      title: Container(
        height: 14.sp,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Container(
          height: 11.sp,
          width: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.white),
    );
  }
}

// ─── History Tile ─────────────────────────────────────────────────────────────

class _ChatHistoryTile extends StatelessWidget {
  final ChatSummaryModel chat;
  final VoidCallback onTap;

  const _ChatHistoryTile({required this.chat, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final dt = chat.updatedAt ?? chat.createdAt;
    final timeLabel = dt != null
        ? DateFormat('MMM d, h:mm a').format(dt.toLocal())
        : '';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: const Color(0xFF132B4C),
        child: const Icon(
          Icons.chat_rounded,
          color: Color(0xFFD4AF37),
          size: 18,
        ),
      ),
      title: Text(
        chat.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: timeLabel.isNotEmpty
          ? Text(
              timeLabel,
              style: GoogleFonts.poppins(
                color: Colors.white38,
                fontSize: 11.sp,
              ),
            )
          : null,
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.white24,
        size: 20,
      ),
    );
  }
}

// ─── Message Bubble ──────────────────────────────────────────────────────────

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          gradient: isUser
              ? const LinearGradient(
                  colors: [Color(0xFFD4AF37), Color(0xFFAA8000)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isUser ? null : const Color(0xFF132B4C),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
        ),
        child: Text(
          message.content,
          style: GoogleFonts.poppins(
            color: isUser ? Colors.black : Colors.white,
            fontSize: 14.sp,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}

// ─── Send Button ─────────────────────────────────────────────────────────────

class _SendButton extends StatelessWidget {
  final VoidCallback? onPressed;
  const _SendButton({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: onPressed != null
            ? const LinearGradient(
                colors: [Color(0xFFD4AF37), Color(0xFFAA8000)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: onPressed == null ? const Color(0xFF1E2A3A) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(23),
          onTap: onPressed,
          child: Icon(
            Icons.send_rounded,
            color: onPressed != null ? Colors.black : Colors.white24,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ─── Animated typing dots ─────────────────────────────────────────────────────

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
    _anim = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: 7,
        height: 7,
        decoration: const BoxDecoration(
          color: Color(0xFFD4AF37),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
