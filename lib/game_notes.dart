import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

class GameNote {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String author;
  final bool isPrivate;
  final List<String> tags;
  final List<String> likes;
  final List<GameNoteComment> comments;

  GameNote({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.updatedAt,
    required this.author,
    this.isPrivate = false,
    this.tags = const [],
    this.likes = const [],
    this.comments = const [],
  });
}

class GameNoteComment {
  final String id;
  final String content;
  final String author;
  final DateTime createdAt;

  GameNoteComment({
    required this.id,
    required this.content,
    required this.author,
    required this.createdAt,
  });
}

class GameNotesScreen extends StatefulWidget {
  final Game game;

  const GameNotesScreen({super.key, required this.game});

  @override
  State<GameNotesScreen> createState() => _GameNotesScreenState();
}

class _GameNotesScreenState extends State<GameNotesScreen> {
  final List<GameNote> _notes = [
    GameNote(
      id: '1',
      title: 'Combat Tips for Beginners',
      content: '''
# Basic Combat Tips

1. Dodge is better than roll in most situations
2. Use Quen shield before tough fights
3. Always keep sword repair kits handy
4. Oils make a huge difference

## Must-Have Skills
- Gourmet (early game sustain)
- Whirl (crowd control)
- Active Shield (Quen upgrade)

Remember to meditate to restore potions!
''',
      createdAt: DateTime(2025, 5, 15),
      author: 'GamerPro42',
      tags: ['combat', 'beginner', 'tips'],
      likes: ['DigitalChef1591', 'SpeedMaster99'],
      comments: [
        GameNoteComment(
          id: '1',
          content: 'Great tips! The Gourmet skill helped me a lot.',
          author: 'DigitalChef1591',
          createdAt: DateTime(2025, 5, 16),
        ),
      ],
    ),
    GameNote(
      id: '2',
      title: 'My Alchemy Build Notes',
      content: '''
# Euphoria Build

## Required Mutations
- Mutations Unlocked (Blood & Wine)
- Euphoria Mutation

## Decoctions
1. Ekimmara
2. Water Hag
3. Arachas

## Rotation
1. Apply oils
2. Drink decoctions
3. Use thunderbolt before fight

Currently hitting 10k+ damage with this setup!
''',
      createdAt: DateTime(2025, 6, 1, 17, 30),
      author: 'DigitalChef1591',
      tags: ['build', 'alchemy', 'advanced'],
      isPrivate: true,
    ),
  ];

  void _addNote() {
    showDialog(
      context: context,
      builder: (context) => _CreateNoteDialog(
        onSave: (title, content, isPrivate, tags) {
          setState(() {
            _notes.add(
              GameNote(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: title,
                content: content,
                createdAt: DateTime.now(),
                author: 'DigitalChef1591',
                isPrivate: isPrivate,
                tags: tags,
              ),
            );
          });
        },
      ),
    );
  }

  void _editNote(GameNote note) {
    showDialog(
      context: context,
      builder: (context) => _CreateNoteDialog(
        initialTitle: note.title,
        initialContent: note.content,
        initialIsPrivate: note.isPrivate,
        initialTags: note.tags,
        onSave: (title, content, isPrivate, tags) {
          setState(() {
            final index = _notes.indexWhere((n) => n.id == note.id);
            if (index != -1) {
              _notes[index] = GameNote(
                id: note.id,
                title: title,
                content: content,
                createdAt: note.createdAt,
                updatedAt: DateTime.now(),
                author: note.author,
                isPrivate: isPrivate,
                tags: tags,
                likes: note.likes,
                comments: note.comments,
              );
            }
          });
        },
      ),
    );
  }

  void _toggleLike(GameNote note) {
    setState(() {
      if (note.likes.contains('DigitalChef1591')) {
        note.likes.remove('DigitalChef1591');
      } else {
        note.likes.add('DigitalChef1591');
      }
    });
  }

  void _addComment(GameNote note) {
    showDialog(
      context: context,
      builder: (context) => _AddCommentDialog(
        onSave: (content) {
          setState(() {
            note.comments.add(
              GameNoteComment(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                content: content,
                author: 'DigitalChef1591',
                createdAt: DateTime.now(),
              ),
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Filters coming soon!')),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          final isAuthor = note.author == 'DigitalChef1591';

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    '${note.author} • ${_formatDate(note.createdAt)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (note.isPrivate)
                        const Icon(Icons.lock, size: 16, color: Colors.grey),
                      if (isAuthor)
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => _editNote(note),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Wrap(
                    spacing: 8,
                    children: note.tags
                        .map(
                          (tag) => Chip(
                            label: Text(tag),
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(note.content),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      TextButton.icon(
                        icon: Icon(
                          note.likes.contains('DigitalChef1591')
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: note.likes.contains('DigitalChef1591')
                              ? Colors.red
                              : null,
                        ),
                        label: Text(note.likes.length.toString()),
                        onPressed: () => _toggleLike(note),
                      ),
                      TextButton.icon(
                        icon: const Icon(Icons.comment),
                        label: Text(note.comments.length.toString()),
                        onPressed: () => _addComment(note),
                      ),
                    ],
                  ),
                ),
                if (note.comments.isNotEmpty) ...[
                  const Divider(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: note.comments.length,
                    itemBuilder: (context, index) {
                      final comment = note.comments[index];
                      return ListTile(
                        dense: true,
                        title: Text(comment.content),
                        subtitle: Text(
                          '${comment.author} • ${_formatDate(comment.createdAt)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        child: const Icon(Icons.add),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime(2025, 6, 1, 18, 57, 10);
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    }
  }
}

class _CreateNoteDialog extends StatefulWidget {
  final String? initialTitle;
  final String? initialContent;
  final bool? initialIsPrivate;
  final List<String>? initialTags;
  final void Function(
    String title,
    String content,
    bool isPrivate,
    List<String> tags,
  )
  onSave;

  const _CreateNoteDialog({
    this.initialTitle,
    this.initialContent,
    this.initialIsPrivate,
    this.initialTags,
    required this.onSave,
  });

  @override
  State<_CreateNoteDialog> createState() => _CreateNoteDialogState();
}

class _CreateNoteDialogState extends State<_CreateNoteDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late final TextEditingController _tagsController;
  late bool _isPrivate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _contentController = TextEditingController(text: widget.initialContent);
    _tagsController = TextEditingController(
      text: widget.initialTags?.join(', ') ?? '',
    );
    _isPrivate = widget.initialIsPrivate ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialTitle == null ? 'New Note' : 'Edit Note'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Enter note title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  hintText: 'Write your note here',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some content';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _tagsController,
                decoration: const InputDecoration(
                  labelText: 'Tags',
                  hintText: 'Enter tags separated by commas',
                ),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('Private Note'),
                value: _isPrivate,
                onChanged: (value) {
                  setState(() {
                    _isPrivate = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final tags = _tagsController.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();

              widget.onSave(
                _titleController.text,
                _contentController.text,
                _isPrivate,
                tags,
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _AddCommentDialog extends StatefulWidget {
  final void Function(String content) onSave;

  const _AddCommentDialog({required this.onSave});

  @override
  State<_AddCommentDialog> createState() => _AddCommentDialogState();
}

class _AddCommentDialogState extends State<_AddCommentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Comment'),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _contentController,
          decoration: const InputDecoration(
            labelText: 'Comment',
            hintText: 'Write your comment here',
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a comment';
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(_contentController.text);
              Navigator.pop(context);
            }
          },
          child: const Text('Post'),
        ),
      ],
    );
  }
}
