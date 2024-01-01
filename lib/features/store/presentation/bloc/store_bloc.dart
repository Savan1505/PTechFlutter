import 'package:flutter/material.dart';
import 'package:ptecpos_mobile/core/base/base_bloc.dart';
import 'package:ptecpos_mobile/core/utils/user_util.dart';
import 'package:ptecpos_mobile/core/widget/debouncer.dart';
import 'package:ptecpos_mobile/features/store/data/model/res_storeitems_model.dart';
import 'package:ptecpos_mobile/features/store/presentation/bloc/store_state.dart';
import 'package:ptecpos_mobile/features/store/repository/store_repo.dart';
import 'package:rxdart/rxdart.dart';

class StoreBloc extends BaseBloc {
  ScrollController scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  BehaviorSubject<bool> isSearchEnabled = BehaviorSubject<bool>.seeded(false);
  BehaviorSubject<StoreState> storeState = BehaviorSubject<StoreState>();
  BehaviorSubject<StoreState> searchedStoreState =
      BehaviorSubject<StoreState>.seeded(StoreState.completed(true));
  BehaviorSubject<bool> loadingStoreItem = BehaviorSubject<bool>.seeded(false);
  late StoreItemModel storeItemModel;
  final Debouncer debouncer = Debouncer(milliseconds: 400);

  StoreRepo storeRepo = StoreRepo();

  int pageNumber = 1;
  int pageSize = 20;

  StoreBloc() {
    UserUtil();
  }

  void getStoreItems() {
    pageNumber = 1;
    storeState.add(StoreState.loading());
    subscription.add(
      storeRepo.getStoreItemListApi(pageNumber: pageNumber, pageSize: pageSize).map((event) {
        storeItemModel = event;
        storeState.add(StoreState.completed(true));
      }).onErrorReturnWith((error, stackTrace) {
        storeState.add(StoreState.error(error));
        debugPrint(error.toString());
      }).listen((event) {}),
    );
  }

  void getSearchedStoreItems() {
    pageNumber = 1;
    searchedStoreState.add(StoreState.loading());
    subscription.add(
      storeRepo
          .getStoreItemListApi(
        pageNumber: pageNumber,
        pageSize: pageSize,
        name: searchController.text,
      )
          .map((event) {
        storeItemModel = event;
        searchedStoreState.add(StoreState.completed(true));
      }).onErrorReturnWith((error, stackTrace) {
        searchedStoreState.add(StoreState.error(error));
        debugPrint(error.toString());
      }).listen((event) {}),
    );
  }

  void scrollListener() {
    if (storeItemModel.listStoreElement!.length < storeItemModel.count! && !loadingStoreItem.value) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        loadingStoreItem.add(true);
        ++pageNumber;

        getStoreItemPaginated();
      }
    }
  }

  void getStoreItemPaginated() {
    subscription.add(
      storeRepo
          .getStoreItemListApi(pageNumber: pageNumber, pageSize: pageSize, name: searchController.text)
          .map((event) {
        storeItemModel.listStoreElement!.addAll(event.listStoreElement!);
        storeState.add(StoreState.completed(true));
        loadingStoreItem.add(false);
      }).onErrorReturnWith((error, stackTrace) {
        loadingStoreItem.add(false);
      }).listen((event) {}),
    );
  }
}
