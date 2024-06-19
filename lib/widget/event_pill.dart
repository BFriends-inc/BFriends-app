import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class EventPill extends StatefulWidget {
  const EventPill({
    super.key,
    required this.pillPosition,
    required this.title,
    required this.date,
    required this.imageURL,
    required this.maxPpl,
    required this.ppl,
  });
  final double pillPosition;
  final String title, imageURL;
  final DateTime date;
  final int ppl, maxPpl;

  @override
  State<StatefulWidget> createState() => EventPillState();
}

class EventPillState extends State<EventPill> {
  final pillSizeH = 120.0; //how large the pill is vertically
  final pillPosH = 50.0; //how high the pill is positioned
  final imgH = 110.0, imgW = 110.0; //how large the image is

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedPositioned(
      bottom: pillPosH,
      left: 20,
      right: 20,
      duration: Durations.short4,
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () {
          // navigate to event details
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: pillSizeH,
            decoration: BoxDecoration(
              color: theme.colorScheme.background,
              borderRadius: BorderRadius.circular(20),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  blurRadius: 20,
                  offset: Offset.zero,
                  color: Colors.grey.withOpacity(0.5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                  width: imgW,
                  height: imgH,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.asset(
                      'assets/images/BFriends_logo_full.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: theme.textTheme.bodyLarge, //need edit
                        ),
                        const Text('LoremIpdasunfjkfn'), // need edit
                      ],
                    ),
                  ),
                ),
              ],
              //image
              //column
              //info
            ),
          ),
        ),
      ),
    );
  }
}
