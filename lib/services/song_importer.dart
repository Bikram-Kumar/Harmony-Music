import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:harmonymusic/models/media_Item_builder.dart';
import 'package:harmonymusic/ui/screens/Library/library_controller.dart';
import 'package:harmonymusic/ui/screens/Settings/settings_screen_controller.dart';
import 'package:harmonymusic/ui/widgets/snackbar.dart';
import 'package:harmonymusic/utils/helper.dart';
import 'package:hive/hive.dart';



class SongImporter {

  static Future<void> importSong() async {
    Completer<void> complete = Completer();

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'm4a', 'wav', 'opus'],
      dialogTitle: 'importSong'.tr, 
    );

    if (result == null || result.files.isEmpty) {
      complete.complete();
      return complete.future;
    }

    final PlatformFile pickedFile = result.files.first;
    final String? originalFilePath = pickedFile.path;

    if (originalFilePath == null) {
      complete.complete();
      return complete.future;
    }

    try {
      final settingsScreenController = Get.find<SettingsScreenController>();
      final dirPath = settingsScreenController.downloadLocationPath.string;

      printINFO(dirPath);

      final metadata = await MetadataRetriever.fromFile(File(originalFilePath));
      
      final cleanTitle = pickedFile.name.replaceAll(RegExp(r'\.[a-zA-Z0-9]+$'), '');
      final String title = metadata.trackName ?? cleanTitle;
      final String artist = metadata.trackArtistNames?.join(', ') ?? 'Unknown Artist';
      final String album = metadata.albumName ?? 'Unknown Album';
      final int bitrate = metadata.bitrate ?? 320;
      

      final RegExp invalidChar = RegExp(r'Container.|\/|\\|\"|\<|\>|\*|\?|\:|\!|\[|\]|\¡|\||\%');
      final String safeFileName = cleanTitle.replaceAll(invalidChar, "");
      final String extension = pickedFile.extension ?? 'mp3';
      
      final String newFilePath = "$dirPath/$safeFileName.$extension";
      printINFO("Importing to filePath: $newFilePath");

      final File originalFile = File(originalFilePath);
      await originalFile.copy(newFilePath);


      final String songId = "imported_${DateTime.now().millisecondsSinceEpoch}";


      Uri? artUri;
      if (metadata.albumArt != null) {
        try {
          final thumbnailPath = "${settingsScreenController.supportDirPath}/thumbnails/$songId.png";
          final thumbFile = File(thumbnailPath);
          // Ensure directory exists
          await thumbFile.create(recursive: true); 
          
          await thumbFile.writeAsBytes(metadata.albumArt!);
          
          artUri = Uri.file(thumbnailPath); 
        } catch (e) {
          printERROR("Failed to save thumbnail: $e");
        }
      }


      final MediaItem song = MediaItem(
        id: songId,
        title: cleanTitle,
        album: album,
        duration: metadata.trackDuration != null 
            ? Duration(milliseconds: metadata.trackDuration!) 
            : null,
        artUri: artUri,
        extras: {
          'url': newFilePath,
          'year': metadata.year?.toString(),
          'artists': [{'name' : artist}],
        },
      );


      final songJson = MediaItemBuilder.toJson(song); 
      

      final streamInfoJson = {
        "itag": 0,
        "audioCodec": extension,
        "bitrate": bitrate,
        "loudnessDb": 10,
        "url": newFilePath,
        "approxDurationMs": metadata.trackDuration ?? 10000,
        "size": 0
      };

      // [playbility status, info map]
      songJson["streamInfo"] = [true, streamInfoJson];

      // return;

      Hive.box("SongDownloads").put(song.id, songJson);
      Get.find<LibrarySongsController>().librarySongsList.add(MediaItemBuilder.fromJson(songJson));
      printINFO("Imported successfully");


      ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar(
          Get.context!, 
          "Song imported successfully", 
          size: SanckBarSize.BIG,
          duration: const Duration(seconds: 2),
          top: !GetPlatform.isDesktop));

      complete.complete();

    } catch (e) {
      printERROR("Import Error: $e");
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackbar(
          Get.context!, 
          "Import Failed: $e", 
          size: SanckBarSize.BIG,
          duration: const Duration(seconds: 2),
          top: !GetPlatform.isDesktop));
      
      complete.complete();
    }

    return complete.future;
  }

}