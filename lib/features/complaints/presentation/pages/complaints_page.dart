import 'package:complaint_app/config/extensions/navigator.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_bloc.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_event.dart';
import 'package:complaint_app/features/complaints/presentation/bloc/show_all/show_all_complaints_state.dart';
import 'package:complaint_app/features/complaints/presentation/pages/add_complaints_page.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/home_header.dart';
import 'package:complaint_app/features/complaints/presentation/widgets/recent_complaint_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ComplaintsBloc>().add(GetAllComplaintsEvent(refresh: true));

    _scrollController.addListener(() {
      final bloc = context.read<ComplaintsBloc>();
      final state = bloc.state;

      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 100) {
        if (state is ComplaintSuccess && state.complaint.hasNext) {
          bloc.add(GetAllComplaintsEvent());
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 236, 240, 240),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                onFilterChanged: (status) {
                  context.read<ComplaintsBloc>().add(
                    GetAllComplaintsEvent(refresh: true, status: status),
                  );
                },
              ),
              const SizedBox(height: 24),
              Text('آخر الشكاوى المضافة', style: theme.textTheme.titleLarge),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<ComplaintsBloc, ComplaintsState>(
                  builder: (context, state) {
                    if (state is ComplaintLoading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state is ComplaintSuccess) {
                      final complaints = state.allComplaints;
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 2.h),
                        controller: _scrollController,
                        itemCount: complaints.length + 1,
                        itemBuilder: (context, index) {
                          if (index == complaints.length) {
                            final bloc = context.read<ComplaintsBloc>();
                            final filterName = bloc.currentFilter ?? "إضافية";

                            // إذا في صفحات إضافية → حمّل
                            if (state.complaint.hasNext) {
                              return Center(child: CircularProgressIndicator());
                            }

                            // إذا ما في → رسالة
                            return Center(
                              child: Text(
                                "لا يوجد شكاوى $filterName",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 14.sp),
                              ),
                            );
                          }

                          return RecentComplaintTile(
                            complaint: complaints[index],
                          );
                        },
                      );
                    } else if (state is ComplaintError) {
                      return Column(
                        children: [
                          Center(child: Text(state.message)),
                          IconButton(
                            icon: Icon(Icons.refresh),
                            onPressed: () {
                              context.read<ComplaintsBloc>().add(
                                GetAllComplaintsEvent(refresh: true),
                              );
                            },
                          ),
                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await context.pushPage(AddComplaintsPage());

          if (result == true) {
            context.read<ComplaintsBloc>().add(
              GetAllComplaintsEvent(refresh: true),
            );
          }
        },
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
    );
  }
}
