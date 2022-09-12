import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_calendar/domain/usecases/usecases.dart';
import 'package:flutter_calendar/presentation/screens/stats/bloc/stats_bloc.dart';
import 'package:flutter_calendar/presentation/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatsBloc(
        eventsUseCases: context.read<EventsUseCases>(),
      )..add(StatsSubscriptionRequested()),
      child: StatsView(),
    );
  }
}

class StatsView extends StatelessWidget {
  const StatsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<StatsBloc>().state;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(4.0.wp),
              child: Text(
                "Stats",
                style: TextStyle(
                  fontSize: 24.0.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.0.wp),
              child: Text(
                DateFormat.yMMMMd().format(
                  DateTime.now(),
                ),
                style: TextStyle(
                  fontSize: 14.0.sp,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3.0.wp,
                horizontal: 4.0.wp,
              ),
              child: const Divider(
                thickness: 2,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 3.0.wp,
                horizontal: 5.0.wp,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatus(
                      Colors.green, state.activeTodos, "Active Events"),
                  _buildStatus(
                      Colors.red, state.completedTodos, "Completed Events"),
                ],
              ),
            ),
            SizedBox(
              height: 8.0.wp,
            ),
            UnconstrainedBox(
              child: SizedBox(
                width: 70.0.wp,
                height: 70.0.wp,
                child: CircularStepProgressIndicator(
                  totalSteps: state.totalTodos == 0 ? 1 : state.totalTodos,
                  currentStep: state.completedTodos,
                  stepSize: 20,
                  selectedColor: Colors.red,
                  unselectedColor: Colors.grey[200],
                  padding: 0,
                  width: 150,
                  height: 150,
                  selectedStepSize: 22,
                  roundedCap: (_, __) => true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildStatus(Color color, int number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 3.0.wp,
          width: 3.0.wp,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              width: 0.5.wp,
              color: color,
            ),
          ),
        ),
        SizedBox(
          width: 3.0.wp,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$number',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0.sp,
              ),
            ),
            SizedBox(
              height: 2.0.wp,
            ),
            Text(
              text,
              style: TextStyle(fontSize: 12.0.sp, color: Colors.grey),
            ),
          ],
        )
      ],
    );
  }
}
