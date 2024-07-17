import 'package:fingerfy/providers/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:fingerfy/services/auth_service.dart';
import 'challenge.dart';

class ProfilePage extends StatefulWidget {
  final String userID;

  const ProfilePage({super.key, required this.userID});

  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  final TextEditingController _nameController = TextEditingController();
  File? _image;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
      profileProvider.startListening(widget.userID);
      _nameController.text = profileProvider.profile?.displayName ?? '';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final profileData = profileProvider.profile;
    final authService = context.watch<AuthService>();  // Usa AuthService

    if (profileProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            onPressed: () async {
              if (_isEditing) {
                if (_image != null) {
                  String imageUrl = await authService.uploadProfileImage(profileData!.uid, _image!);
                  profileProvider.updateProfile(profileData.copyWith(photoUrl: imageUrl));
                }
                profileProvider.updateProfile(profileData!.copyWith(displayName: _nameController.text));
              }
              setState(() {
                _isEditing = !_isEditing;
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: _isEditing ? _pickImage : null,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null
                    ? FileImage(_image!)
                    : NetworkImage(profileData?.photoUrl ?? '') as ImageProvider,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Text('Email: ${profileData?.email ?? ''}'),
            const SizedBox(height: 20),
            Text('Touches: ${profileData?.touches ?? 0}'),
            Text('Trofei: ${profileData?.trophies.length ?? 0}'),
            Text('Scrolls: ${profileData?.scrolls ?? 0}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChallengePage(userID: widget.userID),
                  ),
                );
              },
              child: const Text('Visualizza Sfide'),
            ),
          ],
        ),
      ),
    );
  }
}
