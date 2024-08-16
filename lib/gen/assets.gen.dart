/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

class $AssetsPngGen {
  const $AssetsPngGen();

  /// File path: assets/png/check.png
  AssetGenImage get check => const AssetGenImage('assets/png/check.png');

  /// File path: assets/png/checked_icon.png
  AssetGenImage get checkedIcon =>
      const AssetGenImage('assets/png/checked_icon.png');

  /// File path: assets/png/cloud.png
  AssetGenImage get cloud => const AssetGenImage('assets/png/cloud.png');

  /// File path: assets/png/cloud_sync_done.png
  AssetGenImage get cloudSyncDone =>
      const AssetGenImage('assets/png/cloud_sync_done.png');

  /// File path: assets/png/logo.png
  AssetGenImage get logo => const AssetGenImage('assets/png/logo.png');

  /// List of all assets
  List<AssetGenImage> get values =>
      [check, checkedIcon, cloud, cloudSyncDone, logo];
}

class $AssetsSvgGen {
  const $AssetsSvgGen();

  /// File path: assets/svg/back_icon.svg
  SvgGenImage get backIcon => const SvgGenImage('assets/svg/back_icon.svg');

  /// File path: assets/svg/delete_icon.svg
  SvgGenImage get deleteIcon => const SvgGenImage('assets/svg/delete_icon.svg');

  /// File path: assets/svg/edit_icon.svg
  SvgGenImage get editIcon => const SvgGenImage('assets/svg/edit_icon.svg');

  /// File path: assets/svg/homepage_fab.svg
  SvgGenImage get homepageFab =>
      const SvgGenImage('assets/svg/homepage_fab.svg');

  /// File path: assets/svg/onboard_icon.svg
  SvgGenImage get onboardIcon =>
      const SvgGenImage('assets/svg/onboard_icon.svg');

  /// File path: assets/svg/share_icon.svg
  SvgGenImage get shareIcon => const SvgGenImage('assets/svg/share_icon.svg');

  /// File path: assets/svg/three_dot.svg
  SvgGenImage get threeDot => const SvgGenImage('assets/svg/three_dot.svg');

  /// List of all assets
  List<SvgGenImage> get values => [
        backIcon,
        deleteIcon,
        editIcon,
        homepageFab,
        onboardIcon,
        shareIcon,
        threeDot
      ];
}

class Assets {
  Assets._();

  static const $AssetsPngGen png = $AssetsPngGen();
  static const $AssetsSvgGen svg = $AssetsSvgGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = false,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.low,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}

class SvgGenImage {
  const SvgGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = false;

  const SvgGenImage.vec(
    this._assetName, {
    this.size,
    this.flavors = const {},
  }) : _isVecFormat = true;

  final String _assetName;
  final Size? size;
  final Set<String> flavors;
  final bool _isVecFormat;

  SvgPicture svg({
    Key? key,
    bool matchTextDirection = false,
    AssetBundle? bundle,
    String? package,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    AlignmentGeometry alignment = Alignment.center,
    bool allowDrawingOutsideViewBox = false,
    WidgetBuilder? placeholderBuilder,
    String? semanticsLabel,
    bool excludeFromSemantics = false,
    SvgTheme? theme,
    ColorFilter? colorFilter,
    Clip clipBehavior = Clip.hardEdge,
    @deprecated Color? color,
    @deprecated BlendMode colorBlendMode = BlendMode.srcIn,
    @deprecated bool cacheColorFilter = false,
  }) {
    final BytesLoader loader;
    if (_isVecFormat) {
      loader = AssetBytesLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
      );
    } else {
      loader = SvgAssetLoader(
        _assetName,
        assetBundle: bundle,
        packageName: package,
        theme: theme,
      );
    }
    return SvgPicture(
      loader,
      key: key,
      matchTextDirection: matchTextDirection,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      allowDrawingOutsideViewBox: allowDrawingOutsideViewBox,
      placeholderBuilder: placeholderBuilder,
      semanticsLabel: semanticsLabel,
      excludeFromSemantics: excludeFromSemantics,
      colorFilter: colorFilter ??
          (color == null ? null : ColorFilter.mode(color, colorBlendMode)),
      clipBehavior: clipBehavior,
      cacheColorFilter: cacheColorFilter,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
