import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/widget/custom_text_widget.dart';

class AppScaffold extends StatefulWidget {
  final Widget body;
  final Widget? bottomNavigation;
  final String? title;
  final bool? onDragKeyboardDismiss;
  final bool? isLoginStatusBar;
  final bool? isDrawerVisible;

  const AppScaffold({
    Key? key,
    required this.body,
    this.bottomNavigation,
    this.title,
    this.onDragKeyboardDismiss,
    this.isLoginStatusBar,
    this.isDrawerVisible,
  }) : super(key: key);

  @override
  State<AppScaffold> createState() => _AppScaffoldState();
}

class _AppScaffoldState extends State<AppScaffold> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      key: _key,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.colorPrimary,
        elevation: 0,
        centerTitle: true,
        toolbarHeight:
            widget.isLoginStatusBar ?? false ? MediaQuery.of(context).size.height / 5 : kToolbarHeight,
        title: widget.isLoginStatusBar ?? false
            ? SvgPicture.asset(
                widget.title ?? "",
                height: 20,
              )
            : CustomTextWidget(
                text: widget.title ?? "",
                fontWeight: FontWeight.w400,
                fontSize: 14,
                textColor: AppColors.colorPrimary,
                letterSpacing: 0.5,
              ),
        leading: Visibility(
          visible: widget.isDrawerVisible ?? false,
          child: Neumorphic(
            margin: const EdgeInsets.only(
              left: 10,
            ),
            child: FloatingActionButton(
              backgroundColor: AppColors.colorPrimary,
              elevation: 0,
              autofocus: false,
              focusElevation: 0,
              highlightElevation: 0,
              child: AppUtil.circularImageWidget(
                iconData: Icons.menu_rounded,
                height: 30,
              ),
              onPressed: () {
                _key.currentState?.openDrawer();
              },
            ),
          ),
        ),
      ),
      drawerScrimColor: AppColors.colorSecondary,
      // drawer: _drawerMenu(context),
      body: Listener(
        onPointerMove: (event) {
          if (widget.onDragKeyboardDismiss ?? true) {
            AppUtil.hideKeyboard(context);
          }
        },
        child: widget.body,
      ),
      bottomNavigationBar: widget.bottomNavigation,
    );
  }

