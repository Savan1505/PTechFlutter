import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/app_checkbox.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),

            ///App bar
            Padding(
              padding: AppPaddingConstants().leftRight25,
              child: buildAppBar(),
            ),
            const SizedBox(
              height: 20,
            ),

            ///POS
            settingTitle(
              title: "pos".i18n,
            ),
            const Divider(),
            settingTitle(
              title: "general".i18n,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 10,
            ),
            settingCheckbox(
              title: "generalItemFirst".i18n,
            ),
            const SizedBox(
              height: 20,
            ),
            settingCheckbox(
              title: "generalItemMaster".i18n,
            ),
            const SizedBox(
              height: 20,
            ),
            settingTitle(
              title: "purchase".i18n,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 10,
            ),
            settingCheckbox(
              title: "purchaseItemMaster".i18n,
            ),

            const SizedBox(
              height: 25,
            ),

            ///Portal
            settingTitle(
              title: "portal".i18n,
            ),
            const Divider(),
            settingTitle(
              title: "general".i18n,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 10,
            ),
            settingCheckbox(
              title: "generalItemMaster".i18n,
            ),
            const SizedBox(
              height: 20,
            ),
            settingTitle(
              title: "purchase".i18n,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(
              height: 10,
            ),
            settingCheckbox(
              title: "purchaseItemMaster".i18n,
            ),
          ],
        ),
      ),
    );
  }

  Stack buildAppBar() {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        AppUtil().drawerButton(),
        Center(
          child: Text(
            "settings".i18n,
            style: AppTextStyle().homeStyle2.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Padding settingTitle({
    String? title,
    FontWeight? fontWeight,
    double? fontSize,
  }) {
    return Padding(
      padding: AppPaddingConstants().leftRight25,
      child: Text(
        title ?? "",
        style: TextStyle(
          color: AppColors.colorBlack,
          fontWeight: fontWeight ?? FontWeight.bold,
          fontSize: fontSize ?? 20,
        ),
      ),
    );
  }

  Padding settingCheckbox({String? title}) {
    return Padding(
      padding: AppPaddingConstants().left45,
      child: AppCheckBox(
        label: title ?? "",
        value: false,
        onChanged: (value) {
          /*var t = widget.itemBloc.taxSlabs[e.key].value;
          t.isSelected = value;
          widget.itemBloc.taxSlabs[e.key].add(t);*/
        },
      ),
    );
  }
}
