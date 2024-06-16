import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

class Search extends StatelessWidget {
  const Search({super.key});

  Future<dynamic> spotifyLogin() async {
      await SpotifySdk.connectToSpotifyRemote(clientId: '3222f0dac2e24c908781642f43c8506d', redirectUrl: 'musicmate://callback').then((res) {
        Logger().d(res);
      }).catchError((e){
          Logger().d(e.toString());
      });

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xffC4DFCB),
      child: Center(
        child:ElevatedButton( onPressed: spotifyLogin, child: const Text('Spotify'),)
      ),
    );
  }
}
