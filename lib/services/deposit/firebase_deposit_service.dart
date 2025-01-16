import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movease/models/deposit_model.dart';
import 'package:movease/services/deposit/deposit_service.dart';

class FirebaseDepositService implements DepositService {
  final FirebaseFirestore _firestore;

  FirebaseDepositService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> saveDeposit(DepositModel deposit) async {
    try {
      await _firestore
          .collection('deposits')
          .doc(deposit.bookingId)
          .set(deposit.toMap());
    } catch (e) {
      throw Exception('Failed to save deposit: $e');
    }
  }

  Stream<DocumentSnapshot> getDepositStream(String bookingId) {
    return _firestore.collection('deposits').doc(bookingId).snapshots();
  }
}