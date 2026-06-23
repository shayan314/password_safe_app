import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_password_screen.dart';
import 'details_screen.dart';
import 'settings_screen.dart';
import '../providers/password_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<PasswordProvider>(
        context,
        listen: false,
      ).loadPasswords();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PasswordProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: const Text("🔐 Password Safe"),
        centerTitle: true,

        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,

        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color ?? Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [

          // 🔍 SEARCH BAR
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: searchController,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
              ),

              decoration: InputDecoration(
                hintText: "Search account...",
                hintStyle: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white54,
                ),

                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).iconTheme.color ?? Colors.white54,
                ),

                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    searchController.clear();
                    setState(() {
                      searchQuery = "";
                    });
                  },
                )
                    : null,

                filled: true,
                fillColor: Theme.of(context).cardColor,

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),

              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),

          // 📦 CONTENT AREA
          Expanded(
            child: provider.isLoading
                ? Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            )
                : Builder(
              builder: (context) {
                final filteredList = provider.passwords.where((item) {
                  return item.account
                      .toLowerCase()
                      .contains(searchQuery);
                }).toList();

                if (filteredList.isEmpty) {
                  return Center(
                    child: Text(
                      "Nothing found for \"$searchQuery\"",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.color ??
                            Colors.white54,
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredList.length,
                  padding: const EdgeInsets.only(bottom: 80),
                  itemBuilder: (context, index) {
                    final item = filteredList[index];

                    return Card(
                      color: Theme.of(context).cardColor,
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),

                      child: ListTile(
                        contentPadding: const EdgeInsets.all(14),

                        leading: CircleAvatar(
                          backgroundColor:
                          Theme.of(context).colorScheme.primary,
                          child: const Icon(
                            Icons.lock,
                            color: Colors.white,
                          ),
                        ),

                        title: Text(
                          item.account,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.color ??
                                Colors.white,
                          ),
                        ),

                        subtitle: Text(
                          item.username,
                          style: TextStyle(
                            color: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.color ??
                                Colors.white70,
                          ),
                        ),

                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Theme.of(context).iconTheme.color,
                        ),

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  DetailsScreen(item: item),
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),

      // ➕ FLOATING BUTTON
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPasswordScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}