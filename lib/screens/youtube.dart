import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:html' as html;

class YouTubeEmbed extends StatelessWidget {
  final String videoId;

  YouTubeEmbed({required this.videoId});

  @override
  Widget build(BuildContext context) {
    // Unique view type name
    String viewId = 'youtube-video-$videoId';

    // Iframe create
    html.IFrameElement _iframe = html.IFrameElement()
      ..width = '560'
      ..height = '315'
      ..src = 'https://www.youtube.com/embed/$videoId'
      ..style.border = 'none'
      ..allow =
          'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
      ..allowFullscreen = true;

    // Register the iframe
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) => _iframe,
    );

    return HtmlElementView(viewType: viewId);
  }
}
