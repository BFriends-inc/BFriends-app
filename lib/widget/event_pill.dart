import 'package:bfriends_app/pages/event_detail.dart';
import 'package:bfriends_app/services/event_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  final pillSizeH = 120.0; //how large the pill is vertically
  final pillPosH = 50.0; //how high the pill is positioned
  final imgH = 110.0, imgW = 110.0; //how large the image is

  late AnimationController _controller;
  late AnimationController _colorController;
  late Animation<double> _fadeInAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  //add color
  late Animation<Color?> _colorAnimation;

  EventService eventService = EventService();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _colorController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync:
          this, //helps to optimize the animation by preventing offscreen animations from consuming unnecessary resources.
    )..repeat(reverse: true);

    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut, //curve, which starts slowly and speeds up.
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves
          .elasticOut, //elasticOut curve, which starts quickly, overshoots, and then settles back.
    ));

    _colorAnimation = ColorTween(
      begin: Colors.yellow,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _colorController,
      curve: Curves.linear,
    ));

    _controller.forward(); //starts the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    _colorController.dispose();
    super.dispose();
  }
  @override
  //to make sure that eventhough we move from one to another the animation still work
  void didUpdateWidget(covariant EventPill oldWidget) {
    // Reset animation when widget properties change
    //covariant is:
    //If the parent widget rebuilds and requests that this location in the tree update to 
    //display a new widget with the same [runtimeType] and [Widget.key], 
    //the framework will update the [widget] property of this [State] object to refer to 
    //the new widget and then call this method with the previous widget as an argument.
    if (widget.eventId != oldWidget.eventId) {
      _controller.reset();
      _controller.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    bool showGradient = (widget.ppl / widget.maxPpl) > 0.8;

    //debug
    //showGradient = true;
    return AnimatedPositioned(
      bottom: pillPosH,
      left: 20,
      right: 20,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onTap: () async {
          Map<String, dynamic>? eventData =
              await eventService.getEventById(widget.eventId);
              debugPrint(eventData.toString());
          if (eventData != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EventDetailsScreen(
                  event: eventData,
                ),
              ),
            );
          } else {
            // Handle case where event data is null
          }
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
            child: AnimatedBuilder(
              animation: _colorController,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _fadeInAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      height: pillSizeH,
                      decoration: BoxDecoration(
                        gradient: showGradient //change to gradient instead
                            ? LinearGradient(
                                colors: [_colorAnimation.value!, Colors.orange],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        color:
                            showGradient ? null : theme.colorScheme.background,
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
                              margin: const EdgeInsets.fromLTRB(
                                  10.0, 5.0, 10.0, 10.0),
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.title,
                                      style: TextStyle(
                                        fontStyle: theme
                                            .textTheme.titleSmall!.fontStyle,
                                        fontSize: theme
                                            .textTheme.titleSmall!.fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const Divider(),
                                    Text(
                                      'Date: ${widget.date.toString().split(' ')[0]}   ${widget.startTime}',
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 5.0, 0.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: theme
                                              .colorScheme.tertiaryContainer,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        padding: const EdgeInsets.fromLTRB(
                                            5.0, 3.0, 5.0, 3.0),
                                        child: showGradient
                                            ? Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    Text(
                                                        'Joined: ${widget.ppl}/${widget.maxPpl}'),
                                                    const Icon(Icons.whatshot,
                                                        color: Colors.red),
                                                  ])
                                            : Text(
                                                'Joined: ${widget.ppl}/${widget.maxPpl}'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
