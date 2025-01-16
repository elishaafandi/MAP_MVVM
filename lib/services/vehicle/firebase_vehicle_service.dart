import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movease/models/pre_inspection_model.dart';
import 'package:movease/models/vehicle.dart';
import 'package:movease/services/vehicle/vehicle_service.dart';

class FirebaseVehicleService implements VehicleService {
  final _firestore = FirebaseFirestore.instance;

  @override
  Future<List<Vehicle>> getVehiclesByUser(String userId) async {
    final snapshot = await _firestore
        .collection('vehicles')
        .where('user_id', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Vehicle.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> addVehicle(Vehicle vehicle) async {
    await _firestore.collection('vehicles').add(vehicle.toMap());
  }

  @override
  Future<void> updateVehicle(
      String vehicleId, Map<String, dynamic> data) async {
    await _firestore.collection('vehicles').doc(vehicleId).update(data);
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    await _firestore.collection('vehicles').doc(vehicleId).delete();
  }

  @override
  Future<List<Vehicle>> fetchVehicles() async {
    final snapshot = await _firestore
        .collection('vehicles')
        .where('availability', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Vehicle.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<Map<String, dynamic>> getVehicleDetails(String vehicleId) async {
    try {
      // Get vehicle document
      final vehicleDoc =
          await _firestore.collection('vehicles').doc(vehicleId).get();

      if (!vehicleDoc.exists) {
        throw Exception('Vehicle not found');
      }

      Map<String, dynamic> vehicleData = vehicleDoc.data()!;
      String userId = vehicleData['user_id'];

      // Get user document
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      }

      // Combine vehicle and user data
      return {
        'id': vehicleId,
        ...vehicleData,
        ...userDoc.data()!, // Include user details
      };
    } catch (e) {
      throw Exception('Failed to fetch vehicle details: $e');
    }
  }

  @override
  Future<void> submitPreInspectionForm(Map<String, dynamic> formData) async {
    final batch = _firestore.batch();

    // Add the inspection form
    final formRef = _firestore.collection('pre_inspection_forms').doc();
    batch.set(formRef, {
      ...formData,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update the booking status
    final bookingRef =
        _firestore.collection('bookings').doc(formData['bookingId']);
    batch.update(bookingRef, {
      'status': 'Pre-Inspection Completed',
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    // Update the vehicle status
    final vehicleRef =
        _firestore.collection('vehicles').doc(formData['vehicleId']);
    batch.update(vehicleRef, {
      'status': 'Pre-Inspection Completed',
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _firestore
          .collection('bookings')
          .doc(bookingId)
          .update({'renterStatus': status});
    } catch (e) {
      print('Error updating booking status: $e');
      rethrow;
    }
  }

  @override
  Future<PreInspectionFormModel?> fetchInspectionForm(String bookingId) async {
    try {
      final querySnapshot = await _firestore
          .collection('pre_inspection_forms')
          .where('bookingId', isEqualTo: bookingId)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return PreInspectionFormModel.fromMap(querySnapshot.docs.first.data());
      }
    } catch (e) {
      print('Error fetching inspection form: $e');
      rethrow;
    }
    return null;
  }
}
