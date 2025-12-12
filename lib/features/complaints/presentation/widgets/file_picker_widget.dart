import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerWidget extends StatelessWidget {
  final String label;
  final void Function(PlatformFile?) onFilePicked;

  const FilePickerWidget({
    super.key,
    required this.label,
    required this.onFilePicked,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
<<<<<<< HEAD
          allowMultiple: false,
=======
          allowMultiple: true,
>>>>>>> auth
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
        );

        if (result != null) {
          onFilePicked(result.files.first);
        } else {
          onFilePicked(null);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
            Icon(Icons.attach_file, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
