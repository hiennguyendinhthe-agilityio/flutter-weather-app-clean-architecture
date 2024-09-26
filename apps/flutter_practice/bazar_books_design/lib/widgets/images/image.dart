library;

import 'dart:developer';

import 'package:bazar_books_design/core/extensions/context_extension.dart';
import 'package:bazar_books_design/core/resources/assets_generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BazUiAssetImage extends StatelessWidget {
  BazUiAssetImage({
    required this.path,
    super.key,
    this.package = 'bazar_books_design',
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit,
    this.type = ImageLoaderType.assetPNG,
  }) : assert(
          !path.startsWith('http'),
          'Asset Image path should not start with http or https',
        );

  final String path;
  final String? package;
  final Widget? errorBuilder;
  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;
  final ImageLoaderType type;

  @override
  Widget build(BuildContext context) {
    return _BazUiImageLoader(
      url: path,
      package: package,
      type: type,
      errorBuilder: errorBuilder,
      width: width,
      height: height,
      color: color,
      boxFit: boxFit,
    );
  }
}

///
/// An enum defines all supported types of image loader
///
/// * [ImageLoaderType.assetPNG] load PNG image from asset
/// * [ImageLoaderType.assetSVG] load SVG image from asset
/// *   otherwises return network image
///
enum ImageLoaderType { assetPNG, assetSVG }

///
/// Contains almost images for applications.
///
class _BazUiImageLoader extends StatelessWidget {
  /// Creates properties for image.
  ///
  /// The [errorBuilder], must be null. The [url], [type]
  /// must not be null.
  ///
  const _BazUiImageLoader({
    required this.type,
    required this.url,
    this.package,
    this.errorBuilder,
    this.width,
    this.height,
    this.color,
    this.boxFit = BoxFit.cover,
  });

  /// Image type is for provide different image loader with enum type
  /// it provide image changes as asset, svg, network, or cached
  final ImageLoaderType type;

  /// Url path of image is the path of the image that will be loaded from
  final String url;

  final String? package;

  /// Error builders have default value in case of null
  final Widget? errorBuilder;

  final double? width;
  final double? height;
  final Color? color;
  final BoxFit? boxFit;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ImageLoaderType.assetPNG:
        return Image.asset(
          url,
          package: package,
          fit: boxFit,
          errorBuilder:
              (BuildContext context, Object error, StackTrace? stackTrace) {
            log('Image $url load failed. Error: $error');

            return errorBuilder ??
                Image.asset(
                  Assets.images.imgNotFound.path,
                  package: package,
                );
          },
          width: width,
          height: height,
          color: color,
        );
      case ImageLoaderType.assetSVG:
        return SvgPicture.asset(
          url,
          package: package,
          fit: boxFit ?? BoxFit.contain,
          width: width,
          height: height,
          // ignore: deprecated_member_use
          color: color,
        );
    }
  }
}

class BazUiBuiltInImage {
  static Widget Function({Color? color}) imgSlpashScreen =
      _BazSlpashScreenImage.new;
  static Widget Function({Color? color}) imgSlpashLogoScreen =
      _BazSplashLogoScreen.new;
  static Widget Function() icAppleOriginal = _BazIcAppleOriginal.new;
  static Widget Function() icGoogleOriginal = _BazIcGoodleOriginal.new;
  static Widget Function() icLogoVendor = _BazIcLogoVendor.new;
  static Widget Function({Color? color}) icHomeFill = _BazIcHomeFill.new;
  static Widget Function({Color? color}) icMenuFill = _BazIcMenuFill.new;
  static Widget Function({Color? color}) icCardFill = _BazIcCardFill.new;
  static Widget Function({Color? color}) icProfileFill = _BazIcProfileFill.new;
  static Widget Function({Color? color}) icBellOutline = _BazIcBellOutline.new;
  static Widget Function({Color? color}) icSearch = _BazIcSearch.new;
  static Widget Function({Color? color}) icArrowLeft = _BazIcArrowLeft.new;
  static Widget Function({
    Color? color,
    double? width,
  }) icPassword = _BazIcPassword.new;
  static Widget Function({
    Color? color,
    double? width,
  }) icUnPassword = _BazIcUnPassword.new;
  static Widget Function({
    Color? color,
    double? width,
  }) icAdd = _BazIcAdd.new;
  static Widget Function({
    Color? color,
    double? width,
  }) icLess = _BazIcLess.new;
  static Widget Function({
    Color? color,
    double? width,
  }) icLoveFill = _BazIcLoveFill.new;
  static Widget Function({
    Color? color,
    double? width,
  }) icStar = _BazIcStar.new;
}

