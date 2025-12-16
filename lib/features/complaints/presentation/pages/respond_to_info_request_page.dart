import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/config/helper/injection_container.dart';
import 'package:complaint_app/core/params/params.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/respond_info_request/respond_info_request_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/custome_text_filed.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/file_picker_widget.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/info_request_shimmer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RespondToInfoRequestPage extends StatefulWidget {
  final int infoRequestId;
  final int? complaintId; // Optional complaintId to fetch info request details

  const RespondToInfoRequestPage({
    super.key,
    required this.infoRequestId,
    this.complaintId,
  });

  @override
  State<RespondToInfoRequestPage> createState() =>
      _RespondToInfoRequestPageState();
}

class _RespondToInfoRequestPageState extends State<RespondToInfoRequestPage> {
  final TextEditingController responseMessageController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<PlatformFile> attachments = [];

  @override
  void dispose() {
    responseMessageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<RespondInfoRequestBloc>(),
      child: _RespondToInfoRequestPageContent(
        infoRequestId: widget.infoRequestId,
        complaintId: widget.complaintId,
        responseMessageController: responseMessageController,
        formKey: _formKey,
        attachments: attachments,
        onAttachmentsChanged: (newAttachments) {
          setState(() {
            attachments = newAttachments;
          });
        },
      ),
    );
  }
}

class _RespondToInfoRequestPageContent extends StatefulWidget {
  final int infoRequestId;
  final int? complaintId;
  final TextEditingController responseMessageController;
  final GlobalKey<FormState> formKey;
  final List<PlatformFile> attachments;
  final Function(List<PlatformFile>) onAttachmentsChanged;

  const _RespondToInfoRequestPageContent({
    required this.infoRequestId,
    this.complaintId,
    required this.responseMessageController,
    required this.formKey,
    required this.attachments,
    required this.onAttachmentsChanged,
  });

  @override
  State<_RespondToInfoRequestPageContent> createState() =>
      _RespondToInfoRequestPageContentState();
}

