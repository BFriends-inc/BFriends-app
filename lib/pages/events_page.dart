import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bfriends_app/pages/event_card.dart';
import 'package:bfriends_app/pages/event_image_picker.dart';
import 'package:bfriends_app/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:geolocator/geolocator.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key});

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _formProfileSetupKey = GlobalKey<FormState>();
  late StateSetter _setState;

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  int? _selectedIndex;
  final _locationSearchController = TextEditingController();
  final uuid = const Uuid();
  final String _sessionToken = '1234567890';
  Map<String, dynamic> selectedPlace = {};
  List<dynamic> _placeList = [];

  final PageController _pageController = PageController(initialPage: 0);
  Position? _currentPosition;

  TextEditingController eventNameController = TextEditingController();
  TextEditingController participantsController = TextEditingController();

  XFile? _selectedImage;

  final _isDateValid = ValueNotifier<bool>(true);

  final User? user = FirebaseAuth.instance.currentUser;
  final eventService = EventService();

  List<Map<String, dynamic>> _events = [];

  StreamSubscription? _eventsSubscription;

  @override
  void setState(VoidCallback fn) {
    if (!mounted) return;
    super.setState(fn);
  }

  void _listenToEvents() {
    _eventsSubscription =
        FirebaseFirestore.instance.collection('events').snapshots().listen(
      (snapshot) {
        setState(() {
          _events = snapshot.docs.map((doc) => doc.data()).toList();
        });
      },
      onError: (error) => debugPrint("Listen failed: $error"),
    );
  }

  @override
  void initState() {
    super.initState();
    _locationSearchController.addListener(_onChanged);
    _getCurrentLocation();
    _loadEvents();
    _listenToEvents();
  }

  @override
  void dispose() {
    _locationSearchController.removeListener(_onChanged);
    _locationSearchController.dispose();
    _pageController.dispose();
    _isDateValid.dispose();
    _eventsSubscription?.cancel();
    super.dispose();
  }

  _onChanged() {
    getSuggestion(_locationSearchController.text);
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled;
      LocationPermission permission;

      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      _currentPosition = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void getSuggestion(String input) async {
    const String placesApiKey = "AIzaSyAWWVJHrSvqKnNomA76ZsjhYM0Bwe0uz80";

    if (_currentPosition == null) {
      await _getCurrentLocation();
    }

    if (_currentPosition == null) {
      debugPrint('Could not get current location');
      return;
    }

    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String location =
          '${_currentPosition!.latitude},${_currentPosition!.longitude}';
      int radius = 50000; // 50 km
      String request =
          '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$_sessionToken&location=$location&radius=$radius';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        _setState(() {
          _placeList = json.decode(response.body)['predictions'];
        });
      } else {
        throw Exception('Failed to load predictions');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getPlaceDetails(String placeId) async {
    const String placesApiKey = "AIzaSyAWWVJHrSvqKnNomA76ZsjhYM0Bwe0uz80";
    try {
      String baseURL =
          'https://maps.googleapis.com/maps/api/place/details/json';
      String request = '$baseURL?place_id=$placeId&key=$placesApiKey';
      var response = await http.get(Uri.parse(request));
      if (response.statusCode == 200) {
        return json.decode(response.body)['result'];
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> _handlePlaceSelection(int index) async {
    _setState(() {
      _selectedIndex = index;
    });

    var selectedSuggestionPlace = _placeList[index];
    debugPrint(selectedSuggestionPlace.toString());
    String placeId = selectedSuggestionPlace["place_id"];
    debugPrint('Selected place: ${selectedSuggestionPlace["description"]}');

    var placeDetails = await getPlaceDetails(placeId);
    if (placeDetails != null) {
      double latitude = placeDetails["geometry"]["location"]["lat"];
      double longitude = placeDetails["geometry"]["location"]["lng"];
      debugPrint('Latitude: $latitude, Longitude: $longitude');

      Map<String, dynamic> place = {
        'placeId': placeId,
        'placeName': selectedSuggestionPlace["description"],
        'placeAddress': placeDetails["formatted_address"],
        'latitude': latitude,
        'longitude': longitude,
      };
      selectedPlace = place;
    }
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null) {
      _setState(() {
        _selectedDate = pickedDate;
        _presentTimePicker(context, 'Start Time', (pickedTime) {
          _selectedStartTime = pickedTime;
          _presentTimePicker(context, 'End Time', (pickedTime) {
            _selectedEndTime = pickedTime;
          });
        });
      });
    }
  }

  void _presentTimePicker(BuildContext context, String title,
      void Function(TimeOfDay time) onTimePicked) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: title,
    );
    if (pickedTime != null) {
      _setState(() {
        onTimePicked(pickedTime);
      });
    }
  }

  void _showDialog() {
    var height = MediaQuery.of(context).size.height;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            _setState = setState;
            return Dialog(
              child: Form(
                key: _formProfileSetupKey,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  height: height - 200,
                  width: double.infinity,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      _setState(() {});
                    },
                    children: [
                      _buildFirstPage(),
                      _buildSecondPage(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    setState(() {
      _selectedDate = null;
      _locationSearchController.clear();
      eventNameController.clear();
      participantsController.clear();
      _placeList = [];
      _isDateValid.value = true;
      _selectedStartTime = null;
      _selectedEndTime = null;
    });
  }

  Widget _buildFirstPage() {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'New Event',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          UserImagePicker(
            context: context,
            validator: (pickedImage) {
              if (pickedImage == null) {
                return 'Please select an image';
              }
              return null;
            },
            onSave: (pickedImage) {
              _selectedImage = pickedImage;
            },
            eventNameController: eventNameController,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: eventNameController,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the event name';
              }
              return null;
            },
            decoration: InputDecoration(
              label: const Text(
                'Event Name',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              hintText: 'Input Event Name',
              hintStyle: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onTertiaryContainer,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiaryContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiaryContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: participantsController,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter the number of participants';
              }
              return null;
            },
            decoration: InputDecoration(
              label: const Text(
                'Number of Participants Needed',
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              hintText: 'Put number of participants',
              hintStyle: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onTertiaryContainer,
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiaryContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiaryContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            readOnly: true,
            controller: TextEditingController(
                text: _selectedDate == null
                    ? 'Event Date and Time'
                    : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}   ${_selectedStartTime?.format(context) ?? ''} - ${_selectedEndTime?.format(context) ?? ''}'),
            style: TextStyle(
              fontSize: 14,
              color: _isDateValid.value
                  ? Colors.black
                  : const Color.fromARGB(255, 195, 65, 63),
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                onPressed: _presentDatePicker,
                icon: Icon(
                  Icons.calendar_today,
                  color: theme.colorScheme.tertiary,
                ),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiaryContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: theme.colorScheme.tertiaryContainer,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onTap: _presentDatePicker,
            validator: (value) {
              if (value == null ||
                  value == 'Event Date and Time' ||
                  _selectedStartTime == null ||
                  _selectedEndTime == null) {
                _setState(() {
                  _isDateValid.value = false;
                });
                return 'Please select the event date and time';
              }
              _setState(() {
                _isDateValid.value = true;
              });
              return null;
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              if (_formProfileSetupKey.currentState!.validate()) {
                _formProfileSetupKey.currentState!.save();
                if (eventNameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter the event name')),
                  );
                } else if (_selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select an image')),
                  );
                } else if (participantsController.text.isEmpty ||
                    int.tryParse(participantsController.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text(
                            'Please enter a valid number of participants')),
                  );
                } else if (_selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select the event date')),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildSecondPage() {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'New Event',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _locationSearchController,
          onChanged: (value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your event location';
            }
            return null;
          },
          decoration: InputDecoration(
            label: const Text(
              'Location',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            hintText: 'Pick your event location',
            hintStyle: TextStyle(
              color: theme.colorScheme.onTertiaryContainer,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.tertiaryContainer,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.tertiaryContainer,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            //prefixIcon: const Icon(Icons.map, size: 24),
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel),
              iconSize: 16,
              onPressed: () {
                _locationSearchController.clear();
              },
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _placeList.length,
            itemBuilder: (context, index) {
              bool isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => _handlePlaceSelection(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  child: ListTile(
                    title: Text(
                      _placeList[index]["description"],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formProfileSetupKey.currentState?.validate() == true &&
        _selectedDate != null) {
      _formProfileSetupKey.currentState?.save();

      final eventName = eventNameController.text;
      final participants = participantsController.text;
      final eventDate =
          _selectedDate!.toLocal().toIso8601String().substring(0, 10);
      final eventStartTime = _selectedStartTime!.format(context);
      final eventEndTime = _selectedEndTime!.format(context);
      final placeName = selectedPlace['placeName'] ?? 'No place selected';
      final placeAddress =
          selectedPlace['placeAddress'] ?? 'No address available';
      final latitude = selectedPlace['latitude'] ?? 0.0;
      final longitude = selectedPlace['longitude'] ?? 0.0;
      final ownerId = user?.uid ?? '';

      debugPrint('Event Name: $eventName');
      debugPrint('Participants: $participants');
      debugPrint('Event Date: $eventDate');
      debugPrint('Event Start Time: $eventStartTime');
      debugPrint('Event End Time: $eventEndTime');
      debugPrint('Place Name: $placeName');
      debugPrint('Place Address: $placeAddress');
      debugPrint('Latitude: $latitude');
      debugPrint('Longitude: $longitude');

      try {
        await eventService.createEvent(
          ownerId: ownerId,
          eventName: eventName,
          participants: participants,
          selectedImage: _selectedImage!,
          eventDate: eventDate,
          eventStartTime: eventStartTime,
          eventEndTime: eventEndTime,
          placeName: placeName,
          placeAddress: placeAddress,
          latitude: latitude,
          longitude: longitude,
        );

        Navigator.of(context).pop();
      } catch (e) {
        debugPrint('Error creating event: $e');
      }
    } else {
      debugPrint('Please fill all the fields');
    }
  }

  Future<void> _loadEvents() async {
    try {
      List<Map<String, dynamic>> events = await eventService.getEvents();
        setState(() {
          _events = events;
      });
    } catch (e) {
      debugPrint('Error loading events: $e');
    }
  }

  Widget MyEventsPage() {
    return _events.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              if (event['ownerId'] != user?.uid &&
                  !event['participationList'].keys.contains(user?.uid)) {
                return const SizedBox.shrink();
              }
              return EventCard(
                event: event,
                currUser: user,
                userId: user?.uid ?? "No user id",
                isFull: event['participationList'].length >=
                    int.parse(event['participants']),
                isHosted: event['ownerId'] == user?.uid,
                isJoined: event['participationList'].keys.contains(user?.uid),
              );
            },
          );
  }

  Widget AllEventsPage() {
    return _events.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return EventCard(
                event: event,
                currUser: user,
                userId: user?.uid ?? "No user id",
                isFull: event['participationList'].length >=
                    int.parse(event['participants']),
                isHosted: event['ownerId'] == user?.uid,
                isJoined: event['participationList'].keys.contains(user?.uid),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.primary,
          title: Text(
            'BFriends',
            style: TextStyle(
              fontSize: theme.primaryTextTheme.headlineMedium?.fontSize,
              fontWeight: theme.primaryTextTheme.headlineMedium?.fontWeight,
              color: theme.colorScheme.onPrimary,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.add,
                color: theme.colorScheme.onPrimary,
                semanticLabel: 'Add a New Event',
              ),
              onPressed: _showDialog,
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(
                child: Text(
                  'My Events',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              Tab(
                child: Text(
                  'All Events',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyEventsPage(),
            AllEventsPage(),
          ],
        ),
      ),
    );
  }
}
