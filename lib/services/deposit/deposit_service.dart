import 'package:movease/models/deposit_model.dart';

abstract class DepositService {
  Future<void> saveDeposit(DepositModel deposit);
}