import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_page.dart';
import '../provider/sign_in_provider.dart';
import '../utils/next_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> getData() async {
    final sp = context.read<SignInProvider>();
    sp.getDataFromSharedPreferences();
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    final sp = context.watch<SignInProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              // Implement theme switching logic
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(sp.name ?? "User Name"),
              accountEmail: Text(sp.email ?? "user@example.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(sp.imageUrl ?? ""),
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            ListTile(
              leading:
                  Icon(Icons.person, color: Theme.of(context).iconTheme.color),
              title: Text('View Profile',
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                // Navigate to profile screen
              },
            ),
            ListTile(
              leading: Icon(Icons.settings,
                  color: Theme.of(context).iconTheme.color),
              title: Text('Settings',
                  style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.logout, color: Theme.of(context).iconTheme.color),
              title:
                  Text('Logout', style: Theme.of(context).textTheme.bodyLarge),
              onTap: () {
                sp.userSignOut();
                nextScreenReplace(context, LoginPage());
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(sp.imageUrl ?? ""),
                radius: 50,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome, ${sp.name}",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 10),
              Text(
                sp.email ?? "",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              // const SizedBox(height: 10),
              Text(
                "UID: ${sp.uid}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("PROVIDER:"),
                  const SizedBox(width: 5),
                  Text(
                    sp.provider?.toUpperCase() ?? "",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  minimumSize:
                      Size(MediaQuery.of(context).size.width * 0.80, 50),
                  elevation: 5,
                ),
                onPressed: () {
                  sp.userSignOut();
                  nextScreenReplace(context, LoginPage());
                },
                child: const Text(
                  "SIGN OUT",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 10),
              Text(
                "User Activities",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              // Example of user activities
              Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 3,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ActivityTile(
                      icon: Icons.check_circle,
                      activity: "Completed Profile Setup",
                      date: "Today",
                    ),
                    ActivityTile(
                      icon: Icons.payment,
                      activity: "Purchased Premium Plan",
                      date: "Yesterday",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityTile extends StatelessWidget {
  final IconData icon;
  final String activity;
  final String date;

  const ActivityTile({
    Key? key,
    required this.icon,
    required this.activity,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).primaryColor),
      title: Text(activity, style: Theme.of(context).textTheme.bodyLarge),
      subtitle: Text(date, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