class _BazSlpashScreenImage extends StatelessWidget {
  const _BazSlpashScreenImage({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.slpashScreen.path,
      width: 18,
      height: 18,
      color: color ?? context.colorScheme.error,
    );
  }
}

class _BazSplashLogoScreen extends StatelessWidget {
  const _BazSplashLogoScreen({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.splashLogoScreen.path,
      width: 18,
      height: 18,
      color: color ?? context.colorScheme.error,
    );
  }
}

class _BazIcAppleOriginal extends StatelessWidget {
  const _BazIcAppleOriginal();

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icAppleOriginal.path,
      width: 18,
      height: 18,
    );
  }
}

class _BazIcGoodleOriginal extends StatelessWidget {
  const _BazIcGoodleOriginal();

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icGoogleOriginal.path,
      width: 18,
      height: 18,
    );
  }
}

class _BazIcLogoVendor extends StatelessWidget {
  const _BazIcLogoVendor();

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetPNG,
      path: Assets.images.vendors.path,
      width: 18,
      height: 18,
    );
  }
}

class _BazIcHomeFill extends StatelessWidget {
  const _BazIcHomeFill({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyHomeFill.path,
      width: 18,
      height: 18,
      color: color,
    );
  }
}

class _BazIcMenuFill extends StatelessWidget {
  const _BazIcMenuFill({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyMenuFill.path,
      width: 18,
      height: 18,
      color: color,
    );
  }
}

class _BazIcCardFill extends StatelessWidget {
  const _BazIcCardFill({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyCartFill.path,
      width: 18,
      height: 18,
      color: color,
    );
  }
}

class _BazIcProfileFill extends StatelessWidget {
  const _BazIcProfileFill({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyProfileFill.path,
      width: 18,
      height: 18,
      color: color,
    );
  }
}

class _BazIcBellOutline extends StatelessWidget {
  const _BazIcBellOutline({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyBellOutline.path,
      width: 24,
      color: color,
    );
  }
}

class _BazIcSearch extends StatelessWidget {
  const _BazIcSearch({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphySearch.path,
      width: 24,
      color: color,
    );
  }
}

class _BazIcArrowLeft extends StatelessWidget {
  const _BazIcArrowLeft({this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyArrowLeftOutline.path,
      width: 24,
      color: color,
    );
  }
}

class _BazIcPassword extends StatelessWidget {
  const _BazIcPassword({this.color, this.width});

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyPasswordOutline.path,
      width: width,
      color: color,
    );
  }
}

class _BazIcUnPassword extends StatelessWidget {
  const _BazIcUnPassword({this.color, this.width});

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyUnpasswordOutline.path,
      width: width,
      color: color,
    );
  }
}

class _BazIcAdd extends StatelessWidget {
  const _BazIcAdd({this.color, this.width});

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icAdd.path,
      width: width,
      color: color,
    );
  }
}

class _BazIcLess extends StatelessWidget {
  const _BazIcLess({this.color, this.width});

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icLess.path,
      width: width,
      color: color,
    );
  }
}

class _BazIcLoveFill extends StatelessWidget {
  const _BazIcLoveFill({this.color, this.width});

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyLoveFill.path,
      width: width,
      color: color,
    );
  }
}

class _BazIcStar extends StatelessWidget {
  const _BazIcStar({this.color, this.width});

  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BazUiAssetImage(
      type: ImageLoaderType.assetSVG,
      path: Assets.images.icOgraphyStar.path,
      width: width,
      color: color,
    );
  }
}
