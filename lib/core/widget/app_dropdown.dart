import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:ptecpos_mobile/core/domain/datasource/api_manager.dart';
import 'package:ptecpos_mobile/core/utils/app_colors.dart';
import 'package:ptecpos_mobile/core/widget/dropdown_state.dart';
import 'package:rxdart/rxdart.dart';

class AppDropdown<T> extends StatefulWidget {
  final List<DropdownMenuItem<T>>? items;
  final String hintText;
  final T? value;
  final ValueChanged<T?>? onChanged;
  final Color? borderColor;

  /// Api related variables
  final String? apiPath;
  final Map<String, dynamic>? queryParameters;
  final dynamic responseModel;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final Function(DropDownState value)? onDropDownStateCalled;

  const AppDropdown({
    super.key,
    this.items,
    required this.hintText,
    required this.onChanged,
    this.borderColor,
    this.value,
    this.apiPath,
    this.queryParameters,
    this.responseModel,
    this.loadingWidget,
    this.errorWidget,
    this.onDropDownStateCalled,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  final subscription = CompositeSubscription();
  BehaviorSubject<DropDownState> state = BehaviorSubject<DropDownState>.seeded(
    DropDownState.completed(true),
  );
  dynamic response;
  List<DropdownMenuItem<T>>? itemsValues = [];

  @override
  void initState() {
    super.initState();
    if (widget.apiPath != null) {
      state.add(DropDownState.loading());
      subscription.add(
        getItems().map((event) {
          if (!(event.error ?? true)) {
            response = event;
            response.data!.list!.forEach((e) {
              itemsValues?.add(
                DropdownMenuItem(
                  value: e,
                  child: Text(e.name),
                ),
              );
            });
            state.add(DropDownState.completed(true));
          } else {
            state.add(DropDownState.error(true));
          }
        }).onErrorReturnWith((error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          state.add(DropDownState.error(true));
        }).listen((event) {}),
      );
    } else {
      itemsValues = widget.items;
    }
  }

  @override
  void dispose() {
    subscription.clear();
    state.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: state,
      builder: (context, snapshot) {
        if (state.value.isLoading()) {
          widget.onDropDownStateCalled?.call(DropDownState.loading());
          return widget.loadingWidget!;
        }
        if (state.value.isError()) {
          widget.onDropDownStateCalled?.call(DropDownState.error(true));
          return widget.errorWidget!;
        }
        widget.onDropDownStateCalled?.call(DropDownState.completed(true));
        return DropdownButtonHideUnderline(
          child: Neumorphic(
            padding: const EdgeInsets.only(left: 25, right: 25),
            style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              color: AppColors.colorWhite,
              surfaceIntensity: 0.02,
              border: NeumorphicBorder(
                color: widget.borderColor ?? AppColors.colorTransparent,
              ),
              intensity: 0.43,
            ),
            child: DropdownButton(
              isExpanded: true,
              menuMaxHeight: 250,
              hint: Text(widget.hintText),
              icon: const Padding(
                padding: EdgeInsets.only(right: 12.0, left: 12),
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 17,
                ),
              ),
              value: widget.value,
              items: itemsValues,
              onChanged: widget.onChanged,
            ),
          ),
        );
      },
    );
  }

  Stream<dynamic> getItems() {
    return Stream.fromFuture(
      ApiManager().dio()!.get(widget.apiPath!, queryParameters: widget.queryParameters),
    ).map((event) {
      return widget.responseModel.fromJsonData(event.data);
    });
  }
}
