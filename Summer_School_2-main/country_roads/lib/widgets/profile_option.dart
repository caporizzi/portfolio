import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/providers/user_profile_provider.dart';

class ProfileOption extends StatelessWidget {
  final String fieldName;
  final String label;
  final String value;
  final ValueChanged<String> onEdit;

  const ProfileOption({
    Key? key,
    required this.fieldName,
    required this.label,
    required this.value,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("$label: $value"),
        IconButton(
          onPressed: () {
            _showChangeFieldDialog(context, fieldName, label, value, onEdit);
          },
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }

  void _showChangeFieldDialog(BuildContext context, String fieldName, String label, String currentValue,
      ValueChanged<String> onSave) {
    final TextEditingController controller = TextEditingController();
    final userProfileProvider = Provider.of<UserProfileProvider>(context, listen: false);
    controller.text = currentValue;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change value for $label'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: "Enter new value"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                final newValue = controller.text;
                userProfileProvider.changeUserProfile({fieldName: newValue});
                onSave(newValue);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
