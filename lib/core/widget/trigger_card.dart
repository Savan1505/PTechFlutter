import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:rxdart/rxdart.dart';

class TriggerTile extends StatelessWidget {
  final String itemId;
  final String storeItemName;
  final String itemSku;
  final void Function() onEditTap;
  final void Function() onDeleteTap;

  const TriggerTile({
    super.key,
    required this.itemId,
    required this.itemSku,
    required this.storeItemName,
    required this.onEditTap,
    required this.onDeleteTap,
  });

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
              leading: AppUtil.circularTextAndImageWidget(
                childWidget: AppUtil.circularProfileNameWidget(
                  profileName: storeItemName[0],
                ),
              ),
              title: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        storeItemName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyle.storeHeaderTextStyle,
                      ),
                    ),
                    const Spacer(),
                    const SizedBox(
                      width: 28,
                    ),
                    RotatedBox(
                      quarterTurns: -3,
                      child: Text(
                        itemSku,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.colorGrey,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 15,
                  ),
                  child: const Divider(
                    color: AppColors.colorInnerShadowPrimary,
                    thickness: 0.5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: onEditTap,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icEditIcon,
                              height: 20,
                              width: 50,
                              // ignore: deprecated_member_use
                              color: AppColors.colorPrimary,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Edit".i18n,
                              style: AppTextStyle.storeListItemTextStyle,
                            ),
                            const SizedBox(
                              width: 17,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        color: AppColors.colorInnerShadowPrimary,
                        width: 0.5,
                      ),
                      GestureDetector(
                        onTap: onDeleteTap,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              icTrashIcon,
                              // ignore: deprecated_member_use
                              color: AppColors.redColor,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              "Delete".i18n,
                              style: AppTextStyle.storeListItemTextStyle,
                            ),
                            const SizedBox(
                              width: 17,
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
              ],
            ),
          ),
        );
      },
    );
  }
}
