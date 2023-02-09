import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_base.dart';
import 'package:tencent_cloud_chat_uikit/base_widgets/tim_ui_kit_statelesswidget.dart';
import 'package:tencent_cloud_chat_uikit/data_services/core/core_services_implements.dart';
import 'package:tencent_cloud_chat_uikit/data_services/services_locatar.dart';
import 'package:tencent_cloud_chat_uikit/ui/widgets/image_screen.dart';
import 'package:tencent_im_base/tencent_im_base.dart';

class Avatar extends TIMUIKitStatelessWidget {
  final String faceUrl;
  final String showName;
  final bool isFromLocalAsset;
  final CoreServicesImpl coreService = serviceLocator<CoreServicesImpl>();
  final BorderRadius? borderRadius;
  final V2TimUserStatus? onlineStatus;
  final int? type; // 1 c2c 2 group
  final bool isShowBigWhenClick;

  Avatar(
      {Key? key,
      required this.faceUrl,
      this.onlineStatus,
      required this.showName,
      this.isShowBigWhenClick = false,
      this.isFromLocalAsset = false,
      this.borderRadius,
      this.type = 1})
      : super(key: key);

  Widget getImageWidget(BuildContext context, TUITheme theme) {
    Widget defaultAvatar() {
      if (type == 1) {
        return Image.asset(
          'images/default_c2c_head.png',
          package: 'tencent_cloud_chat_uikit',
          fit: BoxFit.cover,
        );
      } else {
        return Image.asset(
          'images/default_group_head.png',
          package: 'tencent_cloud_chat_uikit',
          fit: BoxFit.cover,
        );
      }
    }

    // final emptyAvatarBuilder = coreService.emptyAvatarBuilder;
    if (faceUrl != "") {
      if (isFromLocalAsset) {
        return Image.asset(
          faceUrl,
          fit: BoxFit.cover,
        );
      }
      return CachedNetworkImage(
        imageUrl: faceUrl,
        fadeInDuration: const Duration(milliseconds: 0),
        errorWidget: (BuildContext context, String c, dynamic s) {
          return defaultAvatar();
        },
        fit: BoxFit.cover,
      );
    } else {
      return defaultAvatar();
    }
  }

  ImageProvider getImageProvider() {
    ImageProvider defaultAvatar() {
      if (type == 1) {
        return Image.asset(
          'images/default_c2c_head.png',
          package: 'tencent_cloud_chat_uikit',
          fit: BoxFit.cover,
        ).image;
      } else {
        return Image.asset('images/default_group_head.png', package: 'tencent_cloud_chat_uikit').image;
      }
    }

    if (faceUrl != "") {
      if (isFromLocalAsset) {
        return Image.asset(faceUrl).image;
      }
      return CachedNetworkImageProvider(
        faceUrl,
      );
    } else {
      return defaultAvatar();
    }
  }

  @override
  Widget tuiBuild(BuildContext context, TUIKitBuildValue value) {
    final TUITheme theme = value.theme;

    return Stack(
      fit: StackFit.expand,
      clipBehavior: Clip.none,
      children: [
        if (isShowBigWhenClick)
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false, // set to false
                  pageBuilder: (_, __, ___) => ImageScreen(imageProvider: getImageProvider(), heroTag: faceUrl),
                ),
              );
            },
            child: Hero(
              tag: faceUrl,
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.circular(4.8),
                child: getImageWidget(context, theme),
              ),
            ),
          ),
        if (!isShowBigWhenClick)
          ClipRRect(
            borderRadius: borderRadius ?? BorderRadius.circular(4.8),
            child: getImageWidget(context, theme),
          ),
        if (onlineStatus?.statusType != null && onlineStatus?.statusType != 0)
          Positioned(
            bottom: -4,
            right: -4,
            child: Container(
              width: 12,
              height: 12,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2.0,
                ),
                color: onlineStatus?.statusType == 1
                    ? theme.conversationItemOnlineStatusBgColor
                    : theme.conversationItemOfflineStatusBgColor,
              ),
              child: null,
            ),
          ),
      ],
    );
  }
}
