import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:timeago/timeago.dart'as timeago;
class YoutubeViewer extends StatefulWidget {
  final String url;
  final String title;
  final String description;
  final DateTime time;
  const YoutubeViewer({Key? key ,required this.url, required this.title, required this.description, required this.time}) : super(key: key);

  @override
  State<YoutubeViewer> createState() => _YoutubeViewerState();
}

class _YoutubeViewerState extends State<YoutubeViewer> {
  late YoutubePlayerController _controller;
  @override
  void initState() {
   _controller = YoutubePlayerController(initialVideoId: convertToId(widget.url));
    super.initState();
  }
  @override
  void dispose() {
    /// TODO: implement dispose
    super.dispose();
    _controller.pause();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              YoutubePlayerBuilder(
                builder: (context , player)
                {
                  return YoutubePlayer(controller: _controller);
                },
                player: YoutubePlayer(
                  controller: _controller,
                  width: MediaQuery.of(context).size.width,
                ),

              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(widget.title,style: Theme.of(context).textTheme.bodyText1?.copyWith(fontSize: 18)),
                    Text(timeago.format(widget.time) ,style: Theme.of(context).textTheme.caption,),
                    const SizedBox(height: 50.0,),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String convertToId(url)
  {
    return YoutubePlayer.convertUrlToId(url).toString();
  }
}
