abstract class BottomNavEvent {}

class BottomNavTabChanged extends BottomNavEvent {
  final int index;
  BottomNavTabChanged(this.index);
}