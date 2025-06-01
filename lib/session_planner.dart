import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

class GameSession {
  final String id;
  final String title;
  final DateTime scheduledTime;
  final int maxPlayers;
  final List<String> participants;
  final String description;
  final Game game;
  final bool isPrivate;

  GameSession({
    required this.id,
    required this.title,
    required this.scheduledTime,
    required this.maxPlayers,
    required this.participants,
    required this.description,
    required this.game,
    this.isPrivate = false,
  });

  bool get hasSpace => participants.length < maxPlayers;
}

class GameSessionPlanner extends StatefulWidget {
  final Game game;

  const GameSessionPlanner({super.key, required this.game});

  @override
  State<GameSessionPlanner> createState() => _GameSessionPlannerState();
}

class _GameSessionPlannerState extends State<GameSessionPlanner> {
  final List<GameSession> _sessions = [
    GameSession(
      id: '1',
      title: 'Achievement Hunt',
      scheduledTime: DateTime(2025, 6, 1, 20, 0), // Today at 8 PM
      maxPlayers: 4,
      participants: ['DigitalChef1591', 'GamerPro42'],
      description: 'Looking for help with multiplayer achievements!',
      game: Game(
        id: '1',
        title: 'The Witcher 3',
        platform: PlatformType.steam,
        coverUrl:
            'https://images.igdb.com/igdb/image/upload/t_cover_big/co1r6p.png',
        totalAchievements: 78,
        earnedAchievements: 25,
        hoursPlayed: 45.5,
        percentComplete: 32,
        lastPlayed: DateTime(2025, 5, 1),
      ),
    ),
    GameSession(
      id: '2',
      title: 'Speedrun Practice',
      scheduledTime: DateTime(2025, 6, 2, 19, 30), // Tomorrow at 7:30 PM
      maxPlayers: 3,
      participants: ['SpeedMaster99', 'DigitalChef1591'],
      description: 'Practicing new skip for Any% route',
      game: Game(
        id: '2',
        title: 'The Witcher 3',
        platform: PlatformType.steam,
        coverUrl:
            'https://images.igdb.com/igdb/image/upload/t_cover_big/co1r6p.png',
        totalAchievements: 78,
        earnedAchievements: 25,
        hoursPlayed: 45.5,
        percentComplete: 32,
        lastPlayed: DateTime(2025, 5, 1),
      ),
    ),
  ];

  void _createNewSession() {
    showDialog(
      context: context,
      builder: (context) => _CreateSessionDialog(game: widget.game),
    ).then((newSession) {
      if (newSession != null) {
        setState(() {
          _sessions.add(newSession);
        });
      }
    });
  }

  void _joinSession(GameSession session) {
    if (!session.participants.contains('DigitalChef1591')) {
      setState(() {
        session.participants.add('DigitalChef1591');
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session joined successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gaming Sessions')),
      body: ListView.builder(
        itemCount: _sessions.length,
        itemBuilder: (context, index) {
          final session = _sessions[index];
          final bool isJoined = session.participants.contains(
            'DigitalChef1591',
          );
          final timeUntilSession = session.scheduledTime.difference(
            DateTime.now(),
          );
          final bool isUpcoming = timeUntilSession.isNegative == false;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: session.game.coverUrl != null
                        ? NetworkImage(session.game.coverUrl!)
                        : null,
                    child: session.game.coverUrl == null
                        ? const Icon(Icons.gamepad)
                        : null,
                  ),
                  title: Text(session.title),
                  subtitle: Text(
                    '${session.scheduledTime.toString().split('.')[0]}\n'
                    '${session.participants.length}/${session.maxPlayers} players',
                  ),
                  trailing: isJoined
                      ? const Icon(Icons.check_circle, color: Colors.green)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(session.description),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          children: session.participants
                              .map(
                                (name) => Chip(
                                  avatar: const CircleAvatar(
                                    child: Icon(Icons.person, size: 16),
                                  ),
                                  label: Text(name),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      if (isUpcoming && !isJoined && session.hasSpace)
                        TextButton.icon(
                          icon: const Icon(Icons.add),
                          label: const Text('Join'),
                          onPressed: () => _joinSession(session),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewSession,
        icon: const Icon(Icons.add),
        label: const Text('Create Session'),
      ),
    );
  }
}

class _CreateSessionDialog extends StatefulWidget {
  final Game game;

  const _CreateSessionDialog({required this.game});

  @override
  State<_CreateSessionDialog> createState() => _CreateSessionDialogState();
}

class _CreateSessionDialogState extends State<_CreateSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  int _maxPlayers = 4;
  bool _isPrivate = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _selectedTime = TimeOfDay.now();
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _selectedDate = DateTime(
          _selectedDate.year,
          _selectedDate.month,
          _selectedDate.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Gaming Session'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Session Title',
                  hintText: 'Enter a title for your session',
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
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'What are you planning to do?',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(
                        '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}-${_selectedDate.day.toString().padLeft(2, '0')}',
                      ),
                      onPressed: _selectDate,
                    ),
                  ),
                  Expanded(
                    child: TextButton.icon(
                      icon: const Icon(Icons.access_time),
                      label: Text(_selectedTime.format(context)),
                      onPressed: _selectTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Max Players: '),
                  Expanded(
                    child: Slider(
                      value: _maxPlayers.toDouble(),
                      min: 2,
                      max: 8,
                      divisions: 6,
                      label: _maxPlayers.toString(),
                      onChanged: (value) {
                        setState(() {
                          _maxPlayers = value.toInt();
                        });
                      },
                    ),
                  ),
                  Text(_maxPlayers.toString()),
                ],
              ),
              SwitchListTile(
                title: const Text('Private Session'),
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
              final newSession = GameSession(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                scheduledTime: _selectedDate,
                maxPlayers: _maxPlayers,
                participants: ['DigitalChef1591'],
                description: _descriptionController.text,
                game: widget.game,
                isPrivate: _isPrivate,
              );
              Navigator.pop(context, newSession);
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
