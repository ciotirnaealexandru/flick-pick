import 'package:flutter/material.dart';

class ExpandableTextCard extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final int maxLines;
  final Duration duration;

  const ExpandableTextCard({
    super.key,
    required this.text,
    this.style,
    this.maxLines = 4,
    this.duration = const Duration(milliseconds: 240),
  });

  @override
  State<ExpandableTextCard> createState() => _ExpandableTextCardState();
}

class _ExpandableTextCardState extends State<ExpandableTextCard> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final textStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium!;
    final textScale = MediaQuery.textScalerOf(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        // measure one-line height
        final tpLine = TextPainter(
          text: TextSpan(text: 'M', style: textStyle),
          textDirection: TextDirection.ltr,
          textScaler: textScale,
          maxLines: 1,
        )..layout(maxWidth: constraints.maxWidth);
        final lineHeight = tpLine.height;
        final collapsedH = lineHeight * widget.maxLines;

        // measure full text height
        final tpFull = TextPainter(
          text: TextSpan(text: widget.text, style: textStyle),
          textDirection: TextDirection.ltr,
          textScaler: textScale,
          maxLines: null,
        )..layout(maxWidth: constraints.maxWidth);
        final fullH = tpFull.height;

        final isOverflowing = fullH > collapsedH + 0.5;
        if (!isOverflowing) {
          return Text(widget.text, style: textStyle, softWrap: true);
        }

        final targetH = isExpanded ? fullH : collapsedH;
        final twoLinesHeight = lineHeight * 2; // overlay covers last two lines

        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => setState(() => isExpanded = !isExpanded),
          child: AnimatedContainer(
            duration: widget.duration,
            curve: Curves.easeInOut,
            height: targetH,
            child: Stack(
              children: [
                // The actual text (single widget)
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

                // overlay covering last two lines when collapsed
                if (!isExpanded)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    height: twoLinesHeight,
                    child: IgnorePointer(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Theme.of(
                                context,
                              ).scaffoldBackgroundColor.withOpacity(0.94),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 8,
                              offset: Offset(0, -4),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
