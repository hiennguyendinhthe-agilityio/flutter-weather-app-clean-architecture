import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/file_package_service.dart';
import '../services/web_file_service.dart';

class FilePackageDemoScreen extends StatefulWidget {
  const FilePackageDemoScreen({super.key});

  @override
  State<FilePackageDemoScreen> createState() => _FilePackageDemoScreenState();
}

class _FilePackageDemoScreenState extends State<FilePackageDemoScreen> {
  final FilePackageService _fileService = FilePackageService();
  final TextEditingController _fileNameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _directoryController = TextEditingController();

  String _output = '';
  List<String> _fileList = [];
  List<Map<String, dynamic>> _directoryContent = [];
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
  }

  Future<void> _initializeService() async {
    try {
      await _fileService.initialize();
      setState(() {
        _isInitialized = true;
      });
      _setOutput(' Service initialized successfully!');
      _refreshFileList();
    } catch (e) {
      _setOutput('Error initializing service: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('File Package Demo'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: !_isInitialized
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Initializing File Service...'),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Input Section
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'File Operations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: _fileNameController,
                            decoration: const InputDecoration(
                              labelText: 'File Name',
                              hintText: 'example.txt',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 12),

                          TextField(
                            controller: _contentController,
                            decoration: const InputDecoration(
                              labelText: 'Content',
                              border: OutlineInputBorder(),
                            ),
                            maxLines: 3,
                          ),
                          const SizedBox(height: 16),

                          // File Operation Buttons
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: _writeFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Write File'),
                              ),
                              ElevatedButton(
                                onPressed: _readFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Read File'),
                              ),
                              ElevatedButton(
                                onPressed: _appendFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Append to File'),
                              ),
                              ElevatedButton(
                                onPressed: _deleteFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete File'),
                              ),
                              ElevatedButton(
                                onPressed: _getFileInfo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Get File Info'),
                              ),
                              ElevatedButton(
                                onPressed: _backupFile,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Backup File'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Directory Operations
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Directory Operations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          TextField(
                            controller: _directoryController,
                            decoration: const InputDecoration(
                              labelText: 'Directory Name',
                              hintText: 'my_folder',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: _createDirectory,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.indigo,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Create Directory'),
                              ),
                              ElevatedButton(
                                onPressed: _listDirectory,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.cyan,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('List Contents'),
                              ),
                              ElevatedButton(
                                onPressed: _deleteDirectory,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Delete Directory'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Utility Operations
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Utility Operations',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),

                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              ElevatedButton(
                                onPressed: _refreshFileList,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Refresh Files'),
                              ),
                              ElevatedButton(
                                onPressed: _findFiles,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.brown,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Find Files (.txt)'),
                              ),
                              ElevatedButton(
                                onPressed: _cleanupOldFiles,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepOrange,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Cleanup (7 days)'),
                              ),
                              if (kIsWeb) ...[
                                ElevatedButton(
                                  onPressed: _showWebInfo,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Web Info'),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // File List
                  if (_fileList.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'File List',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...(_fileList.map(
                              (file) => ListTile(
                                leading: const Icon(Icons.insert_drive_file),
                                title: Text(file),
                                dense: true,
                                onTap: () {
                                  _fileNameController.text = file;
                                },
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Directory Content
                  if (_directoryContent.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Directory Content',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...(_directoryContent.map(
                              (item) => ListTile(
                                leading: Icon(
                                  item['type'] == 'file'
                                      ? Icons.insert_drive_file
                                      : Icons.folder,
                                ),
                                title: Text(item['name']),
                                subtitle: Text(item['type']),
                                dense: true,
                              ),
                            )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Output
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Output',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            height: 200,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey[50],
                            ),
                            child: SingleChildScrollView(
                              child: Text(
                                _output.isEmpty
                                    ? 'Results will be displayed here...'
                                    : _output,
                                style: const TextStyle(fontFamily: 'monospace'),
                              ),
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

  // File Operations
  Future<void> _writeFile() async {
    if (_fileNameController.text.isEmpty || _contentController.text.isEmpty) {
      _setOutput('Please enter a file name and content');
      return;
    }

    try {
      await _fileService.writeFile(
        _fileNameController.text,
        _contentController.text,
      );
      _setOutput(' File written: ${_fileNameController.text}');
      _refreshFileList();
      _contentController.clear();
    } catch (e) {
      _setOutput('Error writing file: $e');
    }
  }

  Future<void> _readFile() async {
    if (_fileNameController.text.isEmpty) {
      _setOutput('Please enter a file name');
      return;
    }

    try {
      final content = await _fileService.readFile(_fileNameController.text);
      _setOutput('📖 Content of "${_fileNameController.text}":\n\n$content');
    } catch (e) {
      _setOutput('Error reading file: $e');
    }
  }

  Future<void> _appendFile() async {
    if (_fileNameController.text.isEmpty || _contentController.text.isEmpty) {
      _setOutput('Please enter a file name and content');
      return;
    }

    try {
      await _fileService.appendToFile(
        _fileNameController.text,
        _contentController.text,
      );
      _setOutput(' Appended content to file: ${_fileNameController.text}');
      _contentController.clear();
    } catch (e) {
      _setOutput('Error appending to file: $e');
    }
  }

  Future<void> _deleteFile() async {
    if (_fileNameController.text.isEmpty) {
      _setOutput('Please enter a file name');
      return;
    }

    try {
      await _fileService.deleteFile(_fileNameController.text);
      _setOutput(' Deleted file: ${_fileNameController.text}');
      _refreshFileList();
      _fileNameController.clear();
    } catch (e) {
      _setOutput('Error deleting file: $e');
    }
  }

  Future<void> _getFileInfo() async {
    if (_fileNameController.text.isEmpty) {
      _setOutput('Please enter a file name');
      return;
    }

    try {
      final info = await _fileService.getFileInfo(_fileNameController.text);
      if (info['exists']) {
        final size = _fileService.formatFileSize(info['size']);
        _setOutput('''
📋 File Info for "${_fileNameController.text}":
• Path: ${info['path']}
• Name: ${info['name']}
• Size: $size (${info['size']} bytes)
• Modified: ${info['modified']}
• Type: ${info['type']}
        ''');
      } else {
        _setOutput('File does not exist: ${_fileNameController.text}');
      }
    } catch (e) {
      _setOutput('Error getting file info: $e');
    }
  }

  Future<void> _backupFile() async {
    if (_fileNameController.text.isEmpty) {
      _setOutput('Please enter a file name');
      return;
    }

    try {
      await _fileService.backupFile(_fileNameController.text);
      _setOutput(' Backed up file: ${_fileNameController.text}');
      _refreshFileList();
    } catch (e) {
      _setOutput('Error backing up file: $e');
    }
  }

  // Directory Operations
  Future<void> _createDirectory() async {
    if (_directoryController.text.isEmpty) {
      _setOutput('Please enter a directory name');
      return;
    }

    try {
      await _fileService.createDirectory(_directoryController.text);
      _setOutput(' Created directory: ${_directoryController.text}');
    } catch (e) {
      _setOutput('Error creating directory: $e');
    }
  }

  Future<void> _listDirectory() async {
    if (_directoryController.text.isEmpty) {
      _setOutput('Please enter a directory name');
      return;
    }

    try {
      final content = await _fileService.listDirectory(
        _directoryController.text,
      );
      setState(() {
        _directoryContent = content;
      });

      if (content.isEmpty) {
        _setOutput(
          '📁 Directory "${_directoryController.text}" is empty or does not exist',
        );
      } else {
        _setOutput(
          '📁 Directory content for "${_directoryController.text}": ${content.length} items',
        );
      }
    } catch (e) {
      _setOutput('Error listing directory: $e');
    }
  }

  Future<void> _deleteDirectory() async {
    if (_directoryController.text.isEmpty) {
      _setOutput('Please enter a directory name');
      return;
    }

    try {
      await _fileService.deleteDirectory(_directoryController.text);
      _setOutput(' Deleted directory: ${_directoryController.text}');
      setState(() {
        _directoryContent.clear();
      });
      _directoryController.clear();
    } catch (e) {
      _setOutput('Error deleting directory: $e');
    }
  }

  // Utility Operations
  Future<void> _refreshFileList() async {
    try {
      final files = await _fileService.getAllFiles();
      setState(() {
        _fileList = files;
      });
      _setOutput('🔄 Refreshed file list: ${files.length} files');
    } catch (e) {
      _setOutput('Error refreshing files: $e');
    }
  }

  Future<void> _findFiles() async {
    try {
      final files = await _fileService.findFiles('.txt');
      _setOutput('🔍 Found ${files.length} .txt files:\n${files.join('\n')}');
    } catch (e) {
      _setOutput('Error finding files: $e');
    }
  }

  Future<void> _cleanupOldFiles() async {
    try {
      final deletedCount = await _fileService.cleanupOldFiles(7);
      _setOutput('🧹 Deleted $deletedCount files older than 7 days');
      _refreshFileList();
    } catch (e) {
      _setOutput('Error during cleanup: $e');
    }
  }

  Future<void> _showWebInfo() async {
    if (kIsWeb) {
      try {
        final info = await WebFileService.instance.getStorageInfo();
        final infoText =
            '''
🌐 Web Platform Info:
• Platform: ${info['platform']}
• File System: ${info['file_system']}
• File Count: ${info['file_count']}
• Total Size: ${_fileService.formatFileSize(info['total_size'])}
• Base Path: ${info['base_path']}
• Persistent: ${info['persistent']}

⚠️ ${info['note']}
        ''';
        _setOutput(infoText);
      } catch (e) {
        _setOutput('Error getting web info: $e');
      }
    }
  }

  void _setOutput(String message) {
    setState(() {
      _output = message;
    });
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    _contentController.dispose();
    _directoryController.dispose();
    super.dispose();
  }
}
