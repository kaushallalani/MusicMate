import 'package:flutter/material.dart';
import 'package:musicmate/components/index.dart';
import 'package:musicmate/constants/theme.dart';
import 'package:musicmate/models/song.dart';

class CustomSongTile extends StatelessWidget {
  final VoidCallback? onTap;
  final Song songs;
  final Widget? otherItems;
  const CustomSongTile({super.key, this.onTap, required this.songs, this.otherItems});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(),
            ),
            width: Metrics.width(context) * 0.15,
            height: Metrics.width(context) * 0.15,
            child: Image.network(
              songs.albumArtImagePath,
              height: Metrics.width(context) * 0.15,
              width: Metrics.width(context) * 0.15,
              fit: BoxFit.fill,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: Metrics.width(context) * 0.04),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextComponent(
                    text: songs.songName,
                    textAlign: TextAlign.left,
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: FontSize.xmedium,
                    ),
                  ),
                  TextComponent(
                    text: songs.artistName,
                    textAlign: TextAlign.left,
                    textStyle: const TextStyle(color: AppColor.grey),
                  ),
                  otherItems?? Container()
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
