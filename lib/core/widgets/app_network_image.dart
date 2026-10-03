import 'package:flutter/material.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final String? fallbackAsset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.fallbackAsset,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = imageUrl.trim();

    Widget child;

    if (_isNetworkImage(image)) {
      child = Image.network(
        image,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }

          return _buildLoading();
        },
        errorBuilder: (context, error, stackTrace) {
          return _buildFallback();
        },
      );
    } else if (image.startsWith('assets/')) {
      child = _buildAsset(image);
    } else {
      child = _buildFallback();
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }

    return child;
  }

  bool _isNetworkImage(String image) {
    return image.startsWith('http://') || image.startsWith('https://');
  }

  Widget _buildFallback() {
    final asset = fallbackAsset?.trim();

    if (asset != null && asset.isNotEmpty) {
      return _buildAsset(asset);
    }

    return _buildPlaceholder();
  }

  Widget _buildAsset(String asset) {
    return Image.asset(
      asset,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF3F3F3),
      alignment: Alignment.center,
      child: const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFFB60F1A),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: const Color(0xFFF3F3F3),
      alignment: Alignment.center,
      child: const Icon(
        Icons.restaurant_rounded,
        size: 32,
        color: Color(0xFFBDBDBD),
      ),
    );
  }
}
