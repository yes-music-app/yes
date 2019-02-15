import 'package:flutter/widgets.dart';

abstract class BlocBase {
  /// Disposes any resources associated with this bloc.
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T bloc;
  final Widget child;

  BlocProvider({@required this.bloc, @required this.child, Key key})
      : super(key: key);

  /// Finds the nearest bloc of the given type in the widget tree.
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider.bloc;
  }

  static Type _typeOf<T>() => T;

  @override
  State<StatefulWidget> createState() => new _BlocProviderState();
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    widget.bloc.dispose();
    super.dispose();
  }
}
