import 'package:flutter/widgets.dart';

abstract class BlocBase {
  /// Disposes any resources associated with this bloc.
  void dispose();
}

class BlocProvider<T extends BlocBase> extends StatefulWidget {
  final T _bloc;
  final Widget _child;

  BlocProvider({@required T bloc, @required Widget child, Key key})
      : this._bloc = bloc,
        this._child = child,
        super(key: key);

  /// Finds the nearest bloc of the given type in the widget tree.
  static T of<T extends BlocBase>(BuildContext context) {
    final type = _typeOf<BlocProvider<T>>();
    BlocProvider<T> provider = context.ancestorWidgetOfExactType(type);
    return provider._bloc;
  }

  static Type _typeOf<T>() => T;

  @override
  State<StatefulWidget> createState() => new _BlocProviderState();
}

class _BlocProviderState<T> extends State<BlocProvider<BlocBase>> {
  @override
  Widget build(BuildContext context) {
    return widget._child;
  }

  @override
  void dispose() {
    widget._bloc.dispose();
    super.dispose();
  }
}
