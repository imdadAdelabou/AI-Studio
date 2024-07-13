import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Display a circular avatar with a profile pic of the user
class ShowRemoteProfilPic extends StatelessWidget {
  /// Creates a [ShowRemoteProfilPic] instance
  const ShowRemoteProfilPic({
    required this.url,
    super.key,
  });

  /// The url of the image
  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      httpHeaders: const <String, String>{
        'mode': 'no-cors',
      },
      imageUrl: url,
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              CircleAvatar(
        radius: 70,
        backgroundImage: imageProvider,
      ),
      errorWidget: (BuildContext context, _, Object object) =>
          const CircleAvatar(
        radius: 70,
        child: Icon(
          Icons.error,
          color: Colors.red,
        ),
      ),
    );
  }
}
