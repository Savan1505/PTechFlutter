import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_circle_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/bloc/item_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/storeitem/ui/additem/itinerary/regions/model/req_item_regions_model.dart';
import 'package:rxdart/rxdart.dart';

class AddAbvScreen extends StatefulWidget {
  final ItemBloc itemBloc;

  const AddAbvScreen({super.key, required this.itemBloc});

  @override
  State<AddAbvScreen> createState() => _AddAbvScreenState();
}

class _AddAbvScreenState extends State<AddAbvScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    RootBloc().changeBottomBarBehaviour(onTap: buttonTapBehaviour, bottomBarIconPath: icCheck);
    widget.itemBloc.getItemAvc();
  }

  void buttonTapBehaviour() {
    if (widget.itemBloc.itemAbvValue.valueOrNull != null) {
      TabNavigatorRouter(
        navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
        currentPageKey: AppRouteManager.currentPage,
      ).pop();
    } else {
      AppUtil.showSnackBar(label: "Please select Alcohol by volume".i18n);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.colorWhite,
        leading: NeumorphicButton(
          margin: const EdgeInsets.all(8),
          padding: EdgeInsets.zero,
          onPressed: () {
            TabNavigatorRouter(
              navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
              currentPageKey: AppRouteManager.currentPage,
            ).pop();
          },
          style: const NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
            color: AppColors.colorWhite,
          ),
          child: const Icon(
            Icons.arrow_back,
            color: AppColors.colorBlack,
            size: 19,
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Select Alcohol by volume".i18n, style: AppTextStyle().appBarTextStyle),
          ],
        ),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: widget.itemBloc.itemAbvState,
        builder: (context, snapshot) {
          if (widget.itemBloc.itemAbvState.value.isLoading()) {
            return const DefaultLoadingWidget();
          } else if (widget.itemBloc.itemAbvState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 33,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await showAbvBottomSheet();
                    },
                    child: Neumorphic(
                      padding: AppPaddingConstants().itineraryPadding,
                      style: NeumorphicStyle(
                        surfaceIntensity: 0.15,
                        color: AppColors.colorWhite,
                        depth: 8,
                        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add),
                          const SizedBox(
                            width: 13,
                          ),
                          Text(
                            "Add Alcohol by volume".i18n,
                            style: AppTextStyle().darkTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 33,
                  ),
                  Visibility(
                    visible: widget.itemBloc.resItemAbvModel.data?.list?.isEmpty ?? true,
                    child: Text("No data available".i18n),
                  ),
                  StreamBuilder(
                    stream: widget.itemBloc.itemAbvValue,
                    builder: (context, snapshot) {
                      return ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.itemBloc.resItemAbvModel.data!.list!.map((e) {
                          return Padding(
                            padding: AppPaddingConstants().bottom25,
                            child: AppCircleRadioOption(
                              value: e,
                              groupValue: widget.itemBloc.itemAbvValue.valueOrNull,
                              text: e.name!,
                              onChanged: (val) {
                                widget.itemBloc.itemAbvValue.add(val);
                              },
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> showAbvBottomSheet() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController descController = TextEditingController();

    BehaviorSubject<bool> nameTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> descTap = BehaviorSubject<bool>.seeded(false);
    BehaviorSubject<bool> nameError = BehaviorSubject<bool>.seeded(false);

    await AppBottomSheet(
      child: Container(
        color: AppColors.colorWhite,
        width: double.infinity,
        padding: EdgeInsets.zero,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Text(
                "Add Alcohol by volume".i18n,
                style: AppTextStyle().darkTextStyle,
              ),
              const SizedBox(
                height: 25,
              ),
              Focus(
                onFocusChange: (val) {
                  nameTap.add(val);
                },
                child: StreamBuilder(
                  stream: nameTap,
                  builder: (context, snapshot) {
                    return Column(
                      children: [
                        AppTextField(
                          textEditingController: nameController,
                          label: "Name".i18n,
                          isFocused: nameTap.value,
                          showError: nameError.value,
                          validatorFunction: (value) {
                            if (value == null || value.isEmpty) {
                              nameTap.add(nameTap.value);
                              nameError.add(true);
                            } else {
                              nameTap.add(nameTap.value);
                              nameError.add(false);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        StreamBuilder(
                          stream: nameError,
                          builder: (context, snapshot) {
                            return Visibility(
                              visible: nameError.value,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name is required".i18n,
                                  style: AppTextStyle().errorStyle,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Focus(
                onFocusChange: (val) {
                  descTap.add(val);
                },
                child: StreamBuilder(
                  stream: descTap,
                  builder: (context, snapshot) {
                    return AppTextField(
                      textEditingController: descController,
                      label: "Description".i18n,
                      isFocused: descTap.value,
                      showError: false,
                      maxLines: 5,
                    );
                  },
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              AppButton(
                label: "ADD",
                onPressed: () {
                  _formKey.currentState!.validate();
                  if ((!nameError.value && nameController.text.isNotEmpty)) {
                    Navigator.pop(AppRouteManager.navigatorKey.currentContext!);
                    ReqItemRegionsModel req = ReqItemRegionsModel(
                      name: nameController.text,
                      storeIdList: [RootBloc.store!.id!],
                      description: descController.text,
                    );
                    widget.itemBloc.postItemAbv(req);
                  }
                },
              ),
              const SizedBox(
                height: 32,
              ),
            ],
          ),
        ),
      ),
    ).showBottomSheet();
  }
}
