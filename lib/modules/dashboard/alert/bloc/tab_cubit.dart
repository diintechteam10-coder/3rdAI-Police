import 'package:flutter_bloc/flutter_bloc.dart';

class AlertTabCubit extends Cubit<int> {
  AlertTabCubit() : super(0);

  void changeTab(int index) => emit(index);
}
