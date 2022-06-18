import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/auth_store.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthStore _authStore;

  @override
  void initState() {
    _authStore = Modular.get<AuthStore>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            AnimatedBuilder(
              animation: _authStore,
              builder: (_, __) => CircleAvatar(
                radius: 48.0,
                backgroundImage: _authStore.user!.profileUrl != null
                    ? CachedNetworkImageProvider(_authStore.user!.profileUrl!)
                    : null,
                child: _authStore.user!.profileUrl == null
                    ? const Icon(
                        Icons.person,
                        size: 48.0,
                      )
                    : null,
              ),
            ),
            TextButton(
              onPressed: () {
                if (Platform.isIOS) {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (_) => CupertinoActionSheet(
                      message: const Text('Escolha a imagem'),
                      cancelButton: const Text('Cancelar'),
                      actions: _buildBottomSheetButtons(),
                    ),
                  );
                } else {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => BottomSheet(
                      onClosing: () {},
                      builder: (context) => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: _buildBottomSheetButtons(),
                      ),
                    ),
                  );
                }
              },
              child: const Text('Alterar imagem'),
            ),
            Text(
              _authStore.user!.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28.0,
              ),
            ),
            Text(
              _authStore.user!.email,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 50.0),
            FractionallySizedBox(
              widthFactor: .7,
              child: ElevatedButton(
                onPressed: () {
                  _authStore.logout();
                  Modular.to.navigate('/auth/');
                },
                child: const Text('Sair'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildBottomSheetButtons() {
    return [
      TextButton(
        onPressed: () {
          _authStore.setProfileImage(ImageSource.gallery);
          Navigator.of(context).pop();
        },
        child: const Text('Galeria'),
      ),
      TextButton(
        onPressed: () {
          _authStore.setProfileImage(ImageSource.camera);
          Navigator.of(context).pop();
        },
        child: const Text('Câmera'),
      ),
    ];
  }
}