class _RespondToInfoRequestPageContentState
    extends State<_RespondToInfoRequestPageContent> {
  int? _selectedRequestId; // Track which request is currently selected

  @override
  void initState() {
    super.initState();
    // Initialize with the provided infoRequestId
    _selectedRequestId = widget.infoRequestId;

    // Fetch info request details when page opens if complaintId is provided
    if (widget.complaintId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<RespondInfoRequestBloc>().add(
            FetchInfoRequestEvent(
              complaintId: widget.complaintId!,
              infoRequestId: widget.infoRequestId,
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'الرد على طلب المعلومات',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<RespondInfoRequestBloc, RespondInfoRequestState>(
        listener: (context, state) {
          if (state is RespondInfoRequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('تم إرسال الرد بنجاح!'),
                backgroundColor: Theme.of(context).colorScheme.onPrimary,
              ),
            );
            widget.responseMessageController.clear();
            widget.onAttachmentsChanged([]);
            context.popPage(true); // Return true to indicate success
          } else if (state is RespondInfoRequestError) {
            String errorMessage = state.message;
            // Provide more user-friendly error messages
            if (state.message.contains('404') ||
                state.message.contains('not found')) {
              errorMessage =
                  'طلب المعلومات غير موجود. يرجى التحقق من رقم طلب المعلومات.';
            } else if (state.message.contains('401') ||
                state.message.contains('unauthorized')) {
              errorMessage = 'غير مصرح لك بالوصول. يرجى تسجيل الدخول مرة أخرى.';
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('حدث خطأ: $errorMessage'),
                backgroundColor: Theme.of(context).colorScheme.error,
                duration: const Duration(seconds: 4),
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is RespondInfoRequestLoading;
          final isFetching = state is FetchingInfoRequest;

          // Debug: Log state changes
          if (state is InfoRequestLoaded) {
            debugPrint(
              '📬 InfoRequestLoaded: ${state.selectedRequest?.requestMessage}',
            );
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: widget.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show all info requests if loaded
                      if (state is InfoRequestLoaded) ...[
                        if (state.infoRequest.content.isEmpty)
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 64,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'لا توجد طلبات معلومات',
                                  style: Theme.of(context).textTheme.titleLarge,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'لا توجد طلبات معلومات متاحة لهذه الشكوى',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface
                                            .withOpacity(0.7),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        else ...[
                          Text(
                            'طلبات المعلومات:',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          ...state.infoRequest.content.map((infoRequest) {
                            final isSelected =
                                infoRequest.id == _selectedRequestId;
                            return InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedRequestId = infoRequest.id;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Theme.of(
                                          context,
                                        ).colorScheme.primary.withOpacity(0.1)
                                      : Theme.of(
                                          context,
                                        ).colorScheme.surface.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(context).colorScheme.outline
                                              .withOpacity(0.3),
                                    width: isSelected ? 2 : 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: isSelected
                                              ? Theme.of(
                                                  context,
                                                ).colorScheme.primary
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.6),
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'طلب رقم: ${infoRequest.id}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: isSelected
                                                      ? Theme.of(
                                                          context,
                                                        ).colorScheme.primary
                                                      : Theme.of(
                                                          context,
                                                        ).colorScheme.onSurface,
                                                ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                infoRequest.status == 'PENDING'
                                                ? Colors.orange.withOpacity(0.2)
                                                : Colors.green.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          child: Text(
                                            infoRequest.status == 'PENDING'
                                                ? 'قيد الانتظار'
                                                : 'تم الرد',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color:
                                                      infoRequest.status ==
                                                          'PENDING'
                                                      ? Colors.orange.shade700
                                                      : Colors.green.shade700,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      infoRequest.requestMessage.isNotEmpty
                                          ? infoRequest.requestMessage
                                          : 'لا توجد رسالة',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.copyWith(
                                            fontStyle:
                                                infoRequest
                                                    .requestMessage
                                                    .isEmpty
                                                ? FontStyle.italic
                                                : FontStyle.normal,
                                            color:
                                                infoRequest
                                                    .requestMessage
                                                    .isEmpty
                                                ? Theme.of(context)
                                                      .colorScheme
                                                      .onSurface
                                                      .withOpacity(0.5)
                                                : null,
                                          ),
                                    ),
                                    if (infoRequest.responseMessage != null &&
                                        infoRequest
                                            .responseMessage!
                                            .isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              Icons.reply,
                                              size: 16,
                                              color: Colors.green.shade700,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                infoRequest.responseMessage!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color:
                                                          Colors.green.shade700,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    // Show attachments if available
                                    if (infoRequest.attachments.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: infoRequest.attachments.map((
                                          attachment,
                                        ) {
                                          return Chip(
                                            avatar: Icon(
                                              Icons.attach_file,
                                              size: 16,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                            label: Text(
                                              attachment.originalFilename,
                                              style: const TextStyle(
                                                fontSize: 12,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 16),
                        ],
                      ] else if (isFetching)
                        const InfoRequestShimmer()
                      else
                        Text(
                          'طلب معلومات رقم: ${widget.infoRequestId}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        maxLines: 5,
                        label: 'رسالة الرد',
                        controller: widget.responseMessageController,
                      ),
                      const SizedBox(height: 20),
                      FilePickerWidget(
                        label: widget.attachments.isEmpty
                            ? "اختر ملف (صورة أو PDF) - الحد الأقصى 10MB"
                            : widget.attachments.length > 1
                            ? "${widget.attachments.length} ملفات مختارة"
                            : "ملف مختار: ${widget.attachments.first.name}",
                        maxFileSizeInMB: 10,
                        onFilePicked: (file) {
                          if (file != null) {
                            // Check total size of all attachments
                            final currentTotalSize = widget.attachments
                                .fold<int>(0, (sum, file) => sum + file.size);
                            final newTotalSize = currentTotalSize + file.size;
                            final maxTotalSize = 50 * 1024 * 1024; // 50MB total

                            if (newTotalSize > maxTotalSize) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'إجمالي حجم الملفات كبير جداً (الحد الأقصى: 50MB)',
                                  ),
                                ),
                              );
                              return;
                            }

                            final updatedAttachments = List<PlatformFile>.from(
                              widget.attachments,
                            );
                            updatedAttachments.add(file);
                            widget.onAttachmentsChanged(updatedAttachments);
                          }
                        },
                      ),
                      if (widget.attachments.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        ...widget.attachments.asMap().entries.map((entry) {
                          final index = entry.key;
                          final file = entry.value;
                          final fileSizeMB = (file.size / (1024 * 1024))
                              .toStringAsFixed(2);
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.insert_drive_file,
                                  size: 20,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        file.name,
                                        style: const TextStyle(fontSize: 13),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '$fileSizeMB MB',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 20,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                  onPressed: () {
                                    final updatedAttachments =
                                        List<PlatformFile>.from(
                                          widget.attachments,
                                        );
                                    updatedAttachments.removeAt(index);
                                    widget.onAttachmentsChanged(
                                      updatedAttachments,
                                    );
                                  },
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                      const SizedBox(height: 25),
                      // Show selected request info
                      if (state is InfoRequestLoaded &&
                          _selectedRequestId != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'سيتم الرد على طلب رقم: $_selectedRequestId',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              (isLoading ||
                                  _selectedRequestId == null ||
                                  widget.responseMessageController.text
                                      .trim()
                                      .isEmpty)
                              ? null
                              : () {
                                  if (!widget.formKey.currentState!
                                      .validate()) {
                                    return;
                                  }

                                  if (widget.responseMessageController.text
                                      .trim()
                                      .isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text("يرجى إدخال رسالة الرد"),
                                      ),
                                    );
                                    return;
                                  }

                                  // Use selected request ID, fallback to widget.infoRequestId
                                  final requestIdToRespond =
                                      _selectedRequestId ??
                                      widget.infoRequestId;

                                  final params = RespondToInfoRequestParams(
                                    infoRequestId: requestIdToRespond,
                                    responseMessage: widget
                                        .responseMessageController
                                        .text
                                        .trim(),
                                    files: widget.attachments,
                                  );

                                  context.read<RespondInfoRequestBloc>().add(
                                    SendInfoRequestResponseEvent(params),
                                  );
                                },
                          child: const Text("إرسال الرد"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
