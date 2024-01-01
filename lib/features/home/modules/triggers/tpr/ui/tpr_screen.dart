// ignore_for_file: deprecated_member_use

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/base/base_state.dart';
import 'package:ptecpos_mobile/core/localization/main18n.dart';
import 'package:ptecpos_mobile/core/root/root_bloc.dart';
import 'package:ptecpos_mobile/core/routes/app_router.dart';
import 'package:ptecpos_mobile/core/routes/tab_navigator.dart';
import 'package:ptecpos_mobile/core/theme/text_theme.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/utils/app_padding_constants.dart';
import 'package:ptecpos_mobile/core/utils/app_util.dart';
import 'package:ptecpos_mobile/core/utils/image_path.dart';
import 'package:ptecpos_mobile/core/utils/route_constants.dart';
import 'package:ptecpos_mobile/core/widget/app_bottom_sheet.dart';
import 'package:ptecpos_mobile/core/widget/app_button.dart';
import 'package:ptecpos_mobile/core/widget/app_radio_field.dart';
import 'package:ptecpos_mobile/core/widget/app_text_field.dart';
import 'package:ptecpos_mobile/core/widget/default_loading_widget.dart';
import 'package:ptecpos_mobile/core/widget/error_screen_widget.dart';
import 'package:ptecpos_mobile/core/widget/trigger_card.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/bloc/tpr_bloc.dart';
import 'package:ptecpos_mobile/features/home/modules/triggers/tpr/model/res_trigger_model.dart';
import 'package:rxdart/rxdart.dart';

class TprScreen extends StatefulWidget {
  const TprScreen({super.key});

  @override
  State<TprScreen> createState() => _TprScreenState();
}

class _TprScreenState extends BaseState<TprScreen> {
  final TprBloc tprBloc = TprBloc();

  @override
  void initState() {
    super.initState();
    buttonBehaviour();
    tprBloc.initData();
    tprBloc.scrollController.addListener(tprBloc.scrollListener);
  }

