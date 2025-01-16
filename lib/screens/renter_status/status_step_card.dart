import 'package:flutter/material.dart';
import 'package:movease/configs/constants.dart';

class StatusStepsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> steps;
  final Function(String) onStatusUpdate;

  const StatusStepsWidget({
    required this.steps,
    required this.onStatusUpdate,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: steps.length,
      itemBuilder: (context, index) => _buildStepCard(steps[index]),
    );
  }

  Widget _buildStepCard(Map<String, dynamic> step) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBlack,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: step['isActive'] ? AppTheme.primaryYellow : Colors.grey[850]!,
          width: step['isActive'] ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Icon(
          step['icon'],
          color: _getIconColor(step),
          size: 28,
        ),
        title: Text(
          step['title'],
          style: TextStyle(
            color: AppTheme.mainWhite,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          step['description'],
          style: TextStyle(color: Constants.textGrey),
        ),
        trailing: _buildActionButton(step),
      ),
    );
  }

  Color _getIconColor(Map<String, dynamic> step) {
    if (step['isCompleted']) return AppTheme.successGreen;
    if (step['isActive']) return AppTheme.primaryYellow;
    return Colors.grey;
  }

  Widget? _buildActionButton(Map<String, dynamic> step) {
    if (step['buttonText'] == null) return null;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryYellow,
        foregroundColor: AppTheme.backgroundBlack,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: step['isActive'] ? () => _handleButtonPress(step['buttonText']) : null,
      child: Text(
        step['buttonText']!,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _handleButtonPress(String buttonText) {
    final action = _getActionFromButtonText(buttonText);
    if (action.isNotEmpty) {
      onStatusUpdate(action);
    }
  }

  String _getActionFromButtonText(String buttonText) {
    switch (buttonText) {
    case 'CONFIRM DEPOSIT PAYMENT':
       return'CONFIRM_DEPOSIT_PAYMENT';
    case 'MAKE DELIVERY':
       return 'MAKE_DELIVERY';
    case 'CONFIRM PRE-INSPECTION':
       return'CONFIRM_PRE_INSPECTION';
    case 'CONFIRM USE VEHICLE':
       return 'START_USING';
    case 'CONFIRM RETURN':
      return 'CONFIRM_RETURN';
    case 'FILL POST-INSPECTION':
      return 'FILL_POST_INSPECTION';
    case 'CONFIRM FINAL PAYMENT':
       return'CONFIRM_FINAL_PAYMENT';
    case 'COMPLETE BOOKING':
       return 'COMPLETE_BOOKING';
    case 'RATE RENTEE':
       return'RENTEE_RATE_COMPLETED';
    default:
      return '';
    }
  }
}