import 'package:flutter/material.dart';
import '../../../../core/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:veloura_ai/app/theme/app_colors.dart';
import 'package:veloura_ai/app/theme/app_text_styles.dart';

import 'package:veloura_ai/core/services/supabase_service.dart';
import '../../../wardrobe/presentation/provider/wardrobe_provider.dart';
import '../providers/chat_provider.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/typing_indicator.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadWardrobeIfNeeded();
      _scrollToBottom(immediate: true);
    });
  }

  void _loadWardrobeIfNeeded() {
    final wardrobeProvider = context.read<WardrobeProvider>();
    if (wardrobeProvider.items.isEmpty) {
      final userId = SupabaseService.currentUserId ?? '';
      if (userId.isNotEmpty) {
        wardrobeProvider.loadItems(userId);
      }
    }
  }

  void _scrollToBottom({bool immediate = false}) {
    if (_scrollController.hasClients) {
      if (immediate) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      } else {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    }
  }

  void _handleSend(ChatProvider chatProvider) {
    final text = _controller.text;
    if (text.trim().isEmpty) return;

    final wardrobe = context.read<WardrobeProvider>().items;

    chatProvider.sendMessage(
      text: text,
      wardrobe: wardrobe,
      weather: const {}, // Handled dynamically in repository
    );
    _controller.clear();
    
    // Scroll to bottom after user message is added
    Future.delayed(const Duration(milliseconds: 50), () => _scrollToBottom());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Consumer<ChatProvider>(
      builder: (context, provider, _) {
        // Automatically scroll to bottom if loading state changes (typing indicator displays/hides)
        // or if a new message arrives.
        WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(l10n.velouraAiChatTitle, style: AppTextStyles.h3),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (provider.messages.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded, color: AppColors.primaryDark),
                  onPressed: () => provider.clearChat(),
                  tooltip: l10n.clearChatTooltip,
                ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: AppColors.backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: provider.messages.isEmpty
                        ? _buildEmptyState(context)
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            itemCount: provider.messages.length,
                            itemBuilder: (context, index) {
                              return ChatBubble(
                                message: provider.messages[index],
                              );
                            },
                          ),
                  ),
                  if (provider.isLoading)
                    const TypingIndicator(),
                  if (provider.error != null && provider.messages.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        provider.error!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  MessageInput(
                    controller: _controller,
                    onSend: () => _handleSend(provider),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.psychology_rounded,
              size: 80,
              color: AppColors.primary,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.aiStylistTitle,
              style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.aiStylistDesc,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            _buildSuggestionCard(l10n.suggestionPicnic),
            _buildSuggestionCard(l10n.suggestionStreetwear),
            _buildSuggestionCard(l10n.suggestionDate),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(String text) {
    return GestureDetector(
      onTap: () {
        _controller.text = text;
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: AppColors.primary, size: 18),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.primaryLight, size: 12),
          ],
        ),
      ),
    );
  }
}
