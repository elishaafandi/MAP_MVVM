import 'package:flutter/material.dart';
import 'package:map_mvvm/view/viewmodel.dart';
import '../../models/deposit_model.dart';
import '../../models/booking_with_details.dart';
import '../../services/deposit/deposit_service.dart';

class PriceBreakdown {
  final double totalPrice;
  final double deposit;
  final double remaining;

  PriceBreakdown({
    required this.totalPrice,
    required this.deposit,
    required this.remaining,
  });
}

 class PayDepositViewModel extends Viewmodel {
  final DepositService _depositService;
  final BookingWithDetails booking;
  String _selectedPaymentMethod = "Online Banking";

  PayDepositViewModel({
    required DepositService depositService,
    required this.booking,
  }) : _depositService = depositService;

  @override
  void init() {
    // Initialize anything needed when the viewmodel is created
    super.init();
  }

  String get selectedPaymentMethod => _selectedPaymentMethod;
  List<String> get paymentMethods => ["Online Banking", "QR Code"];

  Map<String, dynamic> get carDetails => {
    "car": booking.vehicleName,
    "plateNumber": booking.plateNo,
    "bookingPeriod": "${booking.pickupDate} ${booking.pickupTime} - ${booking.returnDate} ${booking.returnTime}",
    "totalPrice": booking.calculateTotalPrice,
    "pricePerHour": booking.pricePerHour,
  };

  void updatePaymentMethod(String? method) {
    if (method != null) {
      _selectedPaymentMethod = method;
      notifyListeners();
    }
  }

  PriceBreakdown getPriceBreakdown() {
    double totalPrice = booking.calculateTotalPrice;
    double deposit = totalPrice * 0.35;
    return PriceBreakdown(
      totalPrice: totalPrice,
      deposit: deposit,
      remaining: totalPrice - deposit,
    );
  }

  Future<void> proceedPayment(BuildContext context) async {
    try {
      final breakdown = getPriceBreakdown();
      final deposit = DepositModel(
        bookingId: booking.bookingId,
        paymentMethod: _selectedPaymentMethod,
        paymentStatus: 'Completed',
        pickupDate: booking.pickupDate,
        pickupTime: booking.pickupTime,
        returnDate: booking.returnDate,
        returnTime: booking.returnTime,
        timestamp: DateTime.now(),
        totalDeposit: breakdown.deposit,
        vehicleId: booking.vehicleId,
        vehicleName: booking.vehicleName,
      );

      await _depositService.saveDeposit(deposit);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Deposit payment processed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void cancelPayment(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment canceled'), backgroundColor: Colors.grey),
    );
    Navigator.pop(context, false);
  }
}


