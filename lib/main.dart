import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const StudyNotesApp());
}

// ─── THEME PROVIDER ───────────────────────────────────────────────────────────

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

final themeProvider = ThemeProvider();

// ─── DATA MODEL ───────────────────────────────────────────────────────────────

class Note {
  String id;
  String title;
  String content;
  String subject;
  DateTime createdAt;
  bool isPinned;
  Color cardColor;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.subject,
    required this.createdAt,
    this.isPinned = false,
    required this.cardColor,
  });
}

// ─── APP COLORS ───────────────────────────────────────────────────────────────

class AppColors {
  // Dark theme colors
  static const Color darkBg = Color(0xFF0F0F1A);
  static const Color darkSurface = Color(0xFF1A1A2E);
  static const Color darkCard = Color(0xFF16213E);
  static const Color darkTextPrimary = Color(0xFFE2E8F0);
  static const Color darkTextSecondary = Color(0xFF94A3B8);
  static const Color darkBorder = Color(0xFF334155);

  // Light theme colors
  static const Color lightBg = Color(0xFFF8F9FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFF5F7FA);
  static const Color lightTextPrimary = Color(0xFF1A202C);
  static const Color lightTextSecondary = Color(0xFF718096);
  static const Color lightBorder = Color(0xFFCBD5E0);

  // Accent colors (same for both themes)
  static const Color accent1 = Color(0xFF7C3AED); // violet
  static const Color accent2 = Color(0xFF06B6D4); // cyan
  static const Color accent3 = Color(0xFFF59E0B); // amber
  static const Color accent4 = Color(0xFF10B981); // emerald
  static const Color accent5 = Color(0xFFEF4444); // red
  static const Color accent6 = Color(0xFFEC4899); // pink

  // Dynamic colors based on theme
  static Color getBg(bool isDark) => isDark ? darkBg : lightBg;
  static Color getSurface(bool isDark) => isDark ? darkSurface : lightSurface;
  static Color getCard(bool isDark) => isDark ? darkCard : lightCard;
  static Color getTextPrimary(bool isDark) => isDark ? darkTextPrimary : lightTextPrimary;
  static Color getTextSecondary(bool isDark) => isDark ? darkTextSecondary : lightTextSecondary;
  static Color getBorder(bool isDark) => isDark ? darkBorder : lightBorder;

  // Legacy accessors (default to dark)
  static const Color bg = darkBg;
  static const Color surface = darkSurface;
  static const Color card = darkCard;
  static const Color textPrimary = darkTextPrimary;
  static const Color textSecondary = darkTextSecondary;
  static const Color border = darkBorder;

  static const List<Color> subjectColors = [
    Color(0xFF7C3AED),
    Color(0xFF06B6D4),
    Color(0xFFF59E0B),
    Color(0xFF10B981),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
    Color(0xFF14B8A6),
  ];

  static const List<Color> cardColors = [
    Color(0xFF1E1B4B),
    Color(0xFF0C4A6E),
    Color(0xFF451A03),
    Color(0xFF064E3B),
    Color(0xFF4C0519),
    Color(0xFF500724),
    Color(0xFF2E1065),
    Color(0xFF042F2E),
  ];

  static List<Color> getCardColors(bool isDark) {
    if (isDark) {
      return cardColors;
    } else {
      return [
        const Color(0xFFF3E8FF),
        const Color(0xFFE0F2FE),
        const Color(0xFFFEF3C7),
        const Color(0xFFD1FAE5),
        const Color(0xFFFCE7F3),
        const Color(0xFFFEE2E4),
        const Color(0xFFF3E8FF),
        const Color(0xFFCCFBF1),
      ];
    }
  }
}

// ─── SUBJECT ICONS ────────────────────────────────────────────────────────────

final Map<String, IconData> subjectIcons = {
  'Mathematics': Icons.calculate_rounded,
  'Science': Icons.science_rounded,
  'History': Icons.history_edu_rounded,
  'English': Icons.menu_book_rounded,
  'Physics': Icons.bolt_rounded,
  'Chemistry': Icons.biotech_rounded,
  'Biology': Icons.eco_rounded,
  'Geography': Icons.public_rounded,
  'Computer Science': Icons.computer_rounded,
  'Art': Icons.palette_rounded,
  'Music': Icons.music_note_rounded,
  'Other': Icons.folder_rounded,
};

