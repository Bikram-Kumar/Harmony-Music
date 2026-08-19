import 'dart:io';
import 'package:get/get.dart';
import 'package:harmonymusic/ui/screens/Settings/settings_screen_controller.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

import '../utils/helper.dart';

/*

https://rr7---sn-ci5gup-b50s.googlevideo.com/videoplayback?expire=1787082035&ei=02CEasbpG8SQ3LUP_sTy-AI&ip=122.183.57.78&id=o-ALtQzbuDgZwymr8no6dT3mywKZRtSMmcIeUxJA9eWm_j&itag=251&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ==&cps=1213&met=1787060435,&mh=H3&mm=18,29&mn=sn-ci5gup-b50s,sn-h5576nsz&ms=aub,rdu&mv=m&mvi=7&pcm2cms=yes&pl=24&rms=aub,aub&initcwndbps=1555000&bui=AR3QkAkJMeeJl2FrKzFvhCBx390hnxLOUXG1xB1g75PlSZ6WD20ANXBia-ki_BCg9hiDP_3fMYrH_bTC&spc=KBGBcnlyruuCN-PTFajcg9u3PjV0yVEtmTiGRyDBiGMwB8ZCf6JZC1LT3Hxqx7i834filg&vprv=1&svpuc=1&mime=audio/webm&ns=xULZ5d3LtVqCMGgSoYcGqSsX&rqh=1&gir=yes&clen=4144766&dur=231.021&lmt=1776783301223201&mt=1787059978&fvip=2&keepalive=yes&fexp=51565116,51946838,52112905&c=WEB_REMIX&sefc=1&txp=5532534&n=kjWX3GTR2G2X4g&sparams=expire,ei,ip,id,itag,source,requiressl,xpc,bui,spc,vprv,svpuc,mime,ns,rqh,gir,clen,dur,lmt&lsparams=cps,met,mh,mm,mn,ms,mv,mvi,pcm2cms,pl,rms,initcwndbps&lsig=APaTxxMwRQIhAKEwY23sjo7vGIsHiwfJxG6jL1i_p-Loev3yg2XfV9jBAiBIWtZiH_NyH0QVQOzfcEbSqdnUotQFRRXJxn5KWZz2Gg==&alr=yes&sig=AE0s2JYwRQIgeE1bEBXHGBIB5X8AajeF6GgCHKBEXstjjJ77y6ojSlICIQDWJX6jQsTCJ29UZUqKRSEHEWUMJvSgRClhNZBbeS_2ng==&cpn=G3iep-t_Rs_pkoUQ&cver=1.20260816.07.00&range=292769-558797&rn=7&rbuf=13357&pot=MlNWYWZzlhsotlZdDa_DSPovm_Mp1PLmsmXJ9wn0ipXgMJ8zYUpEpeWnThb4SMVh-A5oM-kO9J9K4ud5urHxSj6GTFhrdDT1ntS3c5Mndoti8U3vcQ==&ump=1&srfvp=1


https://rr5---sn-ci5gup-b50l.googlevideo.com/videoplayback?expire=1787077346&ei=gk6EarKtDpLa4-EP08er6Qo&ip=122.183.57.78&id=o-AO9f6AgbKgR2tnUX73k_pMFVJemcw5pafA0sE9sUAmcb&itag=251&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&cps=286&met=1787055746%2C&mh=KR&mm=31%2C29&mn=sn-ci5gup-b50l%2Csn-h5576nlk&ms=au%2Crdu&mv=m&mvi=5&pl=24&rms=au%2Cau&gcr=in&initcwndbps=1618750&bui=AR3QkAmGijYDq5-HJZ7LUaWFYsizwPLzw59WJDrBu8SkMBMJPfkW0lAtyCc23VV_laBAFZNEl94FIla2&spc=KBGBcpJhmGkRLapJZFzz9VWy8YD4zadRlv-6DSzOd-1uau5cGKd786tUK8RwxnXQ&vprv=1&svpuc=1&mime=audio%2Fwebm&rqh=1&gir=yes&clen=3829532&dur=228.021&lmt=1759773928143580&mt=1787054950&fvip=5&keepalive=yes&fexp=51565116%2C51946838&c=ANDROID&txp=1432534&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cgcr%2Cbui%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Cgir%2Cclen%2Cdur%2Clmt&sig=AE0s2JYwRQIhAJT_kF96DJdnU1Bv8on0iURrgwusE92bdH7VPGdczXeSAiAlwpW8Y4XV92YNzc5ZUnRvidLAcbrm1kTR0hlv4Vx-6A%3D%3D&lsparams=cps%2Cmet%2Cmh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Crms%2Cinitcwndbps&lsig=APaTxxMwRgIhAIkc6SE-hZSgZgev-DonI1LjeapkE9Wp9HN8x4YZzJy0AiEA1OE7cOKdfb-b6D4NyA4JJzO4EnoLfhSON_TNeXs7vRg%3D
https://rr7---sn-ci5gup-b50s.googlevideo.com/videoplayback?expire=1787077346&ei=gk6EarKtDpLa4-EP08er6Qo&ip=122.183.57.78&id=o-AO9f6AgbKgR2tnUX73k_pMFVJemcw5pafA0sE9sUAmcb&itag=251&source=youtube&requiressl=yes&xpc=EgVo2aDSNQ%3D%3D&cps=286&met=1787055746%2C&mh=KR&mm=31%2C29&mn=sn-ci5gup-b50l%2Csn-h5576nlk&ms=au%2Crdu&mv=m&mvi=5&pl=24&rms=au%2Cau&gcr=in&initcwndbps=1618750&bui=AR3QkAmGijYDq5-HJZ7LUaWFYsizwPLzw59WJDrBu8SkMBMJPfkW0lAtyCc23VV_laBAFZNEl94FIla2&spc=KBGBcpJhmGkRLapJZFzz9VWy8YD4zadRlv-6DSzOd-1uau5cGKd786tUK8RwxnXQ&vprv=1&svpuc=1&mime=audio%2Fwebm&rqh=1&gir=yes&clen=3829532&dur=228.021&lmt=1759773928143580&mt=1787054950&fvip=5&keepalive=yes&fexp=51565116%2C51946838&c=ANDROID&txp=1432534&sparams=expire%2Cei%2Cip%2Cid%2Citag%2Csource%2Crequiressl%2Cxpc%2Cgcr%2Cbui%2Cspc%2Cvprv%2Csvpuc%2Cmime%2Crqh%2Cgir%2Cclen%2Cdur%2Clmt&sig=AE0s2JYwRQIhAJT_kF96DJdnU1Bv8on0iURrgwusE92bdH7VPGdczXeSAiAlwpW8Y4XV92YNzc5ZUnRvidLAcbrm1kTR0hlv4Vx-6A%3D%3D&lsparams=cps%2Cmet%2Cmh%2Cmm%2Cmn%2Cms%2Cmv%2Cmvi%2Cpl%2Crms%2Cinitcwndbps&lsig=APaTxxMwRgIhAIkc6SE-hZSgZgev-DonI1LjeapkE9Wp9HN8x4YZzJy0AiEA1OE7cOKdfb-b6D4NyA4JJzO4EnoLfhSON_TNeXs7vRg%3D
*/

