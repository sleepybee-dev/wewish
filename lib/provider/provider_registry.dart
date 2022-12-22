import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:wewish/model/item_registry.dart';
import 'package:wewish/repository/repository_regi.dart';

class RegistryProvider extends ChangeNotifier {

  final RegiRepository _regiRepository = RegiRepository();
  List<RegistryItem> _registryList = [];
  var logger = Logger(printer: PrettyPrinter());

  List<RegistryItem> get registryList => _registryList;

  fetchRegistryList(String keyword) async {
    _registryList = await _regiRepository.fetchRegistry(keyword);
    logger.d(_registryList);
    notifyListeners();
  }

  clear() {
    _registryList.clear();
  }

}