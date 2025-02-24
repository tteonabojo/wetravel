import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wetravel/core/constants/app_colors.dart';
import 'package:wetravel/core/constants/app_icons.dart';

class ExpandableText extends StatefulWidget {
  const ExpandableText({
    super.key,
    required this.content,
    required this.bodyStyle,
  });

  final String content;
  final TextStyle bodyStyle;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;
  bool _isSingleLine = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _checkSingleLine();
  }

  void _checkSingleLine() {
    final textPainter = TextPainter(
      text: TextSpan(text: widget.content, style: widget.bodyStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: MediaQuery.of(context).size.width - 100);
    _isSingleLine = textPainter.didExceedMaxLines == false;
  }

  @override
  Widget build(BuildContext context) {
    if (_isSingleLine) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            widget.content,
            style: widget.bodyStyle,
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Stack(
        children: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 100,
                child: AnimatedCrossFade(
                  firstChild: Text(
                    widget.content,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: widget.bodyStyle,
                  ),
                  secondChild: Text(
                    widget.content,
                    maxLines: null,
                    overflow: TextOverflow.visible,
                    style: widget.bodyStyle,
                  ),
                  crossFadeState: _isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 300),
                  firstCurve: Curves.easeInOut,
                  secondCurve: Curves.easeInOut,
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: SvgPicture.asset(
              _isExpanded ? AppIcons.chevronUp : AppIcons.chevronDown,
              color: AppColors.grayScale_550,
            ),
          ),
        ],
      ),
    );
  }
}
