import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speedring/service/api_client.dart';
import 'package:speedring/service/api_url.dart';
import '../model/transaction_history_model.dart';

class TransactionHistoryController extends GetxController {
  final isAllSelected = true.obs;
  final searchQuery = "".obs;
  
  RxList<TransactionItem> allTransactions = <TransactionItem>[].obs;
  RxDouble coinBalance = 0.0.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    isLoading.value = true;
    try {
      final List<TransactionItem> tempTransactions = [];

      // 1. Fetch from /my-wallet
      var walletResponse = await ApiClient.getData(ApiUrl.getMyWallet);
      if (walletResponse.statusCode == 200) {
        final body = walletResponse.body is String ? jsonDecode(walletResponse.body) : walletResponse.body;
        if (body['data'] != null) {
          if (body['data']['balance'] != null) {
            coinBalance.value = (body['data']['balance'] as num).toDouble();
          }
          if (body['data']['transactions'] != null) {
            final List list = body['data']['transactions'];
            tempTransactions.addAll(list.map((e) => TransactionItem.fromCoinTransaction(e)));
          }
        }
      }

      // 2. Fetch from /my-transactions
      var planResponse = await ApiClient.getData(ApiUrl.getMyTransactions);
      if (planResponse.statusCode == 200) {
        final body = planResponse.body is String ? jsonDecode(planResponse.body) : planResponse.body;
        if (body['data'] != null) {
          final List list = body['data'];
          tempTransactions.addAll(list.map((e) => TransactionItem.fromPlanTransaction(e)));
        }
      }

      // 3. Sort descending by date
      tempTransactions.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      allTransactions.assignAll(tempTransactions);

    } catch (e) {
      debugPrint("Error fetching transactions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<TransactionItem> get filteredTransactions {
    List<TransactionItem> list = allTransactions;

    // Filter by Tab
    if (!isAllSelected.value) {
      // PURCHASES tab: Only show reload (coin purchases) and plan purchases
      list = list.where((tx) => 
        tx.type == TransactionType.reload || tx.type == TransactionType.planPurchase
      ).toList();
    }

    // Filter by Search Query
    if (searchQuery.value.isNotEmpty) {
      final q = searchQuery.value.toLowerCase();
      list = list.where((tx) => tx.title.toLowerCase().contains(q)).toList();
    }

    return list;
  }
}
