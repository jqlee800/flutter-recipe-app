import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Recipes'),
      ),
      body: Center(
        child: ListView.builder(
            itemCount: 50,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: ListTile(
                  tileColor: Colors.grey.shade100,
                  leading: const Icon(Icons.list),
                  trailing: const Text(
                    "Main Courses",
                    style: TextStyle(color: Colors.green, fontSize: 15),
                  ),
                  title: Text("Signature Fish and Chips"),
                  subtitle: Text("Fried fish & fries"),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Add Recipe',
        child: const Icon(Icons.add),
      ),
    );
  }
}
