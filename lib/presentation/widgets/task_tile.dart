import 'package:flutter/material.dart';
import 'package:flutter_calendar/data/models/event_model/event_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../utils/aap_theme/theme.dart';
//niraj
class TaskTile extends StatefulWidget {
  final EventModel? event;
  const TaskTile(this.event);

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      alignment: TimelineAlign.manual,
      lineXY: 0.23,
      beforeLineStyle: LineStyle(color: Color(0xFF63d4c0).withOpacity(0.7)),
      // isFirst: index == 0 ? true : false,
      indicatorStyle: IndicatorStyle(
        color: Color(0xFF63d4c0),
        indicatorXY: 0.3,
        drawGap: true,
        width: 30,
        height: 30,
      ),
      // isLast: index == events.length - 1 ? true : false,
      startChild: Center(
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Container(
            alignment: const Alignment(0.0, -0.50),
            child: Text(
              widget.event!.startTime!.format(context),
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                fontSize: 18,
                color: Color(0xFF6fddaf).withOpacity(0.6),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
      endChild: Padding(
        padding:
            const EdgeInsets.only(left: 16, right: 10, top: 10, bottom: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              child: RichText(
                text: TextSpan(
                  text: widget.event!.title!,
                  style: GoogleFonts.lato(
                    fontSize: 23,
                    color: Color(0xFF6fddaf).withOpacity(0.8),
                    fontWeight: FontWeight.bold,
                    decoration: widget.event!.isCompleted == 1 ? TextDecoration.lineThrough : null,
                  ),
                  children: [
                    TextSpan(
                      text: "  from: " +
                          widget.event!.startTime!.format(context) +
                          " to " +
                          widget.event!.endTime!,
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        color: Color(0xFF6fddaf).withOpacity(0.8),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () => setState(
                () {
                  isVisible = !isVisible;
                },
              ),
            ),
            Visibility(
              visible: isVisible,
              child: Text(
                widget.event!.note!,
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Color(0xFF6fddaf).withOpacity(0.6),
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getBGClr(int no) {
    switch (no) {
      case 0:
        return primaryClr;
      case 1:
        return pinkClr;
      case 2:
        return yellowClr;
      default:
        return bluishClr;
    }
  }
}
