import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rt_chat/features/screens/chat_screen.dart';

import '../../core/app_ui/app_ui.dart';

class Screens extends StatelessWidget {
  final List<Widget> _screens = const [
    ChatScreen(),
    Placeholder(),
  ];

  const Screens({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigationCubit, int>(
      builder: (context, index) {
        return Scaffold(
          body: IndexedStack(
            index: index,
            children: _screens,
          ),
          bottomNavigationBar: NavigationBar(
            selectedIndex: index,
            onDestinationSelected: (i) =>
                context.read<NavigationCubit>().setIndex(i),
            destinations: const [
              NavigationDestination(icon: Icon(Icons.chat), label: 'Chats'),
              NavigationDestination(icon: Icon(Icons.call), label: 'Calls'),
            ],
          ),
        );
      },
    );
  }
}


class NavigationCubit extends Cubit<int> {
  NavigationCubit() : super(0);

  void setIndex(int index) {
    emit(index); // ✅ Correct way to update state
  }
}