class StreamProvider {
  final bool playable;
  final List<Audio>? audioFormats;
  final String statusMSG;
  StreamProvider(
      {required this.playable, this.audioFormats, this.statusMSG = ""});

  static Future<StreamProvider> fetch(String videoId) async {
    final yt = YoutubeExplode();
    
    try {
      final res = await yt.videos.streamsClient.getManifest(videoId, ytClients: [
        YoutubeApiClient.visionos
      ]);
      final audio = res.audioOnly;
      return StreamProvider(
          playable: true,
          statusMSG: "OK",
          audioFormats: audio
              .map((e) => Audio(
                  itag: e.tag,
                  audioCodec:
                      e.audioCodec.contains('mp') ? Codec.mp4a : Codec.opus,
                  bitrate: e.bitrate.bitsPerSecond,
                  // duration: e.duration ?? 0,
                  // loudnessDb: e.loudnessDb,
                  url: e.url.toString(),
                  size: e.size.totalBytes))
              .toList());
    } catch (e) {
      if (e is SocketException) {
        return StreamProvider(
          playable: false,
          statusMSG: "networkError",
        );
      } else if (e is VideoUnplayableException) {
        return StreamProvider(
          playable: false,
          statusMSG: null ?? "Song is unplayable",
        );
      } else if (e is VideoRequiresPurchaseException) {
        return StreamProvider(
          playable: false,
          statusMSG: "Song requires purchase",
        );
      } else if (e is VideoUnavailableException) {
        return StreamProvider(
          playable: false,
          statusMSG: "Song is unavailable",
        );
      } else if (e is YoutubeExplodeException) {
        return StreamProvider(
          playable: false,
          statusMSG: e.message,
        );
      } else {
        return StreamProvider(
          playable: false,
          statusMSG: "Unknown error occurred",
        );
      }
    }
  }


