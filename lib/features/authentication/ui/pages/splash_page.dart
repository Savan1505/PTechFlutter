import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/features/authentication/ui/bloc/authentication_bloc.dart';
import 'package:ptecpos_mobile/features/authentication/ui/bloc/authentication_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends BaseState<SplashPage> with TickerProviderStateMixin {
  final AuthenticationBloc splashBloc = AuthenticationBloc();

  @override
  void initState() {
    super.initState();
    // splashBloc.openIdClient();
    splashBloc.controller = AnimationController(
      duration: const Duration(
        seconds: 3,
      ),
      vsync: this,
      value: 0.1,
    )..forward();
    splashBloc.animation = CurvedAnimation(
      parent: splashBloc.controller,
      curve: Curves.easeIn,
    )..addStatusListener((status) {
        splashBloc.authenticateState.add(AuthenticationState.loading());
        if (status == AnimationStatus.completed) {
          splashBloc.controller.reverse().then((value) async {
            await splashBloc.getOpenIdAuthUserId();

            if (splashBloc.authUserID?.isNotEmpty ?? false) {
              splashBloc.getAuthProfileUsersListAPI();
            } else {
              splashBloc.authenticateState.add(
                AuthenticationState.completed(true),
              );
              splashBloc.loginRedirection();
            }
          });
        }
      });
  }

  @override
  void dispose() {
    splashBloc.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorBackGround,
      body: StreamBuilder(
        stream: splashBloc.authenticateState.stream,
        builder: (context, snapshot) {
          return ScaleTransition(
            scale: splashBloc.animation,
            child: Center(
              child: SvgPicture.asset(
                icSplash,
                height: 50,
              ),
            ),
          );
        },
      ),
    );
    /*return BlocProvider(
      create: (context) {},
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is LoadingState) {
            CustomProgressDialog(
              isRefresh: state.isLoading,
              childWidget: AppUtil.neuMorphicWidget(
                backgroundColor: AppColors.colorSecondary,
                depth: 9,
                childWidget: Container(),
              ),
            );
          }
          if (state is AuthenticationPageFailState) {
            AppUtil.showCustomDialog(
              context,
              msg: state.errorMessage,
              doBack: true,
              isPositive: false,
              isNegative: true,
              isArrowShowBack: false,
              isArrowShow: false,
              negativeBtnText: LocaleKeys.btnOk.tr().toUpperCase(),
            );
          }
          if (state is GetAuthUsersStatusSuccessState) {
            if (state.lstAuthResponseData.isNotEmpty) {
              splashBloc.storeListRedirection(context);
            }
          }
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: AppColors.colorBackGround,
              body: ScaleTransition(
                scale: splashBloc.animation,
                child: Center(
                  child: AppUtil.svgAssetsWidget(
                    icAssetsSVG: icSplash,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );*/
  }

  @override
  BaseBloc? getBaseBloc() {
    return splashBloc;
  }
}
