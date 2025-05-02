import 'package:flutter/material.dart';
import 'package:flutter_diploma/controllers/ProfileController.dart';
import 'package:flutter_diploma/models/UserModel.dart';
import 'package:flutter_diploma/views/screens/auth/loginPage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final ProfileController _controller = ProfileController();
  late Future<ProfileModel> _profileFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _profileFuture = _controller.loadProfile();
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? "${date.year}-${date.month}-${date.day}"
        : "Невідомо";
  }

  int _calculateDays(DateTime? date) {
    return date != null
        ? DateTime.now().difference(date).inDays
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder<ProfileModel>(
        future: _profileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text("Помилка завантаження даних"));
          }

          final profile = snapshot.data!;
          final days = _calculateDays(profile.registrationDate);

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  child: Text(
                    profile.email?.substring(0, 1).toUpperCase() ?? "?",
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  profile.username ?? "Без імені",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 16),
                Text(profile.email ?? "", style: const TextStyle(fontSize: 18)),
                const SizedBox(height: 8),
                Text(
                  'Дата реєстрації: ${_formatDate(profile.registrationDate)}',
                  style: const TextStyle(fontSize: 16),
                ),
                Text(
                  'Днів з реєстрації: $days',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                Text(
                  "Середній бал: ${profile.averageScore.toStringAsFixed(2)}/10",
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    await _controller.logout();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Вийти з акаунта'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}