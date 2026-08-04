import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? height;
  final double? width;
  final Border? border;
  final BorderRadius? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final BoxFit fit;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    required this.imageUrl,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    if (height != null && width != null) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
        imageBuilder: (context, imageProvider) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            borderRadius: borderRadius,
            shape: boxShape,
            color: backgroundColor,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
              colorFilter: colorFilter,
            ),
          ),
          child: child,
        ),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.withValues(alpha: 0.6),
          highlightColor: Colors.grey.withValues(alpha: 0.3),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              border: border,
              color: Colors.grey.withValues(alpha: 0.6),
              borderRadius: borderRadius,
              shape: boxShape,
            ),
            child: child,
          ),
        ),
        errorWidget: (context, url, error) => Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            border: border,
            color: Colors.grey.withValues(alpha: 0.6),
            borderRadius: borderRadius,
            shape: boxShape,
          ),
          child: const Icon(Icons.error),
        ),
      );
    }

    // Dynamic sizing fallback
    Widget img = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey.withValues(alpha: 0.6),
        highlightColor: Colors.grey.withValues(alpha: 0.3),
        child: Container(color: Colors.grey.withValues(alpha: 0.6)),
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );

    if (colorFilter != null) {
      img = ColorFiltered(colorFilter: colorFilter!, child: img);
    }

    if (borderRadius != null || boxShape == BoxShape.circle) {
      img = ClipRRect(
        borderRadius: boxShape == BoxShape.circle
            ? BorderRadius.circular(999)
            : (borderRadius ?? BorderRadius.zero),
        child: img,
      );
    }

    if (child != null) {
      img = Stack(
        alignment: Alignment.center,
        children: [img, Positioned.fill(child: child!)],
      );
    }

    if (backgroundColor != null || border != null) {
      img = Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: border,
          shape: boxShape,
          borderRadius: borderRadius,
        ),
        child: img,
      );
    }

    return img;
  }
}
