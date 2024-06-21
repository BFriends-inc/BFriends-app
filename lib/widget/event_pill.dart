import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class EventPill extends StatefulWidget {
  const EventPill({
    super.key,
    required this.eventId,
    required this.pillPosition,
    required this.title,
    required this.date,
    required this.startTime,
    required this.imageURL,
    required this.maxPpl,
    required this.ppl,
  });
  final String eventId;
  final double pillPosition;
  final String title, imageURL, startTime;
  final DateTime date;
  final int ppl, maxPpl;

  @override
  State<StatefulWidget> createState() => _EventPillState();
}

class _EventPillState extends State<EventPill> with TickerProviderStateMixin {
  final pillSizeH = 120.0; // how large the pill is vertically
  final pillPosH = 50.0; // how high the pill is positioned
  final imgH = 110.0, imgW = 110.0; // how large the image is

  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  //method is called once when the state object is created.
  void initState() {
    //Calls the parent class's initState method
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000), //1 sec
      vsync: this, //helps to optimize the animation by preventing offscreen animations from consuming unnecessary resources.
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn, //curve, which starts slowly and speeds up.
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, //elasticOut curve, which starts quickly, overshoots, and then settles back.
    ));

    _controller.forward(); //starts the animation
  }

  @override
  //use for keep showing the animation eventhough we move from one widget to another
  void didUpdateWidget(covariant EventPill oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.eventId != oldWidget.eventId) {
      // Reset the animation controllers
      _controller.reset();
      // Restart the animations
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedPositioned(
      bottom: pillPosH,
      left: 20,
      right: 20,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () {
          // navigate to event details
        },
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MouseRegion(
            onEnter: (event) {
              _controller.forward();
            },
            onExit: (event) {
              _controller.reverse();
            },
            child: FadeTransition(
              opacity: _fadeInAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
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
                          child: Image.network(
                            widget.imageURL,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                    fontStyle: theme.textTheme.titleSmall!.fontStyle,
                                    fontSize: theme.textTheme.titleSmall!.fontSize,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const Divider(),
                                Text(
                                  'Date: ${widget.date.toString().split(' ')[0]}   ${widget.startTime}',
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.tertiaryContainer,
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    padding: const EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 3.0),
                                    child: Text('Joined: ${widget.ppl}/${widget.maxPpl}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                    // image
                    // column
                    // info
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