  static Future<void> downloadSong(String filePath, String songId, dynamic onProgress) async {
    final settingsScreenController = Get.find<SettingsScreenController>();
    final downloadingFormat = settingsScreenController.downloadingFormat.string;
    var yt = YoutubeExplode();

    try {
      var manifest = await yt.videos.streamsClient.getManifest(songId);
      
      var audioStreamInfo = downloadingFormat == "opus" ?
          manifest.audioOnly.firstWhere(
            (stream) => stream.tag == 251 || stream.tag == 250,   
            orElse: () => manifest.audioOnly.withHighestBitrate(),
          ) 
        : 
          manifest.audioOnly.firstWhere(
            (stream) => stream.tag == 140 || stream.tag == 139,   
            orElse: () => manifest.audioOnly.withHighestBitrate(),
          ) 
      ;

      var stream = yt.videos.streamsClient.get(audioStreamInfo);

      var totalBytes = audioStreamInfo.size.totalBytes;

      var file = File(filePath);
      var fileStream = file.openWrite();
      int downloaded = 0;

      await for (var data in stream) {
        fileStream.add(data);
        
        downloaded += data.length;

        double progress = downloaded / totalBytes;

        onProgress((progress * 100).toInt());  // passes percentage
        
        
    }

      await fileStream.flush();
      await fileStream.close();
      printINFO('Download completed successfully!');

    } catch(e) {
      print(e);
      rethrow;
    } finally {
      yt.close();
    }

  }
  Audio? get highestQualityAudio =>
      audioFormats?.lastWhere((item) => item.itag == 251 || item.itag == 140,
          orElse: () => audioFormats!.first);

  Audio? get highestBitrateMp4aAudio =>
      audioFormats?.lastWhere((item) => item.itag == 140 || item.itag == 139,
          orElse: () => audioFormats!.first);

  Audio? get highestBitrateOpusAudio =>
      audioFormats?.lastWhere((item) => item.itag == 251 || item.itag == 250,
          orElse: () => audioFormats!.first);

  Audio? get lowQualityAudio =>
      audioFormats?.lastWhere((item) => item.itag == 249 || item.itag == 139,
          orElse: () => audioFormats!.first);

  Map<String, dynamic> get hmStreamingData {
    return {
      "playable": playable,
      "statusMSG": statusMSG,
      "lowQualityAudio": lowQualityAudio?.toJson(),
      "highQualityAudio": highestQualityAudio?.toJson()
    };
  }
}

class Audio {
  final int itag;
  final Codec audioCodec;
  final int bitrate;
  final int duration = 10000;
  final int size;
  final double loudnessDb = 10;
  final String url;
  Audio(
      {required this.itag,
      required this.audioCodec,
      required this.bitrate,
      // required this.duration,
      // required this.loudnessDb,
      required this.url,
      required this.size});

  Map<String, dynamic> toJson() => {
        "itag": itag,
        "audioCodec": audioCodec.toString(),
        "bitrate": bitrate,
        "loudnessDb": loudnessDb,
        "url": url,
        "approxDurationMs": duration,
        "size": size
      };

  factory Audio.fromJson(json) => Audio(
      audioCodec: (json["audioCodec"] as String).contains("mp4a")
          ? Codec.mp4a
          : Codec.opus,
      itag: json['itag'],
      // duration: json["approxDurationMs"] ?? 0,
      bitrate: json["bitrate"] ?? 0,
      // loudnessDb: (json['loudnessDb'])?.toDouble() ?? 0.0,
      url: json['url'],
      size: json["size"] ?? 0);
}

enum Codec { mp4a, opus }
