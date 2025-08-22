import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pie_chart/pie_chart.dart';

import '../controllers/task_controller.dart';
import 'about_screen.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TaskController _taskController = Get.find();

  final box = GetStorage();

  String name = 'Guest';
  String profession = 'Your Profession';

  @override
  void initState() {
    super.initState();
    name = box.read('name') ?? 'Guest';
    profession = box.read('profession') ?? 'Your Profession';
  }

  bool showChart = false;
  String selectedPeriod = 'All';

  final List<String> periods = ['All', 'This Week', 'This Month'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Gradient background
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Profile avatar
                  CircleAvatar(
                    radius: 45,
                    backgroundImage: AssetImage("assets/images/logo_test.png"),
                    backgroundColor: Colors.black,
                  ),
                  const SizedBox(height: 12),
                  // Name & Role
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              GestureDetector(
                                onTap: _showEditDialog,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          profession,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Stats cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildCard(
                          Icons.task,
                          "Total Tasks",
                          _taskController.totalTasks.toString(),
                        ),
                        _buildCard(
                          Icons.check_circle,
                          "Completed",
                          _taskController.completedTasks.toString(),
                        ),
                        _buildCard(
                          Icons.schedule,
                          "Pending",
                          _taskController.pendingTasks.toString(),
                        ),
                        _buildStatisticsCard(theme),
                        _buildAboutCard(context, theme),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 20.0,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.home, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    "Back to Home",
                                    style: theme.textTheme.titleMedium
                                        ?.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String label, String value) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          child: Icon(icon, color: Colors.blue),
        ),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(ThemeData theme) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: AnimatedCrossFade(
        duration: const Duration(milliseconds: 400),
        firstChild: _buildStatisticsHeader(),
        secondChild: Column(
          children: [
            _buildStatisticsHeader(),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Period Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter by:"),
                      DropdownButton<String>(
                        value: selectedPeriod,
                        items:
                            periods
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedPeriod = value;
                              // _applyPeriodFilter(value);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chart
                  Obx(() {
                    final total = _taskController.totalTasks;
                    final completed = _taskController.completedTasks;
                    final pending = _taskController.pendingTasks;

                    if (total == 0) {
                      return Text(
                        "No tasks to show",
                        style: theme.textTheme.bodyLarge,
                      );
                    }

                    final dataMap = <String, double>{
                      "Completed": completed.toDouble(),
                      "Pending": pending.toDouble(),
                    };

                    return PieChart(
                      dataMap: dataMap,
                      animationDuration: const Duration(milliseconds: 800),
                      chartRadius: MediaQuery.of(context).size.width / 2,
                      colorList: [Colors.green, Colors.red],
                      chartType: ChartType.disc,
                      chartValuesOptions: const ChartValuesOptions(
                        showChartValuesInPercentage: true,
                        showChartValues: true,
                      ),
                      legendOptions: const LegendOptions(
                        legendPosition: LegendPosition.bottom,
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
        crossFadeState:
            showChart ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      ),
    );
  }

  Widget _buildStatisticsHeader() {
    return ListTile(
      onTap: () {
        setState(() {
          showChart = !showChart;
        });
      },
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withOpacity(0.1),
        child: Icon(Icons.bar_chart, color: Colors.blue),
      ),
      title: const Text(
        "Task Statistics",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      trailing: Icon(
        showChart ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
        color: Colors.deepPurple,
      ),
    );
  }

  void _showEditDialog() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final nameController = TextEditingController(text: name);
    final professionController = TextEditingController(text: profession);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          title: Center(
            child: Text(
              "Edit Profile",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                TextField(
                  controller: nameController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.8),
                    ),
                    prefixIcon: Icon(
                      Icons.person,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.8,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  cursorColor: Color(0xFF5B86E5),
                ),

                const SizedBox(height: 16),
                TextField(
                  controller: professionController,
                  style: TextStyle(color: theme.colorScheme.onSurface),
                  decoration: InputDecoration(
                    labelText: 'Profession',
                    labelStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withOpacity(0.8),
                    ),
                    prefixIcon: Icon(
                      Icons.work,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.8,
                      ),
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceVariant,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary.withOpacity(0.4),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: theme.colorScheme.primary,
                        width: 2,
                      ),
                    ),
                  ),
                  cursorColor: Color(0xFF5B86E5),
                ),
              ],
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: TextStyle(color: theme.colorScheme.secondary),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF5B86E5), Color(0xFF36D1DC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  setState(() {
                    name =
                        nameController.text.trim().isEmpty
                            ? 'Guest'
                            : nameController.text.trim();
                    profession =
                        professionController.text.trim().isEmpty
                            ? 'Your Profession'
                            : professionController.text.trim();

                    box.write('name', name);
                    box.write('profession', profession);
                  });
                  Navigator.pop(context);
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAboutCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AboutScreen()),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blueAccent.withOpacity(0.1),
          child: const Icon(Icons.info, color: Colors.blue),
        ),
        title: const Text(
          "About",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.deepPurple),
      ),
    );
  }
}
