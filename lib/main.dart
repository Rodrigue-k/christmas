import 'dart:ui' as ui;
import 'dart:html' as html; // Importer html pour le web
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';

import 'animated_text.dart';
import 'bottom_nav_bar.dart';
import 'christmas_tree_painter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Christmas',
          debugShowCheckedModeBanner: false,
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nameController = TextEditingController();
  bool _isPlaying = false;
  late AudioPlayer _audioPlayer;


  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (kIsWeb) {
      _audioPlayer.setSourceUrl('assets/audio/christmas_party.mp3');
    } else {
      _audioPlayer.setSource(AssetSource('assets/audio/christmas_party.mp3'));
    }
    _audioPlayer.setReleaseMode(ReleaseMode.loop);
  }

  Future<void> _toggleSound() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      if (kIsWeb) {
        await _audioPlayer.setSourceUrl('assets/audio/christmas_party.mp3');
      } else {
        await _audioPlayer.setSource(
            AssetSource('assets/audio/christmas_party.mp3'));
      }
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }


  Future<void> _generateAndDownloadImage() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Charge l'image de base
    final imageData = await rootBundle.load('assets/im/base_card.jpg');
    final image = await decodeImageFromList(imageData.buffer.asUint8List());
    canvas.drawImage(image, Offset.zero, Paint());

    // Ajoute le texte du nom
    final textPainter = TextPainter(
      text: TextSpan(
        text: _nameController.text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 80,
          fontFamily: 'LobsterTwo',
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final textOffset = Offset(
      (image.width / 2) - (textPainter.width / 2),
      (image.height / 2) - (textPainter.height / 2),
    );
    textPainter.paint(canvas, textOffset);

    final picture = recorder.endRecording();
    final imageRendered = await picture.toImage(image.width, image.height);
    final byteData = await imageRendered.toByteData(
        format: ui.ImageByteFormat.png);
    final buffer = byteData!.buffer.asUint8List();

    // Créer un objet Blob et un lien de téléchargement pour le web
    final blob = html.Blob([buffer]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..target = 'blank'
      ..download = 'custom_card.png'; // Le nom du fichier à télécharger
    anchor.click(); // Simuler le clic pour démarrer le téléchargement

    // Notifie l'utilisateur
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Image téléchargée avec succès !')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: const Color(0xFF0A1C3A),
      body: Stack(
        children: [
          SnowFallAnimation(
            config: SnowfallConfig(
              maxSnowflakeSize: 15,
              numberOfSnowflakes: 150,
              speed: 1.0,
              customEmojis: const ['❄️', '🎅', '🎄', '🎁', '⭐'],
              windForce: 0.3,
              snowColor: Colors.white,
            ),
          ),
          Center(
            child: width <= 768
                ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedTextWidget(),
                ChristmasTreeSection(),
              ],
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    AnimatedTextWidget(isLargeScreen: true),
                    const SizedBox(height: 15),
                    _buildTextField(), // TextField pour le nom
                    const SizedBox(height: 20),
                    _buildDownloadButton(), // Bouton de téléchargement
                    const SizedBox(height: 20),
                    _buildSoundButton(), // Bouton pour le son
                  ],
                ),
                ChristmasTreeSection(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: width <= 768
          ? FloatingActionButton(
        onPressed: () {
          _showBottomSheet(context); // Montre les options dans un menu
        },
        backgroundColor: Colors.purple,
        child: const Icon(Icons.menu), // Icône de menu
      )
          : null,
      bottomNavigationBar: BottomNavBar(width: width),
    );
  }

  // **Widgets**
  Widget _buildTextField() {
    return SizedBox(
      height: 80,
      width: 200,
      child: TextField(
        controller: _nameController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Enter a name',
          hintStyle: const TextStyle(color: Colors.white),
          labelStyle: const TextStyle(color: Colors.white),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        shadowColor: Colors.transparent,
      ),
      onPressed: _generateAndDownloadImage,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
          child: const Text(
            'Download',
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSoundButton() {
    return GestureDetector(
      onTap: _toggleSound,
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.pink, Colors.redAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.4),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            _isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  // **Menu Contextuel**
  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Champ de texte
              SizedBox(
                height: 80,
                width: double.infinity,
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'Enter a name',
                    hintStyle: const TextStyle(color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Bouton de téléchargement
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _generateAndDownloadImage,
                child: const Text(
                  'Download',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Bouton pour le son
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  _toggleSound();
                  Navigator.pop(context); // Ferme le menu après l'action
                },
                child: Text(
                  _isPlaying ? 'Mute Sound' : 'Play Sound',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

}