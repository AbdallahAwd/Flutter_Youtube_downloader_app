import 'package:flutter/material.dart';
import 'package:flutter_youtube_downloader/flutter_youtube_downloader.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';
import 'package:timeago/timeago.dart'as timeago;
import 'package:youtube_viewer/layout/youtube_viewer.dart';
class YoutubeDownloadPage extends StatefulWidget {
  const YoutubeDownloadPage({Key? key}) : super(key: key);

  @override
  State<YoutubeDownloadPage> createState() => _YoutubeDownloadPageState();
}

class _YoutubeDownloadPageState extends State<YoutubeDownloadPage> {
  var urlController = TextEditingController();
  var youtubeVideoName = '';
  var youtubeId = '';
  var youtubeDescription = '';
  var youtubeUrl = '';
  DateTime youtubeTime = DateTime.now();
  bool isDownloading = false;
  double progress = 0.0;
  
 
 
 
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // initDownloadsDirectoryState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller:urlController,
                  onChanged: (value)
                  {
                    getVideoInfo(value);
                  },
                  decoration:  InputDecoration(
                    hintText: 'Paste Video Url',
                    prefixIcon: const Icon(FontAwesomeIcons.paste),
                    suffixIcon: IconButton(onPressed: ()
                    {
                      urlController.clear();
                    }, icon: const Icon(Icons.refresh))
                  ),
                ),
                const SizedBox(height: 50.0,),
                if (youtubeVideoName != '') 
                InkWell(
                onTap: ()
                {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> YoutubeViewer(
                    url: youtubeUrl ,
                    title: youtubeVideoName,
                    description: youtubeDescription,
                    time:youtubeTime,
                  )));
                },
                  child: Card(
                    elevation: 20.0,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.network(
                            'https://img.youtube.com/vi/$youtubeId/0.jpg' ,
                          fit: BoxFit.cover,
                          ),
                          Text(youtubeVideoName , style: Theme.of(context).textTheme.bodyText1,),
                          Text(youtubeDescription ,style: Theme.of(context).textTheme.caption,maxLines: 3,),
                           Row(
                             mainAxisAlignment: MainAxisAlignment.end,
                             children: [
                               Text(timeago.format(youtubeTime) ,style: Theme.of(context).textTheme.caption,),
                             ],
                           ),

                        ],
                      ),
                    ),
                  ),
                ) else Column(
                  children: [
                    const Icon(FontAwesomeIcons.youtube , size: 150,color: Colors.red,),
                    const SizedBox(height: 20.0,),
                    Text('Paste URL' , style: Theme.of(context).textTheme.caption?.copyWith(fontSize: 20.0),),
                  ],
                ),
                const SizedBox(height: 100.0,),
                if (youtubeVideoName != '') TextButton.icon(
                  onPressed: () {
                    showBottom(youtubeUrl);
                    print(youtubeUrl);
                  },
                  icon: const Icon(Icons.download),
                  label: const Text('Download'),

                ) else const SizedBox(),
                isDownloading ? Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: LinearProgressIndicator(
                    value: progress,
                  ),
                ) : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getVideoInfo(videoId) async
  {
    var videoInfo = YoutubeExplode();
    var video = await videoInfo.videos.get(videoId);
    setState(() {
      youtubeVideoName = video.title;
      youtubeId = video.id.toString();
      youtubeDescription = video.description;
      youtubeUrl = video.url;
      youtubeTime = video.publishDate as DateTime;
    });
  }
  void showBottom(url)
  => showModalBottomSheet(context: context, builder: (context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children:  [
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: ()
                  {
                    downloadVideo(url);
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(FontAwesomeIcons.video ,size: 40.0,),
                      SizedBox(height: 20,),
                      Text('Download As video'),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: InkWell(
                  onTap: (){},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.audiotrack_outlined ,size: 40.0,),
                      SizedBox(height: 20,),
                      Text('Download As audio'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  });
  // Future<void> downloadVideos(id) async {
  //   var permisson = await Permission.storage.request();
  //   if (permisson.isGranted) {
  //     //download video
  //     if (urlController.text != '') {
  //       setState(() => isDownloading = true);
  //
  //       //download video
  //       setState(() => progress = 0);
  //       var _youtubeExplode = YoutubeExplode();
  //       //get video metadata
  //       var video = await _youtubeExplode.videos.get(id);
  //       var manifest =
  //       await _youtubeExplode.videos.streamsClient.getManifest(id);
  //       var streams = manifest.audio.withHighestBitrate();
  //       var audio = streams;
  //       var audioStream = _youtubeExplode.videos.streamsClient.get(audio);
  //       //create a directory
  //       // Directory appDocDir = await getApplicationDocumentsDirectory();
  //       String appDocPath = downloadsDirectory!.path;
  //       var file = File('$appDocPath/${video.id}');
  //       //delete file if exists
  //       if (file.existsSync()) {
  //         file.deleteSync();
  //       }
  //       var output = file.openWrite(mode: FileMode.writeOnlyAppend);
  //       var size = audio.size.totalBytes;
  //       var count = 0;
  //
  //       await for (final data in audioStream) {
  //         // Keep track of the current downloaded data.
  //         count += data.length;
  //         // Calculate the current progress.
  //         double val = ((count / size));
  //         var msg = '${video.title} Downloaded to $appDocPath/${video.title}';
  //         for (val; val == 1.0; val++) {
  //           ScaffoldMessenger.of(context)
  //               .showSnackBar(SnackBar(content: Text(msg)));
  //         }
  //         setState(() => progress = val);
  //
  //         // Write to file.
  //         output.add(data);
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('add youtube video url first!')));
  //       setState(() => isDownloading = false);
  //     }
  //   } else {
  //     await Permission.storage.request();
  //   }
  // }
  Future<void> downloadVideo(String url) async {
    var video =await YoutubeExplode().videos.get(url);
    final result = await FlutterYoutubeDownloader.downloadVideo(
        url, '${video.title}.', 18);
    print(result);
  }
  
}
