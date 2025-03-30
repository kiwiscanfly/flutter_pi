import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_pi/services/spotify_play_service.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String greeting = dotenv.env['GREETING'] ?? 'Hello, World!';
  final SpotifyPlayService playService = SpotifyPlayService();

  void changeGreeting() {
    setState(() {
      greeting = 'That tickles!!!';
    });

    // Change back to the original greeting after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        greeting = dotenv.env['GREETING'] ?? 'Hello, World!';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print('Build Home');
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Stack(
        children: [
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(color: Colors.white, fontSize: 84),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: changeGreeting,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  ),
                  child: const Text(
                    'Push Me!',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ],
            ),
          ),

          // Bottom-right buttons
          Positioned(
            bottom: 20,
            right: 20,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () => {
                    playService.getDevices().then((devices) {
                      for (var device in devices) {
                        print('Device: ${device.name}, ID: ${device.id}');
                        if (device.name == dotenv.env['SPEAKER_NAME']) {
                          playService.transferPlayback(device.id).then((_) {
                            print('Playback transferred to ${device.name}');
                          }).catchError((error) {
                            print('Error transferring playback: $error');
                          });
                        }
                      }
                    }).catchError((error) {
                      print('Error fetching devices: $error');
                    })
                  },
                  icon: const Icon(Icons.speaker),
                  color: Colors.white,
                  iconSize: 46,
                ),
                IconButton(
                  onPressed: playService.previousTrack,
                  icon: const Icon(Icons.skip_previous),
                  color: Colors.white,
                  iconSize: 46,
                ),
                IconButton(
                  onPressed: () => playService.playTrack(null),
                  icon: const Icon(Icons.play_arrow),
                  color: Colors.white,
                  iconSize: 46,
                ),
                IconButton(
                  onPressed: playService.pauseTrack,
                  icon: const Icon(Icons.pause),
                  color: Colors.white,
                  iconSize: 46,
                ),
                IconButton(
                  onPressed: playService.nextTrack,
                  icon: const Icon(Icons.skip_next),
                  color: Colors.white,
                  iconSize: 46,
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}