import 'package:flutter/material.dart';

// Real example: Todo list management application
void main(List<String> args) {
  runApp(DebugExampleApp());
}

class DebugExampleApp extends StatelessWidget {
  const DebugExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Learn Flutter Debug',
      home: TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  TodoListScreenState createState() => TodoListScreenState();
}

class TodoListScreenState extends State<TodoListScreen> {
  // Todo list
  List<String> todoList = [];
  TextEditingController textController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    // Print to console when app initializes
    debugPrint("🚀 App has started!");
    debugPrint("📝 Initial list: $todoList");
  }
  
  // Add new todo
  void addTodo() {
    String newTodo = textController.text.trim();
    
    // Debug: Print what user entered
    debugPrint("🔍 User entered: '$newTodo'");
    
    if (newTodo.isNotEmpty) {
      setState(() {
        todoList.add(newTodo);
        textController.clear();
      });
      
      // Debug: Print list after adding
      debugPrint("✅ Added todo: '$newTodo'");
      debugPrint("📋 Current list: $todoList");
      debugPrint("📊 Total todos: ${todoList.length}");
    } else {
      // Debug: Warning when input is empty
      debugPrint("⚠️ Cannot add empty todo!");
    }
  }
  
  // Remove todo
  void removeTodo(int index) {
    String removedItem = todoList[index];
    
    // Debug: Print info before removing
    debugPrint("🗑️ Preparing to remove: '$removedItem' at position $index");
    
    setState(() {
      todoList.removeAt(index);
    });
    
    // Debug: Print state after removing
    debugPrint("❌ Removed: '$removedItem'");
    debugPrint("📋 Remaining list: $todoList");
  }
  
  // Mark complete (simulation)
  void markComplete(int index) {
    String item = todoList[index];
    debugPrint("✨ Mark complete: '$item'");
    
    // Show notification
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Completed: $item"),
        duration: Duration(seconds: 2),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Debug: Print every time rebuild happens
    debugPrint("🔄 Rebuilding interface...");
    debugPrint("📊 Current todo count: ${todoList.length}");
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List - Debug Example'),
        backgroundColor: Colors.teal,
        actions: [
          // Debug info button
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              // Print detailed debug info
              debugPrint("🔍 === DEBUG INFO ===");
              debugPrint("📱 Screen: ${MediaQuery.of(context).size}");
              debugPrint("📋 List: $todoList");
              debugPrint("🔢 Count: ${todoList.length}");
              debugPrint("⌨️ Text controller: '${textController.text}'");
              debugPrint("========================");
              
              // Show dialog with info
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text("Debug Info"),
                  content: Text(
                    "Todo count: ${todoList.length}\n"
                    "List: ${todoList.join(', ')}"
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      
      body: Column(
        children: [
          // Input section
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: "Enter new todo...",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Debug: Print every time user types
                      debugPrint("⌨️ Typing: '$value'");
                    },
                    onSubmitted: (value) {
                      // Debug: When user presses Enter
                      debugPrint("⏎ Pressed Enter with: '$value'");
                      addTodo();
                    },
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: addTodo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                  child: Text("Add"),
                ),
              ],
            ),
          ),
          
          // Display count
          Container(
            padding: EdgeInsets.all(8),
            child: Text(
              "Total: ${todoList.length} todos",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          
          // Todo list
          Expanded(
            child: todoList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.inbox, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "No todos yet",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: todoList.length,
                    itemBuilder: (context, index) {
                      // Debug: Print every time creating item
                      debugPrint("🏗️ Creating item $index: '${todoList[index]}'");
                      
                      return Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.teal,
                            child: Text(
                              "${index + 1}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          title: Text(
                            todoList[index],
                            style: TextStyle(fontSize: 16),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Complete button
                              IconButton(
                                icon: Icon(Icons.check, color: Colors.green),
                                onPressed: () => markComplete(index),
                              ),
                              // Delete button
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeTodo(index),
                              ),
                            ],
                          ),
                          onTap: () {
                            // Debug: When tap on item
                            debugPrint("👆 Tapped item $index: '${todoList[index]}'");
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      
      // Quick add button
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add sample todo for testing
          String sampleTodo = "Todo ${todoList.length + 1}";
          debugPrint("🎯 Adding sample todo: '$sampleTodo'");
          
          setState(() {
            todoList.add(sampleTodo);
          });
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
  
  @override
  void dispose() {
    // Debug: When widget is destroyed
    debugPrint("🔚 Widget is being destroyed...");
    textController.dispose();
    super.dispose();
  }
}