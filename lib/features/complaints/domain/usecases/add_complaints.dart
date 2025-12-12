<<<<<<< HEAD
import 'package:complaint_app/features/complaints/data/repositories/complaints_repository_impl.dart';
=======
import 'package:complaint_app/features/complaints/domain/repositories/complaints_repository.dart';
>>>>>>> auth
import 'package:dartz/dartz.dart';

import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/params/params.dart';
import '../entities/complaints_entity.dart';

class AddComplaint {
<<<<<<< HEAD
  final ComplaintRepositoryImpl repository;
=======
  final ComplaintRepository repository;
>>>>>>> auth

  AddComplaint({required this.repository});

  Future<Either<Failure, ComplaintEntity>> call({
    required AddComplaintParams params,
  }) {
    return repository.addComplaint(complaint: params);
  }
}
