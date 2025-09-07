import 'package:flutter/material.dart';

class ExpandableTextCard extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final Duration duration;
  final EdgeInsetsGeometry padding;

  const ExpandableTextCard({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 4,
    this.duration = const Duration(milliseconds: 240),
    this.padding = const EdgeInsets.symmetric(horizontal: 0),
  });

  @override
  State<ExpandableTextCard> createState() => _ExpandableTextCardState();
}

class _ExpandableTextCardState extends State<ExpandableTextCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final defaultStyle = Theme.of(context).textTheme.bodyMedium!;
    final textStyle = widget.style ?? defaultStyle;
    final textScale = MediaQuery.textScaleFactorOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // available width after padding
        final pad = widget.padding.resolve(TextDirection.ltr);
        final availableWidth = constraints.maxWidth - pad.left - pad.right;

        // measure a single line height
        final tpLine = TextPainter(
          text: TextSpan(text: 'M', style: textStyle),
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale,
          maxLines: 1,
        )..layout(maxWidth: availableWidth);
        final lineHeight = tpLine.height;
        final collapsedH = lineHeight * widget.maxLines;

        // measure full text height
        final tpFull = TextPainter(
          text: TextSpan(text: widget.text, style: textStyle),
          textDirection: TextDirection.ltr,
          textScaleFactor: textScale,
          maxLines: null,
        )..layout(maxWidth: availableWidth);
        final fullH = tpFull.height;

        final isOverflowing = fullH > collapsedH + 0.5;
        if (!isOverflowing) {
          return Padding(
            padding: widget.padding,
            child: Text(widget.text, style: textStyle),
          );
        }

        final targetHeight = isExpanded ? fullH : collapsedH;

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeInOut,
            height: targetHeight,
            // clip so extra lines are hidden when collapsed
            child: Padding(
              padding: widget.padding,
              child: Stack(
                children: [
                  // The single Text widget (always present)
                  ClipRect(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        widget.text,
                        style: textStyle,
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                  ),

                  // The ellipsis rendered as text inside the same padded box.
                  // We place it at the bottom-right of the padded area so it lines up
                  // with the last visible line. Adjust rightOffset if needed.
                  if (!isExpanded)
                    Positioned(
                      // right aligned inside the padding box
                      right: 0,
                      bottom: 0,
                      child: Padding(
                        // small horizontal inset so ellipsis doesn't touch edge
                        padding: const EdgeInsets.only(right: 2.0),
                        child: Text('...', style: textStyle),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
