import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:rxdart/rxdart.dart';

class CustomListTileWidget extends StatelessWidget {
  final String? logo;
  final Uint8List? decodeLogo;
  final String? logoName;
  final String? header;
  final String? subTitle;
  final void Function() onTapAdmin;
  final void Function() onTapPos;

  const CustomListTileWidget({
    this.logo,
    this.decodeLogo,
    this.logoName,
    this.header,
    this.subTitle,
    required this.onTapAdmin,
    required this.onTapPos,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BehaviorSubject<bool> isExpanded = BehaviorSubject<bool>.seeded(false);
    return StreamBuilder(
      stream: isExpanded,
      builder: (context, snapshot) {
        return AppUtil.neuMorphicWidget(
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(
              12,
            ),
          ),
          border: NeumorphicBorder(
            color: isExpanded.value ? AppColors.colorPrimary : AppColors.colorTransparent,
            width: 0.5,
          ),
          depth: 9,
          topMargin: 7,
          backgroundColor: AppColors.colorSecondary,
          childWidget: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.colorLightGray,
                  AppColors.colorSecondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [-10, 0.5],
              ),
            ),
            child: ExpansionTileCard(
              onExpansionChanged: (val) {
                isExpanded.add(val);
              },
              baseColor: AppColors.colorSecondary,
              expandedColor: AppColors.colorLightGreen,
              shadowColor: AppColors.colorTransparent,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              finalPadding: EdgeInsets.zero,
              trailing: const SizedBox.shrink(),
              leading: logo?.isNotEmpty ?? false
                  ? AppUtil.circularTextAndImageWidget(
                      childWidget: AppUtil.circularImageWidget(
                        decodeLogo: decodeLogo ?? Uint8List(-1),
                        depth: -5,
                      ),
                    )
                  : AppUtil.circularTextAndImageWidget(
                      childWidget: AppUtil.circularProfileNameWidget(
                        profileName: logoName ?? "",
                      ),
                    ),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Text(
                  header ?? "",
                  style: AppTextStyle.storeHeaderTextStyle,
                ),
              ),
              subtitle: Text(
                subTitle ?? "",
                style: AppTextStyle.storeListTextStyle,
              ),
              children: _expandChildrenWidget(),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _expandChildrenWidget() {
    return <Widget>[
      Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: const Divider(
          color: AppColors.colorInnerShadowPrimary,
          thickness: 0.5,
        ),
      ),
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: onTapAdmin,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                      top: 10,
                      bottom: 10,
                    ),
                    child: SvgPicture.asset(
                      icAdmin,
                      height: 20,
                      width: 50,
                      // ignore: deprecated_member_use
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  Text(
                    "admin".i18n,
                    style: AppTextStyle.storeListItemTextStyle,
                  ),
                ],
              ),
            ),
            const VerticalDivider(
              color: AppColors.colorInnerShadowPrimary,
              width: 80,
              thickness: 0.5,
            ),
            InkWell(
              onTap: onTapPos,
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                alignment: WrapAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: AppPaddingConstants().right10,
                    child: SvgPicture.asset(
                      icPOS,
                      height: 20,
                      width: 50,
                      // ignore: deprecated_member_use
                      color: AppColors.colorPrimary,
                    ),
                  ),
                  Text(
                    "pos".i18n,
                    style: AppTextStyle.storeListItemTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 5,
      ),
    ];
  }
}