  void buttonBehaviour() {
    RootBloc().changeBottomBarBehaviour(
      onTap: () {
        TabNavigatorRouter(
          navigatorKey: AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
          currentPageKey: AppRouteManager.currentPage,
        ).pushNamed(AppRouteConstants.addTprScreen)?.then((value) {
          tprBloc.initData();
          buttonBehaviour();
        });
      },
      bottomBarIconPath: icPlusIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: StreamBuilder(
        stream: tprBloc.tprState,
        builder: (context, snapshot) {
          if (tprBloc.tprState.value.isLoading()) {
            return const DefaultLoadingWidget();
          }
          if (tprBloc.tprState.value.isError()) {
            return const ErrorWidgetScreen();
          }
          return SingleChildScrollView(
            controller: tprBloc.scrollController,
            child: Padding(
              padding: AppPaddingConstants().leftRight25,
              child: Column(
                children: [
                  const SizedBox(
                    height: 32,
                  ),

                  /// App bar
                  buildAppBar(),

                  StreamBuilder(
                    stream: tprBloc.filterTprState,
                    builder: (context, snapshot) {
                      if (tprBloc.filterTprState.value.isLoading()) {
                        return const DefaultLoadingWidget();
                      }
                      if (tprBloc.filterTprState.value.isError()) {
                        return const ErrorWidgetScreen();
                      }
                      if (tprBloc.resTriggerModel.data?.list?.isEmpty ?? true) {
                        return Text("No triggers found".i18n);
                      }
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: tprBloc.resTriggerModel.data!.list!.length,
                            itemBuilder: (ctx, index) {
                              Trigger trigger = tprBloc.resTriggerModel.data!.list![index];
                              return TriggerTile(
                                itemId: trigger.id!,
                                itemSku: trigger.quantity!.toString(),
                                storeItemName: trigger.storeItemName!,
                                onEditTap: () {
                                  tprBloc.resetValue();
                                  TabNavigatorRouter(
                                    navigatorKey:
                                        AppRouteManager.rootNavigatorKeys[AppRouteManager.currentPage]!,
                                    currentPageKey: AppRouteManager.currentPage,
                                  ).pushNamed(
                                    AppRouteConstants.addTprScreen,
                                    arguments: {
                                      "id": trigger.id!,
                                    },
                                  )?.then((value) {
                                    tprBloc.initData();
                                    buttonBehaviour();
                                  });
                                },
                                onDeleteTap: () {
                                  alertBox(context, trigger.id!);
                                },
                              );
                            },
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          StreamBuilder(
                            stream: tprBloc.loadingTriggers,
                            builder: (context, snapshot) {
                              if (tprBloc.loadingTriggers.value) {
                                return const CircularProgressIndicator();
                              } else {
                                return const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(
                    height: 150,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Temporary price reduction".i18n,
          style: AppTextStyle().employeeTextStyle,
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                if (!tprBloc.isAppliedClick) {
                  tprBloc.resetValue();
                }

                showFilterBottomSheet();
              },
              child: AppUtil.circularImageWidget(
                iconData: Icons.filter_list_alt,
                height: 18,
                paddingAll: 10,
                depth: 0.1,
              ),
            ),
            const SizedBox(
              width: 7,
            ),
          ],
        ),
      ],
    );
  }

  @override
  BaseBloc? getBaseBloc() {
    return tprBloc;
  }

  void showFilterBottomSheet() {
    BehaviorSubject<bool> showError = BehaviorSubject<bool>.seeded(false);
    late DateTime startDate;
    if (tprBloc.startDate != null) {
      startDate = tprBloc.startDate!;
    }
    String message = "Please add start date first".i18n;
    AppBottomSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Filters".i18n,
            style: const TextStyle(
              fontSize: 18,
              color: AppColors.colorBlack,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          AppTextField(
            isFocused: false,
            label: "Start Date".i18n,
            readOnly: true,
            suffixIcon: GestureDetector(
              onTap: () async {
                DateTime? dateTime = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(const Duration(days: 1)),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light(
                          primary: AppColors.colorPrimary,
                        ),
                      ),
                      child: child ?? Container(),
                    );
                  },
                );

                if (dateTime != null) {
                  startDate = dateTime;
                  String formattedDate = AppUtil.displayDateFormat(dateTime: dateTime)!;
                  tprBloc.startDateController.text = formattedDate;
                  tprBloc.startDate = dateTime;
                  tprBloc.endDateController.clear();
                }
              },
              child: SizedBox(
                height: 16,
                width: 16,
                child: Padding(
                  padding: AppPaddingConstants().employeePagePadding1,
                  child: SvgPicture.asset(
                    icCalendarIcon,
                    color: AppColors.colorLightGrey100,
                  ),
                ),
              ),
            ),
            textEditingController: tprBloc.startDateController,
            showError: false,
          ),
          const SizedBox(
            height: 20,
          ),
          AppTextField(
            isFocused: false,
            label: "End Date".i18n,
            readOnly: true,
            suffixIcon: GestureDetector(
              onTap: () async {
                if (tprBloc.startDateController.text.isNotEmpty) {
                  DateTime? dateTime = await showDatePicker(
                    context: context,
                    initialDate: startDate.add(const Duration(days: 1)),
                    firstDate: startDate.add(const Duration(days: 1)),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.colorPrimary,
                          ),
                        ),
                        child: child ?? Container(),
                      );
                    },
                  );

                  if (dateTime != null) {
                    showError.add(false);
                    String formattedDate = AppUtil.displayDateFormat(dateTime: dateTime)!;
                    tprBloc.endDateController.text = formattedDate;
                    tprBloc.endDate = dateTime;
                  }
                } else {
                  showError.add(true);
                }
              },
              child: SizedBox(
                height: 16,
                width: 16,
                child: Padding(
                  padding: AppPaddingConstants().employeePagePadding1,
                  child: SvgPicture.asset(
                    icCalendarIcon,
                    color: AppColors.colorLightGrey100,
                  ),
                ),
              ),
            ),
            textEditingController: tprBloc.endDateController,
            showError: false,
          ),
          const SizedBox(
            height: 3,
          ),
          StreamBuilder(
            stream: showError,
            builder: (context, snapshot) {
              if (showError.value) {
                return Text(
                  message,
                  style: AppTextStyle().errorStyle,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          const SizedBox(
            height: 20,
          ),
          StreamBuilder(
            stream: tprBloc.numberFilterValue,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: tprBloc.numberFilter.map((e) {
                  return Padding(
                    padding: AppPaddingConstants().right8,
                    child: AppRadioOption(
                      groupValue: tprBloc.numberFilterValue.valueOrNull,
                      value: e,
                      text: e,
                      onChanged: (val) {
                        tprBloc.numberFilterValue.add(val);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: "RESET".i18n,
                  labelColor: AppColors.colorPrimary,
                  color: AppColors.colorWhite,
                  onPressed: () {
                    tprBloc.resetValue();
                    tprBloc.initData();
                    AppRouteManager.pop();
                  },
                ),
              ),
              const SizedBox(
                width: 25,
              ),
              Expanded(
                child: AppButton(
                  label: "APPLY".i18n,
                  onPressed: () {
                    AppRouteManager.pop();
                    tprBloc.filterData();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    ).showBottomSheet().then((value) => showError.close());
  }

  Future<void> alertBox(BuildContext context, String id) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          title: Text('Remove Temporary Price Reduction'.i18n),
          content: Text("Are you sure you want to remove this 'Reduction'?".i18n),
          actions: [
            Padding(
              padding: AppPaddingConstants().bottom8,
              child: AppButton(
                label: "CANCEL".i18n,
                onPressed: () {
                  Navigator.pop(ctx);
                },
                labelColor: AppColors.colorPrimary,
                color: AppColors.colorWhite,
                height: 32,
              ),
            ),
            AppButton(
              label: "Remove".i18n,
              onPressed: () {
                Navigator.pop(ctx);
                tprBloc.deleteTpr(id);
              },
              height: 32,
            ),
          ],
        );
      },
    );
  }
}