// ─── MAIN APP ─────────────────────────────────────────────────────────────────

class StudyNotesApp extends StatefulWidget {
  const StudyNotesApp({super.key});

  @override
  State<StudyNotesApp> createState() => _StudyNotesAppState();
}

class _StudyNotesAppState extends State<StudyNotesApp> {
  @override
  void initState() {
    super.initState();
    themeProvider.addListener(_onThemeChanged);
  }

  @override
  void dispose() {
    themeProvider.removeListener(_onThemeChanged);
    super.dispose();
  }

  void _onThemeChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = themeProvider.isDarkMode;
    final bgColor = AppColors.getBg(isDark);
    final surfaceColor = AppColors.getSurface(isDark);
    final textColor = AppColors.getTextPrimary(isDark);

    return MaterialApp(
      title: 'StudyVault',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: isDark ? Brightness.dark : Brightness.light,
        scaffoldBackgroundColor: bgColor,
        colorScheme: ColorScheme(
          brightness: isDark ? Brightness.dark : Brightness.light,
          primary: AppColors.accent1,
          onPrimary: Colors.white,
          secondary: AppColors.accent2,
          onSecondary: Colors.white,
          surface: surfaceColor,
          onSurface: textColor,
          error: AppColors.accent5,
          onError: Colors.white,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: ZoomPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScreen(),
        '/add': (ctx) => const AddNoteScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/detail') {
          final note = settings.arguments as Note;
          return MaterialPageRoute(
            builder: (_) => NoteDetailScreen(note: note),
          );
        }
        if (settings.name == '/edit') {
          final note = settings.arguments as Note;
          return MaterialPageRoute(
            builder: (_) => AddNoteScreen(noteToEdit: note),
          );
        }
        return null;
      },
    );
  }
}

