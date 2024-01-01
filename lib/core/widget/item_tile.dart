import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';

class ItemTile extends StatelessWidget {
  final void Function(int) onLongPress;
  final String itemId;
  final String storeItemName;
  final String itemSku;

  const ItemTile({
    super.key,
    required this.onLongPress,
    required this.itemId,
    required this.itemSku,
    required this.storeItemName,
  });

  @override
  Widget build(BuildContext context) {
    // BehaviorSubject<bool> isExpanded = BehaviorSubject<bool>.seeded(false);
    //
    // int itemid = 5;
    return AppUtil.neuMorphicWidget(
      boxShape: NeumorphicBoxShape.roundRect(
        BorderRadius.circular(
          12,
        ),
      ),
      border: const NeumorphicBorder(
        color: AppColors.colorTransparent,
        width: 0.5,
      ),
      depth: 9,
      topMargin: 7,
      backgroundColor: AppColors.colorSecondary,
      childWidget: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        leading: AppUtil.circularTextAndImageWidget(
          childWidget: AppUtil.circularProfileNameWidget(
            profileName: storeItemName[0],
          ),
        ),
        trailing: const SizedBox.shrink(),
        title: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      storeItemName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyle.storeHeaderTextStyle,
                    ),
                  ],
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
      ),
    );
    // return StreamBuilder(
    //   stream: isExpanded,
    //   builder: (context, snapshot) {
    //     return GestureDetector(
    //       onLongPress: () => onLongPress(itemid),
    //       child: AppUtil.neuMorphicWidget(
    //         boxShape: NeumorphicBoxShape.roundRect(
    //           BorderRadius.circular(
    //             12,
    //           ),
    //         ),
    //         border: NeumorphicBorder(
    //           color: isExpanded.value ? AppColors.colorPrimary : AppColors.colorTransparent,
    //           width: 0.5,
    //         ),
    //         depth: 9,
    //         topMargin: 7,
    //         backgroundColor: AppColors.colorSecondary,
    //         childWidget: Container(
    //           decoration: AppUtil.decorationGradient(),
    //           child: ExpansionTileCard(
    //             onExpansionChanged: (val) {
    //               isExpanded.add(val);
    //             },
    //             baseColor: AppColors.colorSecondary,
    //             expandedColor: AppColors.colorLightGreen,
    //             shadowColor: AppColors.colorTransparent,
    //             contentPadding: const EdgeInsets.symmetric(
    //               vertical: 10,
    //             ),
    //             finalPadding: EdgeInsets.zero,
    //             trailing: const SizedBox.shrink(),
    //             leading: AppUtil.circularTextAndImageWidget(
    //               childWidget: AppUtil.circularProfileNameWidget(
    //                 profileName: storeItemName[0],
    //               ),
    //             ),
    //             title: Padding(
    //               padding: const EdgeInsets.symmetric(
    //                 vertical: 5,
    //               ),
    //               child: Row(
    //                 crossAxisAlignment: CrossAxisAlignment.start,
    //                 children: [
    //                   Expanded(
    //                     child: Text(
    //                       storeItemName,
    //                       maxLines: 2,
    //                       overflow: TextOverflow.ellipsis,
    //                       style: AppTextStyle.storeHeaderTextStyle,
    //                     ),
    //                   ),
    //                   const Spacer(),
    //                   const SizedBox(
    //                     width: 28,
    //                   ),
    //                   RotatedBox(
    //                     quarterTurns: -3,
    //                     child: Text(
    //                       itemSku,
    //                       style: const TextStyle(
    //                         fontSize: 14,
    //                         color: AppColors.colorGrey,
    //                       ),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //             children: [
    //               Container(
    //                 margin: const EdgeInsets.symmetric(
    //                   horizontal: 15,
    //                 ),
    //                 child: const Divider(
    //                   color: AppColors.colorInnerShadowPrimary,
    //                   thickness: 0.5,
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 20.0, right: 20),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                   children: [
    //                     GestureDetector(
    //                       onTap: () {},
    //                       child: Row(
    //                         children: [
    //                           AppUtil.svgAssetsColorWidget(
    //                             icAssetsSVG: icAdmin,
    //                             height: 20,
    //                           ),
    //                           const SizedBox(
    //                             width: 10,
    //                           ),
    //                           Text(
    //                             "Edit".i18n,
    //                             style: AppTextStyle.storeListItemTextStyle,
    //                           ),
    //                           const SizedBox(
    //                             width: 17,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Container(
    //                       height: 60,
    //                       color: AppColors.colorInnerShadowPrimary,
    //                       width: 0.5,
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {},
    //                       child: Row(
    //                         children: [
    //                           AppUtil.svgAssetsColorWidget(
    //                             icAssetsSVG: icPOS,
    //                             height: 20,
    //                           ),
    //                           const SizedBox(
    //                             width: 10,
    //                           ),
    //                           Text(
    //                             "Clone".i18n,
    //                             style: AppTextStyle.storeListItemTextStyle,
    //                           ),
    //                           const SizedBox(
    //                             width: 17,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                     Container(
    //                       height: 60,
    //                       color: AppColors.colorInnerShadowPrimary,
    //                       width: 0.5,
    //                     ),
    //                     GestureDetector(
    //                       onTap: () {},
    //                       child: Row(
    //                         children: [
    //                           AppUtil.svgAssetsColorWidget(
    //                             icAssetsSVG: icPOS,
    //                             height: 20,
    //                           ),
    //                           const SizedBox(
    //                             width: 10,
    //                           ),
    //                           Text(
    //                             "Fav".i18n,
    //                             style: AppTextStyle.storeListItemTextStyle,
    //                           ),
    //                         ],
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               const SizedBox(
    //                 height: 5,
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     );
    //   },
    // );
  }
}
