import 'package:bloc/bloc.dart';

enum BunnyBondDestination { home, explore, chats, profile }

class BunnyBondState {
  const new({
    this.username = '',
    this.password = '',
    this.isAuthenticated = false,
    this.loginError,
    this.destination = BunnyBondDestination.home,
    this.category = 'For you',
    this.messages = const [
      'Hey! Is one badminton slot still available?',
      'Yes! One is still free 😊',
      'Perfect. I can reach around 7:20.',
    ],
  });

  final String username;
  final String password;
  final bool isAuthenticated;
  final String? loginError;
  final BunnyBondDestination destination;
  final String category;
  final List<String> messages;

  BunnyBondState copyWith({
    String? username,
    String? password,
    bool? isAuthenticated,
    String? loginError,
    bool clearLoginError = false,
    BunnyBondDestination? destination,
    String? category,
    List<String>? messages,
  }) {
    return BunnyBondState(
      username: username ?? this.username,
      password: password ?? this.password,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      loginError: clearLoginError ? null : loginError ?? this.loginError,
      destination: destination ?? this.destination,
      category: category ?? this.category,
      messages: messages ?? this.messages,
    );
  }
}

class BunnyBondCubit extends Cubit<BunnyBondState> {
  new() : super(const BunnyBondState());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value, clearLoginError: true));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value, clearLoginError: true));
  }

  void login() {
    if (state.username.trim() == 'user123' && state.password == '123456') {
      emit(state.copyWith(isAuthenticated: true, clearLoginError: true));
      return;
    }
    emit(
      state.copyWith(loginError: 'Use user123 and 123456 to enter the demo.'),
    );
  }

  void selectDestination(int index) {
    emit(state.copyWith(destination: BunnyBondDestination.values[index]));
  }

  void selectCategory(String category) {
    emit(state.copyWith(category: category));
  }

  void sendMessage(String message) {
    final trimmed = message.trim();
    if (trimmed.isEmpty) return;
    emit(state.copyWith(messages: [...state.messages, trimmed]));
  }
}
