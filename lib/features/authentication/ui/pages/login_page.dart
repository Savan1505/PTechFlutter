import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/appbar/app_scaffold.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/custom_button_widget.dart';
import 'package:ptecpos_mobile/features/authentication/ui/bloc/authentication_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends BaseState<LoginPage> {
  final AuthenticationBloc loginBloc = AuthenticationBloc();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: _formKey,
      isLoginStatusBar: true,
      title: icLogin,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            AppUtil.neuMorphicWidget(
              backgroundColor: AppColors.colorPrimary,
              boxShape: const NeumorphicBoxShape.rect(),
              childWidget: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: AppUtil.containerDecoration(
                  radiusTopLeft: 20,
                  radiusTopRight: 20,
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        icLoginMain,
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 30,
                        ),
                        alignment: Alignment.topLeft,
                        child: AppUtil.richText(
                          startText: "txtLetsManage".i18n,
                          centerText: "txtBusiness".i18n,
                          lastText: "txtWithUs".i18n,
                        ),
                      ),
                      CustomButtonWidget(
                        text: "getStarted".i18n,
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        fontSize: 14,
                        textColor: AppColors.colorSecondary,
                        onTapCallback: () async {
                          // await loginBloc.getClient();
                          if (await loginBloc.getClient()) {
                            await loginBloc.authenticate();
                            await loginBloc.getOpenIdAuthUserId();
                            if (loginBloc.authUserID?.isNotEmpty ?? false) {
                              AppUtil.showLoader();
                              loginBloc.getAuthProfileUsersListAPI();
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return loginBloc;
  }
}
