import 'package:flutter/material.dart';
import 'models.dart';
import 'theme.dart';

class SpeedrunSegment {
  final String name;
  final Duration personalBest;
  final Duration worldRecord;
  final Duration? currentAttempt;
  final String? notes;

  SpeedrunSegment({
    required this.name,
    required this.personalBest,
    required this.worldRecord,
    this.currentAttempt,
    this.notes,
  });
}

class SpeedrunData {
  final List<SpeedrunSegment> segments;
  final Duration totalPersonalBest;
  final Duration worldRecord;
  final String category;
  final DateTime lastAttempt;
  final int totalAttempts;

  SpeedrunData({
    required this.segments,
    required this.totalPersonalBest,
    required this.worldRecord,
    required this.category,
    required this.lastAttempt,
    required this.totalAttempts,
  });

  // Mock data generator
  static SpeedrunData getMockData() {
    return SpeedrunData(
      segments: [
        SpeedrunSegment(
          name: "Tutorial",
          personalBest: const Duration(minutes: 2, seconds: 45),
          worldRecord: const Duration(minutes: 2, seconds: 12),
          notes: "Skip the optional dialogue",
        ),
        SpeedrunSegment(
          name: "First Boss",
          personalBest: const Duration(minutes: 5, seconds: 30),
          worldRecord: const Duration(minutes: 4, seconds: 45),
          notes: "Use the shortcut behind the waterfall",
        ),
        SpeedrunSegment(
          name: "Cave Section",
          personalBest: const Duration(minutes: 8, seconds: 15),
          worldRecord: const Duration(minutes: 7, seconds: 30),
          notes: "Collect red key first",
        ),
        SpeedrunSegment(
          name: "Final Area",
          personalBest: const Duration(minutes: 12, seconds: 0),
          worldRecord: const Duration(minutes: 10, seconds: 45),
          notes: "New skip discovered - check Discord",
        ),
      ],
      totalPersonalBest: const Duration(minutes: 28, seconds: 30),
      worldRecord: const Duration(minutes: 25, seconds: 12),
      category: "Any%",
      lastAttempt: DateTime(2025, 6, 1, 17, 30), // Today's earlier attempt
      totalAttempts: 42,
    );
  }
}

class SpeedrunTrackerScreen extends StatefulWidget {
  final Game game;

  const SpeedrunTrackerScreen({super.key, required this.game});

  @override
  State<SpeedrunTrackerScreen> createState() => _SpeedrunTrackerScreenState();
}

class _SpeedrunTrackerScreenState extends State<SpeedrunTrackerScreen> {
  late final SpeedrunData speedrunData;
  bool _isAttemptActive = false;
  Stopwatch _stopwatch = Stopwatch();
  int _currentSegment = 0;

  @override
  void initState() {
    super.initState();
    speedrunData = SpeedrunData.getMockData();
  }

  void _startAttempt() {
    setState(() {
      _isAttemptActive = true;
      _currentSegment = 0;
      _stopwatch = Stopwatch()..start();
    });
  }

  void _nextSegment() {
    if (_currentSegment < speedrunData.segments.length - 1) {
      setState(() {
        _currentSegment++;
      });
    } else {
      _finishAttempt();
    }
  }

  void _finishAttempt() {
    _stopwatch.stop();
    setState(() {
      _isAttemptActive = false;
    });
    _showResultDialog();
  }

  void _resetAttempt() {
    setState(() {
      _isAttemptActive = false;
      _stopwatch.stop();
      _stopwatch.reset();
      _currentSegment = 0;
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Run Complete!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Final Time: ${_formatDuration(_stopwatch.elapsed)}'),
            const SizedBox(height: 8),
            Text(
              'Personal Best: ${_formatDuration(speedrunData.totalPersonalBest)}',
              style: const TextStyle(color: Colors.blue),
            ),
            Text(
              'World Record: ${_formatDuration(speedrunData.worldRecord)}',
              style: const TextStyle(color: Colors.green),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _startAttempt();
            },
            child: const Text('New Attempt'),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String minutes = twoDigits(duration.inMinutes.remainder(60));
    String seconds = twoDigits(duration.inSeconds.remainder(60));
    String milliseconds = twoDigits(
      duration.inMilliseconds.remainder(1000) ~/ 10,
    );
    return "$minutes:$seconds.$milliseconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speedrun Tracker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Past attempts coming soon!')),
              );
            },
            tooltip: 'View History',
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    widget.game.title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Category: ${speedrunData.category}',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          const Text('Personal Best'),
                          Text(
                            _formatDuration(speedrunData.totalPersonalBest),
                            style: const TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text('World Record'),
                          Text(
                            _formatDuration(speedrunData.worldRecord),
                            style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isAttemptActive) ...[
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: Stream.periodic(const Duration(milliseconds: 10)),
                      builder: (context, snapshot) {
                        return Text(
                          _formatDuration(_stopwatch.elapsed),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Monospace',
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Current Segment: ${speedrunData.segments[_currentSegment].name}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _resetAttempt,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: _nextSegment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(
                    _currentSegment < speedrunData.segments.length - 1
                        ? 'Next Segment'
                        : 'Finish Run',
                  ),
                ),
              ],
            ),
          ],
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: speedrunData.segments.length,
              itemBuilder: (context, index) {
                final segment = speedrunData.segments[index];
                return Card(
                  child: ListTile(
                    leading: Icon(
                      Icons.flag,
                      color: _isAttemptActive && index == _currentSegment
                          ? Colors.blue
                          : Colors.grey,
                    ),
                    title: Text(segment.name),
                    subtitle: Text(segment.notes ?? ''),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'PB: ${_formatDuration(segment.personalBest)}',
                          style: const TextStyle(color: Colors.blue),
                        ),
                        Text(
                          'WR: ${_formatDuration(segment.worldRecord)}',
                          style: const TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _isAttemptActive
          ? null
          : FloatingActionButton.extended(
              onPressed: _startAttempt,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Start Run'),
            ),
    );
  }
}
