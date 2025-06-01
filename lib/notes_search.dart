import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';
import 'game_notes.dart';

class NotesSearchScreen extends StatefulWidget {
  const NotesSearchScreen({super.key});

  @override
  State<NotesSearchScreen> createState() => _NotesSearchScreenState();
}

class _NotesSearchScreenState extends State<NotesSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'all';
  bool _showPrivateOnly = false;
  final List<String> _selectedTags = [];

  // Mock data - in a real app this would come from a database
  final List<GameNote> _allNotes = [
    GameNote(
      id: '1',
      title: 'Combat Tips for Beginners',
      content: '# Basic Combat Tips\n\n1. Dodge is better than roll...',
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
      content: '# Euphoria Build\n\n## Required Mutations...',
      createdAt: DateTime(2025, 6, 1, 17, 30),
      author: 'DigitalChef1591',
      tags: ['build', 'alchemy', 'advanced'],
      isPrivate: true,
    ),
    GameNote(
      id: '3',
      title: 'Speedrun Strats - Any%',
      content: '# Main Skip Points\n\n1. Tutorial skip\n2. Castle skip...',
      createdAt: DateTime(2025, 5, 20),
      author: 'SpeedMaster99',
      tags: ['speedrun', 'glitch', 'advanced'],
      likes: ['DigitalChef1591'],
    ),
  ];

  List<GameNote> get filteredNotes {
    return _allNotes.where((note) {
      // Search text
      if (_searchController.text.isNotEmpty) {
        final searchLower = _searchController.text.toLowerCase();
        if (!note.title.toLowerCase().contains(searchLower) &&
            !note.content.toLowerCase().contains(searchLower) &&
            !note.tags.any((tag) => tag.toLowerCase().contains(searchLower))) {
          return false;
        }
      }

      // Filter by ownership
      if (_selectedFilter == 'mine' && note.author != 'DigitalChef1591') {
        return false;
      }
      if (_selectedFilter == 'others' && note.author == 'DigitalChef1591') {
        return false;
      }

      // Filter by privacy
      if (_showPrivateOnly && !note.isPrivate) {
        return false;
      }

      // Filter by tags
      if (_selectedTags.isNotEmpty &&
          !_selectedTags.any((tag) => note.tags.contains(tag))) {
        return false;
      }

      return true;
    }).toList()..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  List<String> get allTags {
    final Set<String> tags = {};
    for (final note in _allNotes) {
      tags.addAll(note.tags);
    }
    return tags.toList()..sort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Notes'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SegmentedButton<String>(
                      segments: const [
                        ButtonSegment(
                          value: 'all',
                          label: Text('All'),
                          icon: Icon(Icons.all_inclusive),
                        ),
                        ButtonSegment(
                          value: 'mine',
                          label: Text('Mine'),
                          icon: Icon(Icons.person),
                        ),
                        ButtonSegment(
                          value: 'others',
                          label: Text('Others'),
                          icon: Icon(Icons.people),
                        ),
                      ],
                      selected: {_selectedFilter},
                      onSelectionChanged: (values) {
                        setState(() {
                          _selectedFilter = values.first;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    FilterChip(
                      label: const Text('Private Only'),
                      selected: _showPrivateOnly,
                      onSelected: (selected) {
                        setState(() {
                          _showPrivateOnly = selected;
                        });
                      },
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    for (final tag in allTags)
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(tag),
                          selected: _selectedTags.contains(tag),
                          onSelected: (selected) {
                            setState(() {
                              if (selected) {
                                _selectedTags.add(tag);
                              } else {
                                _selectedTags.remove(tag);
                              }
                            });
                          },
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
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
                      Text(
                        '${note.likes.length} ❤️',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${note.comments.length} 💬',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                if (note.tags.isNotEmpty)
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
                  child: Text(
                    note.content.split('\n').take(2).join('\n'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime(2025, 6, 1, 19, 4, 47);
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
