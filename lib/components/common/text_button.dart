import 'package:flutter/material.dart';

class TextButton extends StatelessWidget {
  final VoidCallback _onPressed;
  final Color _fillColor;
  final Color _highlightColor;
  final TextStyle _textStyle;
  final double _radius;
  final BoxConstraints _constraints;
  final EdgeInsetsGeometry _padding;
  final Widget _child;

  TextButton.withTheme({
    @required VoidCallback onPressed,
    @required ThemeData theme,
    double radius = 0,
    BoxConstraints constraints = const BoxConstraints(
      minWidth: 88,
      minHeight: 36,
    ),
    EdgeInsetsGeometry padding = EdgeInsets.zero,
    Widget child,
    bool isPrimary = true,
  })  : _onPressed = onPressed,
        _fillColor = isPrimary
            ? theme.buttonTheme.colorScheme.primary
            : theme.buttonTheme.colorScheme.secondary,
        _highlightColor = isPrimary
            ? theme.buttonTheme.colorScheme.primaryVariant
            : theme.buttonTheme.colorScheme.secondaryVariant,
        _textStyle = theme.textTheme.button,
        _radius = radius,
        _constraints = constraints,
        _padding = padding,
        _child = child;

  @override
  Widget build(BuildContext context) {
    return new RawMaterialButton(
      onPressed: _onPressed,
      fillColor: _fillColor,
      highlightColor: _highlightColor,
      textStyle: _textStyle,
      shape: new RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(_radius),
      ),
      constraints: _constraints,
      padding: _padding,
      child: _child,
      elevation: 0,
      highlightElevation: 0,
    );
  }
}
