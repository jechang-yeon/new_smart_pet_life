import 'package:flutter/material.dart';

void main() {
  runApp(const SmartPetLifeApp());
}

class SmartPetLifeApp extends StatelessWidget {
  const SmartPetLifeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Pet Life',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const PetDashboardPage(),
    );
  }
}

class PetDashboardPage extends StatefulWidget {
  const PetDashboardPage({super.key});

  @override
  State<PetDashboardPage> createState() => _PetDashboardPageState();
}

class _PetDashboardPageState extends State<PetDashboardPage> {
  final List<PetTask> _tasks = <PetTask>[
    PetTask(
      title: '아침 식사',
      description: '사료 80g 급여',
      time: '08:00',
      isDone: true,
    ),
    PetTask(
      title: '산책',
      description: '30분 가벼운 산책',
      time: '18:30',
    ),
    PetTask(
      title: '놀이 시간',
      description: '터그 놀이 15분',
      time: '20:00',
    ),
    PetTask(
      title: '물 교체',
      description: '신선한 물로 교체',
      time: '21:00',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int completedCount = _tasks.where((PetTask task) => task.isDone).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Pet Life'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _PetSummaryCard(
              petName: '초코',
              petType: '말티즈',
              age: 4,
              todayProgress: '$completedCount / ${_tasks.length}',
            ),
            const SizedBox(height: 16),
            Text(
              '오늘의 루틴',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                itemCount: _tasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final PetTask task = _tasks[index];
                  return _TaskTile(
                    task: task,
                    onChanged: (bool? value) {
                      setState(() {
                        _tasks[index] = task.copyWith(isDone: value ?? false);
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final bool allDone = _tasks.every((PetTask task) => task.isDone);
          final SnackBar snackBar = SnackBar(
            content: Text(
              allDone ? '오늘 루틴을 모두 완료했어요! 🎉' : '아직 남은 루틴이 있어요. 화이팅!',
            ),
          );
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(snackBar);
        },
        label: const Text('완료 상태 확인'),
        icon: const Icon(Icons.pets),
      ),
    );
  }
}

class _PetSummaryCard extends StatelessWidget {
  const _PetSummaryCard({
    required this.petName,
    required this.petType,
    required this.age,
    required this.todayProgress,
  });

  final String petName;
  final String petType;
  final int age;
  final String todayProgress;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              radius: 28,
              backgroundColor: Colors.teal.shade100,
              child: const Icon(Icons.pets, size: 30, color: Colors.teal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    petName,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text('$petType · $age살'),
                  const SizedBox(height: 4),
                  Text('오늘 진행률: $todayProgress'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({required this.task, required this.onChanged});

  final PetTask task;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        value: task.isDone,
        onChanged: onChanged,
        title: Text(task.title),
        subtitle: Text('${task.description} · ${task.time}'),
        secondary: Icon(
          task.isDone ? Icons.check_circle : Icons.schedule,
          color: task.isDone ? Colors.green : Colors.orange,
        ),
      ),
    );
  }
}

class PetTask {
  const PetTask({
    required this.title,
    required this.description,
    required this.time,
    this.isDone = false,
  });

  final String title;
  final String description;
  final String time;
  final bool isDone;

  PetTask copyWith({
    String? title,
    String? description,
    String? time,
    bool? isDone,
  }) {
    return PetTask(
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      isDone: isDone ?? this.isDone,
    );
  }
}
