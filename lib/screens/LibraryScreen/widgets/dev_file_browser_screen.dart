import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:living_way/core/core.dart';
import 'package:path/path.dart' as path;

class DevFileBrowserScreen extends StatefulWidget {
  const DevFileBrowserScreen({super.key});

  @override
  State<DevFileBrowserScreen> createState() => _DevFileBrowserScreenState();
}

class _DevFileBrowserScreenState extends State<DevFileBrowserScreen> {
  List<File> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    setState(() => _isLoading = true);
    final files = await getStorageFiles();
    if (!mounted) return;

    setState(() {
      _files = files..sort((a, b) => a.path.compareTo(b.path));
      _isLoading = false;
    });
  }

  Future<void> _deleteFile(File file) async {
    try {
      await file.delete();
      if (!mounted) return;
      setState(() => _files.removeWhere((item) => item.path == file.path));
    } catch (error) {
      logger.e(error);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete ${path.basename(file.path)}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (appFlavor != 'dev') return const SizedBox.shrink();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Developer files'),
        actions: [
          IconButton(
            onPressed: _isLoading ? null : _loadFiles,
            tooltip: 'Refresh files',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _files.isEmpty
              ? const Center(child: Text('No files found'))
              : ListView.builder(
                  itemCount: _files.length,
                  itemBuilder: (context, index) {
                    final file = _files[index];
                    return ListTile(
                      title: Text(path.basename(file.path)),
                      subtitle: Text(file.path),
                      trailing: IconButton(
                        tooltip: 'Delete file',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _deleteFile(file),
                      ),
                    );
                  },
                ),
    );
  }
}
