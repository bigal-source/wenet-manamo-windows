// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

const Duration _kExpand = Duration(milliseconds: 200);

/// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ProgrammaticExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
///
/// See also:
///
///  * [ListTile], useful for creating expansion tile [children] when the
///    expansion tile represents a sublist.
///  * The "Expand/collapse" section of
///    <https://material.io/guidelines/components/lists-controls.html>.
class ProgrammaticExpansionTile extends StatefulWidget {
  /// Creates a single-line [ListTile] with a trailing button that expands or collapses
  /// the tile to reveal or hide the [children]. The [initiallyExpanded] property must
  /// be non-null.
  const ProgrammaticExpansionTile({
    required Key key,
    required this.listKey,
    this.leading,
    required this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.isList      = false,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children = const <Widget>[],
    this.trailing,
    this.initiallyExpanded = false,
    this.disableTopAndBottomBorders = false,
  }) : super(key: key);

  final Key listKey;

  /// A widget to display before the title.
  ///
  /// Typically a [CircleAvatar] widget.
  final Widget? leading;

  /// The primary content of the list item.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final bool isThreeLine;
  final bool isList;

  /// Called when the tile expands or collapses.
  ///
  /// When the tile starts expanding, this function is called with the value
  /// true. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChanged;

  /// The widgets that are displayed when the tile expands.
  ///
  /// Typically [ListTile] widgets.
  final List<Widget?> children;

  /// The color to display behind the sublist when expanded.
  final Color? backgroundColor;

  /// A widget to display instead of a rotating arrow icon.
  final Widget? trailing;

  /// Specifies if the list tile is initially expanded (true) or collapsed (false, the default).
  final bool initiallyExpanded;

  /// Disable to borders displayed at the top and bottom when expanded
  final bool disableTopAndBottomBorders;

  @override
  ProgrammaticExpansionTileState createState() =>
      ProgrammaticExpansionTileState();
}
class ProgrammaticExpansionTileState extends State<ProgrammaticExpansionTile> with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ColorTween _borderColorTween = ColorTween();
  final ColorTween _headerColorTween = ColorTween();
  final ColorTween _iconColorTween = ColorTween();
  final ColorTween _backgroundColorTween = ColorTween();

  late AnimationController _controller;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<Color?> _borderColor;
  late Animation<Color?> _headerColor;
  late Animation<Color?> _iconColor;
  late Animation<Color?> _backgroundColor;

  bool _isExpanded = false;
  bool _isList     = false;

  @override
  void initState() {
    super.initState();
    _isList     = widget.isList;
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _iconTurns = _controller.drive(_halfTween.chain(_easeInTween));
    _borderColor = _controller.drive(_borderColorTween.chain(_easeOutTween));
    _headerColor = _controller.drive(_headerColorTween.chain(_easeInTween));
    _iconColor = _controller.drive(_iconColorTween.chain(_easeInTween));
    _backgroundColor =
        _controller.drive(_backgroundColorTween.chain(_easeOutTween));

    _isExpanded = PageStorage.of(context)
            .readState(context, identifier: widget.listKey) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) _controller.value = 1.0;

    // Schedule the notification that widget has changed for after init
    // to ensure that the parent widget maintains the correct state
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
      if (widget.onExpansionChanged != null &&
          _isExpanded != widget.initiallyExpanded) {
        widget.onExpansionChanged!(_isExpanded);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool expanded) {
    if (_isExpanded != expanded) {
      setState(() {
        _isExpanded = expanded;
        if (_isExpanded) {
          _controller.forward();
        } else {
          _controller.reverse().then<void>((void value) {
            if (!mounted) return;
            setState(() {
              // Rebuild without widget.children.
            });
          });
        }
        PageStorage.of(context)
            .writeState(context, _isExpanded, identifier: widget.listKey);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          child: ListTileTheme.merge(
            iconColor: _iconColor.value,
            textColor: _headerColor.value,
            child: ListTile(
              onTap: toggle,
              leading: widget.leading,
              title: widget.title,
              subtitle: widget.subtitle,
              isThreeLine: widget.isThreeLine,
              trailing: widget.trailing ??
                  RotationTransition(
                    turns: _iconTurns,
                    child: const Icon(Icons.expand_more),
                  ),
            ),
          ),
        ),
        ClipRect(
          child: Align(
            heightFactor: _heightFactor.value,
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _borderColorTween.end = theme.dividerColor;
    _headerColorTween
      ..begin = theme.textTheme.titleMedium!.color
      ..end = theme.colorScheme.secondary;
    _iconColorTween
      ..begin = theme.unselectedWidgetColor
      ..end = theme.colorScheme.secondary;
    _backgroundColorTween.end = widget.backgroundColor;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final bool closed = !_isExpanded && _controller.isDismissed;
    return AnimatedBuilder(
      animation: _controller.view,
      builder: _buildChildren,
      child: closed ? null : ( _isList == true ? Container(
        padding:const EdgeInsets.only(left: 16),
        decoration: const BoxDecoration(
          color: Colors.white70
        ),
        height: MediaQuery.of(context).size.height/2.5,
        child:  GridView.count(
            shrinkWrap: true,
            primary: false,
            padding: const EdgeInsets.all(0),
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
            crossAxisCount:  6,
            childAspectRatio: 0.7,
            children: widget.children as List<Widget>
        ),
      ) : Column(children: widget.children as List<Widget>)),
    );
  }
}
