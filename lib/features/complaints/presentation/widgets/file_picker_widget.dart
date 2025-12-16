import 'package:complaint_app/config/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FilePickerWidget extends StatelessWidget {
  final String label;
  final void Function(PlatformFile?) onFilePicked;
  final int maxFileSizeInMB;
  final int? maxTotalSizeInMB;

  const FilePickerWidget({
    super.key,
    required this.label,
    required this.onFilePicked,
    this.maxFileSizeInMB = 10, // Default 10MB per file
    this.maxTotalSizeInMB, // Optional total size limit
  });

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.custom,
          allowedExtensions: ['jpg', 'png', 'jpeg', 'pdf'],
        );

        if (result != null && result.files.isNotEmpty) {
          final maxSizeBytes = maxFileSizeInMB * 1024 * 1024;
          final oversizedFiles = <PlatformFile>[];

          // Check each file size
          for (var file in result.files) {
            if (file.size > maxSizeBytes) {
              oversizedFiles.add(file);
            }
          }

          if (oversizedFiles.isNotEmpty) {
            final fileList = oversizedFiles
                .map((f) => '${f.name} (${_formatFileSize(f.size)})')
                .join('\n');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'الملفات التالية كبيرة جداً (الحد الأقصى: ${maxFileSizeInMB}MB):\n$fileList',
                ),
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          // If all files are valid, add the first one (or handle multiple)
          onFilePicked(result.files.first);
        } else {
          onFilePicked(null);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.textDisabledLight),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.attach_file, color: Theme.of(context).primaryColor),
          ],
        ),
      ),
    );
  }
}
