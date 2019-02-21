import 'package:rxdart/rxdart.dart';
import 'package:yes_music/blocs/bloc_provider.dart';
import 'package:yes_music/data/firebase/firebase_transaction_handler.dart';
import 'package:yes_music/data/firebase/transaction_handler_base.dart';

class CreateBloc implements BlocBase {
  final FirebaseTransactionHandler _transactionHandler;

  ValueObservable<CreateSessionState> get transactionStream =>
      _transactionHandler.createState.stream;

  CreateBloc(this._transactionHandler);

  void createSession() {
    _transactionHandler.createSession();
  }

  @override
  void dispose() {}
}
