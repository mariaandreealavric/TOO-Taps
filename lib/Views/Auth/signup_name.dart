import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:fingerfy/services/auth_service.dart';

class SignUpNamePage extends StatefulWidget {
  final String email;
  final String password;

  const SignUpNamePage({super.key, required this.email, required this.password});

  @override
  SignUpNamePageState createState() => SignUpNamePageState();
}

class SignUpNamePageState extends State<SignUpNamePage> {
  final TextEditingController _nameController = TextEditingController();
  File? _image;
  bool _isSigningUp = false;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _signUp() async {
    if (_image == null || _nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Per favore, inserisci il tuo nome e seleziona un\'immagine')),
      );
      return;
    }

    if (!_isValidEmail(widget.email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Per favore, inserisci un\'email valida')),
      );
      return;
    }

    setState(() {
      _isSigningUp = true;
    });

    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signUpWithEmailAndPassword(
        widget.email,
        widget.password,
        _nameController.text,
        _image!,
      );

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore durante la registrazione: $e')),
        );
      }
    } finally {
      setState(() {
        _isSigningUp = false;
      });
    }
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegExp.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inserisci Nome e Immagine'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: _image != null ? FileImage(_image!) : null,
                child: _image == null ? const Icon(Icons.add_a_photo, size: 50) : null,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSigningUp ? null : _signUp,
              child: _isSigningUp ? const CircularProgressIndicator() : const Text('Registrati'),
            ),
          ],
        ),
      ),
    );
  }
}
