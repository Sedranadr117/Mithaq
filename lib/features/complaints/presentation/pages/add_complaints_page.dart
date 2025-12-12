import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/core/params/params.dart';
<<<<<<< HEAD
import 'package:complaint_app/features/complaints/presentation/bloc/add_complaint_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/dropdown_cubit.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/custome_text_filed.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/drop_menue_widget.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/file_picker_widget.dart';
import 'package:complaint_app/features/home/presentation/pages/home_page.dart';
=======
import 'package:complaint_app/features/complaints/presentation/bloc/add/add_complaint_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/dropdown/dropdown_cubit.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_event.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/custome_text_filed.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/drop_menue_widget.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/file_picker_widget.dart';
import 'package:complaint_app/features/complaints/presentation/pages/complaints_page.dart';
>>>>>>> auth
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddComplaintsPage extends StatefulWidget {
  const AddComplaintsPage({super.key});

  @override
  State<AddComplaintsPage> createState() => _AddComplaintsPageState();
}

class _AddComplaintsPageState extends State<AddComplaintsPage> {
  final TextEditingController locationComplaintController =
      TextEditingController();
  final TextEditingController discriptionComplaintController =
      TextEditingController();
  final TextEditingController solutionComplaintController =
      TextEditingController();

  final List<String> types = [
    " تأخر في إنجاز معاملة",
    "	تعامل الموظف مقدم الخدمة",
    "	تعطل النظام التقني",
    "	تعقيد في الإجراءات",
    "	رسوم الخدمة",
    "	ضعف جودة الخدمة",
    "	طول مدة الانتظار",
    "	عدم الموافقة على الخدمة",
  ];
  final List<String> governorates = [
    "دمشق",
    "ريف دمشق",
    "حلب",
    "حمص",
    "اللاذقية",
    "حماة",
    "طرطوس",
    "دير الزور",
    "الحسكة",
    "الرقة",
    "إدلب",
    "السويداء",
    "درعا",
    "القنيطرة",
  ];
  final List<String> governmentAgencies = [
    "وزارة الإدارة المحلية والبيئة",
    "وزارة المالية",
    "وزارة الدفاع",
    "وزارة الاقتصاد والصناعة",
    "وزارة التعليم العالي",
    "وزارة الصحة",
    "وزارة التربية",
    "وزارة الطاقة",
    "أمانة رئاسة مجلس الوزراء",
    "وزارة الأشغال العامة والإسكان",
    "وزارة الاتصالات والتقانة",
    "وزارة الداخلية",
    "وزارة الزراعة",
    "وزارة الشؤون الاجتماعية والعمل",
    "وزارة الثقافة",
    "وزارة النقل",
    "وزارة العدل",
    "وزارة السياحة",
    "وزارة الإعلام",
    "وزارة الأوقاف",
    "نقابة المعلمين",
    "الاتحاد الرياضي العام",
    "الاتحاد العام للفلاحين",
    "مجلس الدولة",
    "وزارة التنمية الإدارية",
    "وزارة الخارجية والمغتربين",
    "وزارة الطوارئ والكوارث",
    "الهيئة العامة للمنافذ البرية والبحرية",
    "مصرف سوريا المركزي",
  ];

<<<<<<< HEAD
  PlatformFile? selectedFile;
=======
  List<PlatformFile> attachments = [];
>>>>>>> auth
  String? selectedType;
  String? selectedGovernorate;
  String? selectedAgency;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إضافة شكوى",
          style: TextStyle(color: Theme.of(context).scaffoldBackgroundColor),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: BlocConsumer<AddComplaintBloc, AddComplaintState>(
        listener: (context, state) {
          if (state is AddComplaintSuccess) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('تم إرسال الشكوى بنجاح!')));
            locationComplaintController.clear();
            discriptionComplaintController.clear();
            solutionComplaintController.clear();
            setState(() {
<<<<<<< HEAD
              selectedFile = null;
=======
              attachments = [];
>>>>>>> auth
              selectedType = null;
              selectedGovernorate = null;
              selectedAgency = null;
            });
<<<<<<< HEAD
=======
            context.read<ComplaintsBloc>().add(
              GetAllComplaintsEvent(refresh: true),
            );

>>>>>>> auth
            context.popPage(HomePage());
          } else if (state is AddComplaintError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('حدث خطأ: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AddComplaintLoading;

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  child: Column(
                    children: [
                      // الـ dropdowns والـ textfields كما هي
                      BlocProvider(
                        create: (_) => DropdownCubit<String>(),
                        child: CustomDropdown<String>(
                          label: 'اختر نوع الشكوى',
                          items: types,
                          onSelect: (item) => selectedType = item,
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocProvider(
                        create: (_) => DropdownCubit<String>(),
                        child: CustomDropdown<String>(
                          label: 'اختر المحافظة',
                          items: governorates,
                          onSelect: (item) => selectedGovernorate = item,
                        ),
                      ),
                      SizedBox(height: 20),
                      BlocProvider(
                        create: (_) => DropdownCubit<String>(),
                        child: CustomDropdown<String>(
                          label: 'اختر الجهة الحكومية',
                          items: governmentAgencies,
                          onSelect: (item) => selectedAgency = item,
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        label: 'ادخل موقع الشكوى',
                        controller: locationComplaintController,
                        isIcon: true,
<<<<<<< HEAD
                        icon: Icons.location_on,
=======
                        icon: Icons.location_on_outlined,
>>>>>>> auth
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        maxLines: 5,
                        label: 'ادخل وصف الشكوى',
                        controller: discriptionComplaintController,
                      ),
                      SizedBox(height: 20),
                      CustomTextField(
                        label: 'اقترح حلاً',
                        controller: solutionComplaintController,
                      ),
                      SizedBox(height: 20),
                      FilePickerWidget(
<<<<<<< HEAD
                        label: selectedFile == null
                            ? "اختر ملف (صورة أو PDF)"
                            : selectedFile!.name,
                        onFilePicked: (file) {
                          setState(() => selectedFile = file);
=======
                        label: attachments.isEmpty
                            ? "اختر ملف (صورة أو PDF)"
                            : attachments.length > 1
                            ? "${attachments.length} ملفات مختارة"
                            : "ملف مختار: ${attachments.first.name}",
                        onFilePicked: (file) {
                          if (file != null) {
                            setState(() {
                              attachments.add(file);
                            });
                          }
>>>>>>> auth
                        },
                      ),
                      SizedBox(height: 25),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: isLoading
                              ? null
                              : () {
                                  if (selectedType == null ||
                                      selectedGovernorate == null ||
                                      selectedAgency == null ||
                                      locationComplaintController
                                          .text
                                          .isEmpty ||
                                      discriptionComplaintController
                                          .text
                                          .isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "يرجى تعبئة جميع الحقول المطلوبة",
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  final params = AddComplaintParams(
                                    complaintType: selectedType!,
                                    governorate: selectedGovernorate!,
                                    governmentAgency: selectedAgency!,
                                    location: locationComplaintController.text
                                        .trim(),
                                    description: discriptionComplaintController
                                        .text
                                        .trim(),
                                    solutionSuggestion:
                                        solutionComplaintController.text.trim(),
<<<<<<< HEAD
                                    citizenId: 1,
                                    attachments: selectedFile?.path != null
                                        ? [selectedFile!.path!]
                                        : [],
=======
                                    attachments: attachments,
>>>>>>> auth
                                  );

                                  context.read<AddComplaintBloc>().add(
                                    SendComplaintEvent(params),
                                  );
                                },
                          child: Text("إرسال الشكوى"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
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