/* _drawerMenu(BuildContext context) {
    return Drawer(
      child: Neumorphic(
        width: AppConstants.width270,
        color: AppColors.colorTextBlue,
        child: Stack(
          children: [
            SizedBox(
              height: AppConstants.height230,
              width: context.mediaQuerySize.width,
              child: AppUtils.imageWidget(
                assetImage: icDrawerBackground,
                boxFit: BoxFit.fill,
              ),
            ),
            ListView(
              children: [
                AppUtils.commonSizedBox(
                  boxHeight: 20,
                ),
                InkWell(
                  onTap: () {
                    AutoRouter.of(context).pop();
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Neumorphic(
                        width: AppConstants.fifty,
                        height: AppConstants.fifty,
                        decoration: AppUtils.containerDecoration(
                            radius: AppConstants.radius70,
                            color: AppColors.colorPrimary),
                        margin: EdgeInsets.only(
                          right: 20,
                        ),
                        child: Icon(
                          Icons.close,
                          color: AppColors.colorWhite,
                          size: AppConstants.eighteen,
                        )),
                  ),
                ),
                Neumorphic(
                  margin: AppUtils.allMargin(
                    left: AppConstants.width50,
                    top: AppConstants.height50,
                    bottom: 10,
                  ),
                  alignment: Alignment.topLeft,
                  child: AppUtils.circleAvatarWidget(
                    assetImage: icPlaceholder,
                    radius: AppConstants.radius24,
                    backgroundColor: AppColors.colorTransparent,
                  ),
                ),
                Neumorphic(
                  margin: AppUtils.allMargin(
                    left: AppConstants.width50,
                    bottom: AppConstants.height24,
                  ),
                  child: AppUtils.labelText(
                    strText: "Ms. Precious",
                    fontSize: AppConstants.sp13,
                    letterSpacing: AppConstants.sp05,
                    fontWeight: AppConstants.fontWeight700,
                    textColor: AppColors.colorWhite,
                  ),
                ),
                _drawerMenuItems(
                  title: context.l10n.home,
                  callBack: () {
                    _navigateWithBottomMenuScreen(0);
                  },
                ),
                _drawerMenuItems(
                  title: context.l10n.messages,
                  callBack: () {
                    _navigateWithBottomMenuScreen(2);
                  },
                ),
                _drawerMenuItems(
                  title: context.l10n.appointments,
                  callBack: () {
                    _navigateWithBottomMenuScreen(1);
                  },
                ),
                _drawerMenuItems(
                  title: context.l10n.my_session_stats,
                  callBack: () {
                    navigateToOtherScreens(
                      const MySessionStatePage(),
                    );
                  },
                ),
                */ /*_drawerMenuItems(
                  title: context.l10n.subscription,
                  callBack: () {
                    navigateToOtherScreens(
                      const SubscriptionPackagePage(),
                    );
                  },
                ),*/ /*
                _dividerHorizontal(),
                _drawerMenuItems(
                  title: context.l10n.my_account,
                  callBack: () {
                    _navigateWithBottomMenuScreen(3);
                  },
                ),
                _drawerMenuItems(
                  title: context.l10n.my_journal,
                  callBack: () {
                    navigateToOtherScreens(
                      const JournalPage(),
                    );
                  },
                ),
                _drawerMenuItems(
                  title: context.l10n.tribe,
                  callBack: () {
                    navigateToOtherScreens(
                      const TribePostListPage(),
                    );
                  },
                ),
                _drawerMenuItems(
                  title: context.l10n.safety_plan,
                  callBack: () {
                    navigateToOtherScreens(
                      const SafetyPlanPage(),
                    );
                  },
                ),
                _dividerHorizontal(),
                _drawerMenuItems(
                  title: context.l10n.sign_out,
                  callBack: () {
                    _logoutDialog();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _navigateWithBottomMenuScreen(int index) {
    AppUtils.autoRoutePop(context);
    persistentTabController.index = index;
    if (navBarEssentials.onItemSelected != null) {
      navBarEssentials.onItemSelected!(index);
    }
  }

  void navigateToOtherScreens(Widget screenWidget) {
    AppUtils.autoRoutePop(context);
    pushNewScreen(
      context,
      screen: screenWidget,
      withNavBar: true,
    );
  }

  _drawerMenuItems({required String title, VoidCallback? callBack}) {
    return InkWell(
      onTap: () {
        if (callBack != null) {
          callBack();
        }
      },
      child: Neumorphic(
        padding: AppUtils.symmetricMarginPadding(
          horizontal: AppConstants.width50,
          vertical: 20,
        ),
        child: AppUtils.labelText(
          strText: title,
          textColor: AppColors.colorWhite,
          fontSize: AppConstants.sp13,
          letterSpacing: AppConstants.sp02,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  _logoutDialog() {
    AppUtils.autoRoutePop(context);
    AppUtils.showCustomDialog(
      context,
      msg: context.l10n.msg_logout,
      isDismissible: true,
      positiveBtnText: context.l10n.yes,
      negativeBtnText: context.l10n.no,
      showNegativeBtn: true,
      showPositiveBtn: true,
      positiveCallback: () async {
        AutoRouter.of(context).pushAndPopUntil(
          const LoginRoute(),
          predicate: (Route<dynamic> route) {
            return false;
          },
        );
      },
    );
  }

  Widget _dividerHorizontal() {
    return Neumorphic(
      margin: AppUtils.allMargin(
        top: 10,
        bottom: 10,
      ),
      child: AppUtils.dividerWidget(
        height: AppConstants.height1,
        dividerColor: AppColors.colorWhite,
      ),
    );
  }*/
}