// ─── HOME SCREEN ──────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final List<Note> _notes = _sampleNotes();
  String _selectedSubject = 'All';
  String _searchQuery = '';
  late AnimationController _fabController;

  static List<Note> _sampleNotes() {
    return [
      Note(
        id: '1',
        title: 'Quadratic Formula',
        content:
            'The quadratic formula is x = (-b ± √(b²-4ac)) / 2a. It solves any quadratic equation of the form ax² + bx + c = 0. Discriminant: b²-4ac determines the nature of roots.',
        subject: 'Mathematics',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isPinned: true,
        cardColor: AppColors.cardColors[0],
      ),
      Note(
        id: '2',
        title: 'Newton\'s Laws of Motion',
        content:
            '1st: An object stays at rest or in motion unless acted upon. 2nd: F = ma. 3rd: Every action has an equal and opposite reaction.',
        subject: 'Physics',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        cardColor: AppColors.cardColors[1],
      ),
      Note(
        id: '3',
        title: 'Cell Division - Mitosis',
        content:
            'Phases: Prophase → Metaphase → Anaphase → Telophase → Cytokinesis. Results in 2 identical daughter cells with same chromosome count.',
        subject: 'Biology',
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        isPinned: true,
        cardColor: AppColors.cardColors[3],
      ),
      Note(
        id: '4',
        title: 'World War II Timeline',
        content:
            '1939: Germany invades Poland. 1941: Pearl Harbor, US enters war. 1944: D-Day Normandy landings. 1945: VE Day (May), VJ Day (September).',
        subject: 'History',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        cardColor: AppColors.cardColors[2],
      ),
      Note(
        id: '5',
        title: 'Periodic Table Groups',
        content:
            'Group 1: Alkali metals (highly reactive). Group 17: Halogens. Group 18: Noble gases (inert). Transition metals: Groups 3-12.',
        subject: 'Chemistry',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
        cardColor: AppColors.cardColors[5],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..forward();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  List<String> get _subjects {
    final subjects = _notes.map((n) => n.subject).toSet().toList();
    subjects.sort();
    return ['All', ...subjects];
  }

  List<Note> get _filteredNotes {
    var notes = _notes.where((n) {
      final matchesSubject =
          _selectedSubject == 'All' || n.subject == _selectedSubject;
      final matchesSearch =
          _searchQuery.isEmpty ||
          n.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          n.content.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          n.subject.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesSubject && matchesSearch;
    }).toList();

    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
    return notes;
  }

  void _deleteNote(String id) {
    setState(() => _notes.removeWhere((n) => n.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Note deleted'),
        backgroundColor: AppColors.surface,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        action: SnackBarAction(
          label: 'UNDO',
          textColor: AppColors.accent2,
          onPressed: () {},
        ),
      ),
    );
  }

  void _togglePin(String id) {
    setState(() {
      final i = _notes.indexWhere((n) => n.id == id);
      if (i != -1) _notes[i].isPinned = !_notes[i].isPinned;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredNotes;
    final pinned = filtered.where((n) => n.isPinned).toList();
    final unpinned = filtered.where((n) => !n.isPinned).toList();
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: AppColors.getBg(isDark),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(isDark),
            _buildSubjectFilter(isDark),
            _buildStatsRow(isDark),
            Expanded(
              child:
                  filtered.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                        children: [
                          if (pinned.isNotEmpty) ...[
                            _sectionLabel('📌 Pinned', isDark),
                            ...pinned.map(
                              (n) => _NoteCard(
                                note: n,
                                onDelete: () => _deleteNote(n.id),
                                onPin: () => _togglePin(n.id),
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: n,
                                    ).then((_) => setState(() {})),
                                onEdit:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/edit',
                                      arguments: n,
                                    ).then((result) {
                                      if (result != null && result is Note) {
                                        setState(() {
                                          final i = _notes.indexWhere(
                                            (x) => x.id == result.id,
                                          );
                                          if (i != -1) _notes[i] = result;
                                        });
                                      }
                                    }),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                          if (unpinned.isNotEmpty) ...[
                            if (pinned.isNotEmpty) _sectionLabel('📚 All Notes', isDark),
                            ...unpinned.map(
                              (n) => _NoteCard(
                                note: n,
                                onDelete: () => _deleteNote(n.id),
                                onPin: () => _togglePin(n.id),
                                onTap:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/detail',
                                      arguments: n,
                                    ).then((_) => setState(() {})),
                                onEdit:
                                    () => Navigator.pushNamed(
                                      context,
                                      '/edit',
                                      arguments: n,
                                    ).then((result) {
                                      if (result != null && result is Note) {
                                        setState(() {
                                          final i = _notes.indexWhere(
                                            (x) => x.id == result.id,
                                          );
                                          if (i != -1) _notes[i] = result;
                                        });
                                      }
                                    }),
                              ),
                            ),
                          ],
                        ],
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: ScaleTransition(
        scale: CurvedAnimation(
          parent: _fabController,
          curve: Curves.elasticOut,
        ),
        child: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Navigator.pushNamed(context, '/add');
            if (result != null && result is Note) {
              setState(() => _notes.add(result));
            }
          },
          backgroundColor: AppColors.accent1,
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.add_rounded),
          label: const Text(
            'New Note',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final isDark = themeProvider.isDarkMode;
    AppColors.getBg(isDark);
    final textColor = AppColors.getTextPrimary(isDark);
    AppColors.getSurface(isDark);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.accent1, AppColors.accent2],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.auto_stories_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'StudyVault',
                style: TextStyle(
                  color: textColor,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              Text(
                '${_notes.length} notes saved',
                style: TextStyle(
                  color: AppColors.getTextSecondary(isDark),
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const Spacer(),
          _buildThemeToggle(isDark),
          const SizedBox(width: 8),
          _buildSortMenu(isDark),
        ],
      ),
    );
  }

  Widget _buildThemeToggle(bool isDark) {
    return GestureDetector(
      onTap: () => themeProvider.toggleTheme(),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDark),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.getBorder(isDark)),
        ),
        child: Icon(
          isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
          color: isDark ? AppColors.accent3 : AppColors.accent1,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildSortMenu(bool isDark) {
    return PopupMenuButton<String>(
      color: AppColors.getSurface(isDark),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.getBorder(isDark)),
      ),
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDark),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.getBorder(isDark)),
        ),
        child: Icon(Icons.tune_rounded, color: AppColors.getTextSecondary(isDark), size: 18),
      ),
      itemBuilder:
          (_) => [
            _popupItem('📊 Sort by Date', 'date', isDark),
            _popupItem('🔤 Sort by Title', 'title', isDark),
            _popupItem('📂 Sort by Subject', 'subject', isDark),
          ],
      onSelected: (v) {
        setState(() {
          if (v == 'title') _notes.sort((a, b) => a.title.compareTo(b.title));
          if (v == 'subject') _notes.sort((a, b) => a.subject.compareTo(b.subject));
          if (v == 'date') _notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        });
      },
    );
  }

  PopupMenuItem<String> _popupItem(String text, String value, bool isDark) {
    return PopupMenuItem(
      value: value,
      child: Text(text, style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14)),
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.getSurface(isDark),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.getBorder(isDark)),
        ),
        child: TextField(
          onChanged: (v) => setState(() => _searchQuery = v),
          style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search notes, subjects...',
            hintStyle: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 14),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.getTextSecondary(isDark), size: 20),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }

  Widget _buildSubjectFilter(bool isDark) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _subjects.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final s = _subjects[i];
          final selected = s == _selectedSubject;
          final color = s == 'All'
              ? AppColors.accent1
              : AppColors.subjectColors[s.hashCode % AppColors.subjectColors.length];
          return GestureDetector(
            onTap: () => setState(() => _selectedSubject = s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? color : AppColors.getSurface(isDark),
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: selected ? color : AppColors.getBorder(isDark)),
              ),
              child: Text(
                s == 'All' ? '✨ All' : s,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.getTextSecondary(isDark),
                  fontSize: 12,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    final subjects = _notes.map((n) => n.subject).toSet().length;
    final pinned = _notes.where((n) => n.isPinned).length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          _statChip(Icons.note_rounded, '${_notes.length}', 'Notes', AppColors.accent1, isDark),
          const SizedBox(width: 8),
          _statChip(Icons.folder_rounded, '$subjects', 'Subjects', AppColors.accent2, isDark),
          const SizedBox(width: 8),
          _statChip(Icons.push_pin_rounded, '$pinned', 'Pinned', AppColors.accent3, isDark),
        ],
      ),
    );
  }

  Widget _statChip(IconData icon, String val, String label, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          // ignore: deprecated_member_use
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(val, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
                Text(label, style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String label, bool isDark) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 12, 0, 8),
      child: Text(
        label,
        style: TextStyle(
          color: AppColors.getTextSecondary(isDark),
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: AppColors.accent1.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.note_add_rounded, color: AppColors.accent1, size: 36),
          ),
          const SizedBox(height: 16),
          Text(
            'No notes found',
            style: TextStyle(color: AppColors.getTextPrimary(isDark), fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first note',
            style: TextStyle(color: AppColors.getTextSecondary(isDark), fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ─── NOTE CARD ────────────────────────────────────────────────────────────────

class _NoteCard extends StatelessWidget {
  final Note note;
  final VoidCallback onDelete;
  final VoidCallback onPin;
  final VoidCallback onTap;
  final VoidCallback onEdit;

  const _NoteCard({
    required this.note,
    required this.onDelete,
    required this.onPin,
    required this.onTap,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final subjectColor =
        AppColors.subjectColors[note.subject.hashCode % AppColors.subjectColors.length];
    final icon = subjectIcons[note.subject] ?? Icons.folder_rounded;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Hero(
          tag: 'note-${note.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: note.cardColor,
                borderRadius: BorderRadius.circular(18),
                // ignore: deprecated_member_use
                border: Border.all(color: subjectColor.withOpacity(0.4), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: subjectColor.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: subjectColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            // ignore: deprecated_member_use
                            border: Border.all(color: subjectColor.withOpacity(0.5)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, color: subjectColor, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                note.subject,
                                style: TextStyle(
                                  color: subjectColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        if (note.isPinned)
                          const Icon(Icons.push_pin_rounded, color: AppColors.accent3, size: 16),
                        const SizedBox(width: 4),
                        _cardMenu(subjectColor),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      note.title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      note.content,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(note.createdAt),
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                        const Spacer(),
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(color: subjectColor, shape: BoxShape.circle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardMenu(Color color) {
    return PopupMenuButton<String>(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      icon: Icon(Icons.more_vert_rounded, color: AppColors.textSecondary, size: 18),
      itemBuilder:
          (_) => [
            _item(Icons.edit_rounded, 'Edit', 'edit', AppColors.accent2),
            _item(
              note.isPinned ? Icons.push_pin_outlined : Icons.push_pin_rounded,
              note.isPinned ? 'Unpin' : 'Pin',
              'pin',
              AppColors.accent3,
            ),
            _item(Icons.delete_rounded, 'Delete', 'delete', AppColors.accent5),
          ],
      onSelected: (v) {
        if (v == 'delete') onDelete();
        if (v == 'pin') onPin();
        if (v == 'edit') onEdit();
      },
    );
  }

  PopupMenuItem<String> _item(IconData icon, String label, String value, Color color) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─── NOTE DETAIL SCREEN ───────────────────────────────────────────────────────

class NoteDetailScreen extends StatelessWidget {
  final Note note;
  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final subjectColor =
        AppColors.subjectColors[note.subject.hashCode % AppColors.subjectColors.length];
    final icon = subjectIcons[note.subject] ?? Icons.folder_rounded;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary, size: 18),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/edit', arguments: note),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: subjectColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        // ignore: deprecated_member_use
                        border: Border.all(color: subjectColor.withOpacity(0.4)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.edit_rounded, color: subjectColor, size: 16),
                          const SizedBox(width: 6),
                          Text(
                            'Edit',
                            style: TextStyle(color: subjectColor, fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Hero(
                tag: 'note-${note.id}',
                child: Material(
                  color: Colors.transparent,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            // ignore: deprecated_member_use
                            color: subjectColor.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            // ignore: deprecated_member_use
                            border: Border.all(color: subjectColor.withOpacity(0.4)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(icon, color: subjectColor, size: 14),
                              const SizedBox(width: 6),
                              Text(
                                note.subject,
                                style: TextStyle(
                                  color: subjectColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          note.title,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, size: 14, color: AppColors.textSecondary),
                            const SizedBox(width: 6),
                            Text(
                              '${note.createdAt.day}/${note.createdAt.month}/${note.createdAt.year} at ${note.createdAt.hour}:${note.createdAt.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                            ),
                            if (note.isPinned) ...[
                              const SizedBox(width: 12),
                              const Icon(Icons.push_pin_rounded, size: 14, color: AppColors.accent3),
                              const SizedBox(width: 4),
                              const Text('Pinned', style: TextStyle(color: AppColors.accent3, fontSize: 13)),
                            ],
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          height: 1,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [subjectColor, Colors.transparent],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          note.content,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            height: 1.8,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: note.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            // ignore: deprecated_member_use
                            border: Border.all(color: subjectColor.withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.lightbulb_rounded, color: AppColors.accent3, size: 20),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Tip: Review this note regularly using spaced repetition for better retention!',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ADD / EDIT NOTE SCREEN ───────────────────────────────────────────────────

class AddNoteScreen extends StatefulWidget {
  final Note? noteToEdit;
  const AddNoteScreen({super.key, this.noteToEdit});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  String _subject = 'Mathematics';
  Color _selectedColor = AppColors.cardColors[0];
  bool _isPinned = false;
  bool get _isEditing => widget.noteToEdit != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _titleController.text = widget.noteToEdit!.title;
      _contentController.text = widget.noteToEdit!.content;
      _subject = widget.noteToEdit!.subject;
      _selectedColor = widget.noteToEdit!.cardColor;
      _isPinned = widget.noteToEdit!.isPinned;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a title'),
          backgroundColor: AppColors.accent5,
        ),
      );
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some content'),
          backgroundColor: AppColors.accent5,
        ),
      );
      return;
    }

    final note = Note(
      id: _isEditing ? widget.noteToEdit!.id : Random().nextInt(999999).toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      subject: _subject,
      createdAt: _isEditing ? widget.noteToEdit!.createdAt : DateTime.now(),
      isPinned: _isPinned,
      cardColor: _selectedColor,
    );
    Navigator.pop(context, note);
  }

  @override
  Widget build(BuildContext context) {
    final subjectColor =
        AppColors.subjectColors[_subject.hashCode % AppColors.subjectColors.length];

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.close_rounded, color: AppColors.textPrimary, size: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isEditing ? 'Edit Note' : 'New Note',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => setState(() => _isPinned = !_isPinned),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: _isPinned ? AppColors.accent3.withOpacity(0.15) : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _isPinned ? AppColors.accent3 : AppColors.border,
                        ),
                      ),
                      child: Icon(
                        _isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                        color: _isPinned ? AppColors.accent3 : AppColors.textSecondary,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: _save,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.accent1, AppColors.accent2],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Subject Selector
                    _label('Subject'),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 40,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: subjectIcons.keys.length,
                        separatorBuilder: (_, _) => const SizedBox(width: 8),
                        itemBuilder: (_, i) {
                          final s = subjectIcons.keys.elementAt(i);
                          final selected = s == _subject;
                          final c = AppColors.subjectColors[s.hashCode % AppColors.subjectColors.length];
                          return GestureDetector(
                            onTap: () => setState(() => _subject = s),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: selected ? c : AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: selected ? c : AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Icon(subjectIcons[s], color: selected ? Colors.white : c, size: 14),
                                  const SizedBox(width: 6),
                                  Text(
                                    s,
                                    style: TextStyle(
                                      color: selected ? Colors.white : AppColors.textSecondary,
                                      fontSize: 12,
                                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Card Color
                    _label('Card Theme'),
                    const SizedBox(height: 10),
                    Row(
                      children: AppColors.cardColors.map((c) {
                        final selected = c == _selectedColor;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = c),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 32,
                            height: 32,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selected ? subjectColor : AppColors.border,
                                width: selected ? 2.5 : 1.5,
                              ),
                              boxShadow: selected
                                  // ignore: deprecated_member_use
                                  ? [BoxShadow(color: subjectColor.withOpacity(0.4), blurRadius: 8)]
                                  : null,
                            ),
                            child: selected
                                ? const Icon(Icons.check_rounded, color: Colors.white, size: 16)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    // Title
                    _label('Title'),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _titleController,
                      hint: 'Enter note title...',
                      maxLines: 1,
                      accentColor: subjectColor,
                    ),
                    const SizedBox(height: 16),
                    // Content
                    _label('Content'),
                    const SizedBox(height: 8),
                    _inputField(
                      controller: _contentController,
                      hint: 'Write your notes here...',
                      maxLines: 10,
                      accentColor: subjectColor,
                    ),
                    const SizedBox(height: 20),
                    // Preview Card
                    _label('Preview'),
                    const SizedBox(height: 10),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _selectedColor,
                        borderRadius: BorderRadius.circular(16),
                        // ignore: deprecated_member_use
                        border: Border.all(color: subjectColor.withOpacity(0.4), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: subjectColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _subject,
                              style: TextStyle(color: subjectColor, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _titleController.text.isEmpty ? 'Your title here' : _titleController.text,
                            style: TextStyle(
                              color: _titleController.text.isEmpty
                                  ? AppColors.textSecondary
                                  : AppColors.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _contentController.text.isEmpty ? 'Your content here...' : _contentController.text,
                            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12, height: 1.4),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required int maxLines,
    required Color accentColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Focus(
        child: Builder(
          builder: (context) {
            return TextField(
              controller: controller,
              maxLines: maxLines,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14, height: 1.6),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(14),
              ),
              onChanged: (_) => setState(() {}),
            );
          },
        ),
      ),
    );
  }
}