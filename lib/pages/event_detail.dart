import 'dart:convert';

import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  EventDetailsScreen({
    required this.event,
  });

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late StateSetter _setState;
  late TextEditingController _eventNameController;
  late TextEditingController _eventDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _locationController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  int? _selectedIndex;
  final uuid = const Uuid();
  final String _sessionToken = '1234567890';
  Map<String, dynamic> selectedPlace = {};
  List<dynamic> _placeList = [];
  Position? _currentPosition;
  
  final eventService = EventService();

  bool _isEditing = false; // Declare _isEditing here

  @override
  void initState() {
    super.initState();
    _eventNameController =
        TextEditingController(text: widget.event['eventName']);
    _eventDateController = TextEditingController(
        text: (widget.event['date'] != null
                ? (widget.event['date'] as Timestamp).toDate().toIso8601String()
                : 'No date')
            .substring(0, 10));
    _startTimeController =
        TextEditingController(text: widget.event['startTime']);
    _endTimeController = TextEditingController(text: widget.event['endTime']);
    _locationController =
        TextEditingController(text: widget.event['place']['placeName']);
    _locationController.addListener(_onChanged);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventDateController.dispose();
    _startTimeController.dispose();
    _endTimeController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  _onChanged() {
    getSuggestion(_locationController.text);
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

  void _updateEventDetails() async {
    final eventId = widget.event['eventId'];
    final updatedEvent = await eventService.getEventById(eventId);
    if (updatedEvent != null) {
      setState(() {
        widget.event['eventName'] = updatedEvent['eventName'];
        widget.event['date'] = updatedEvent['date'];
        widget.event['startTime'] = updatedEvent['startTime'];
        widget.event['endTime'] = updatedEvent['endTime'];
        widget.event['place'] = updatedEvent['place'];
        widget.event['participationList'] = updatedEvent['participationList'];
        widget.event['participants'] = updatedEvent['participants'];
        widget.event['mapHolderImgUrl'] = updatedEvent['mapHolderImgUrl'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final bool isOwner = user?.uid == widget.event['ownerId'];

    final eventId = widget.event['eventId'] ?? 'No id';
    final image = NetworkImage(widget.event['imageUrl']);
    final eventName = _eventNameController.text;
    final eventDate = _eventDateController.text;
    final startTime = _startTimeController.text;
    final endTime = _endTimeController.text;
    final location = widget.event['place']['placeName'] ?? 'No name';
    final List<dynamic> participantsList = widget.event['participationList'];
    final participants = widget.event['participationList'].length.toString();
    final maxParticipants =
        widget.event['participants'] ?? "No limit specified";

    final holderImage = widget.event['mapHolderImgUrl'];

    DateTime? _selectedDate;
    TimeOfDay? _selectedTime;

    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 10.0, right: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard(
                context,
                title: 'Event name',
                value: eventName,
                icon: isOwner ? Icons.edit : null,
                onEdit: () =>
                    _editField(context, 'Event name', _eventNameController),
              ),
              _buildDetailCard(
                context,
                title: 'Date',
                value: '$eventDate From $startTime to $endTime',
                icon: isOwner ? Icons.edit : null,
                onEdit: () => _editField(context, 'Date', _eventDateController,
                    startTimeController: _startTimeController,
                    endTimeController: _endTimeController),
              ),
              _buildDetailCard(
                context,
                title: 'Location',
                value: location,
                icon: isOwner ? Icons.edit : null,
                onEdit: () =>
                    _editField(context, 'Location', _locationController),
                child: Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: Colors.grey,
                  child: Center(
                    child: Image(
                      image: NetworkImage(holderImage),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 150,
                    ),
                  ),
                ),
              ),
              _buildDetailCard(
                context,
                title: 'Participants: $participants/$maxParticipants',
                value: '',
                icon: isOwner ? Icons.edit : null,
                onEdit: () {
                  setState(() {
                    _isEditing = !_isEditing;
                  });
                },
                child: FutureBuilder<List<Widget>>(
                  future: _buildParticipantsList(participantsList, authService),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error loading participants'));
                    } else {
                      return Column(children: snapshot.data ?? []);
                    }
                  },
                ),
              ),
              if (isOwner)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildActionButton(context, 'Cancel Event', Colors.grey),
                      _buildActionButton(context, 'Chat', Colors.blue),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeParticipant(String uid) async {
    try {
      String eventId = widget.event['eventId'];
      // Remove participant logic here
      await eventService.removeParticipant(eventId, uid);
      _updateEventDetails();
    } catch (e) {
      debugPrint("Failed to remove participant: $e");
    }
  }

  Future<List<Widget>> _buildParticipantsList(
    List<dynamic> participantsList, AuthService authService) async {
    List<Widget> participantsWidgets = [];

    for (var participant in participantsList) {
      String uid = participant.toString();
      UserModel? userDetails = await authService.fetchUserData(uid);
      String name = userDetails?.username ?? "Unknown";
      bool isHost = widget.event['ownerId'] == uid;
      String imageUrl = userDetails?.avatarURL ?? "";
      participantsWidgets.add(_buildParticipantRow(
        name,
        isHost,
        false,
        imageUrl,
        () => _removeParticipant(uid),
      ));
    }

    return participantsWidgets;
  }

  Widget _buildDetailCard(BuildContext context,
      {required String title,
      required String value,
      IconData? icon,
      Widget? child,
      void Function()? onEdit}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (icon != null)
                  IconButton(
                    icon: Icon(icon, size: 20),
                    onPressed: onEdit,
                  ),
              ],
            ),
            if (value.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(value, style: const TextStyle(fontSize: 16)),
            ],
            if (child != null) child,
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantRow(
    String name, bool isHost, bool isConfirmed, String imageUrl, Function() onRemove) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : const AssetImage('assets/images/avatar_placeholder.jpg')
                    as ImageProvider,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          if (isHost) ...[
            const Text('Host', style: TextStyle(color: Colors.green)),
          ],
          if (!isHost) ...[
            if (_isEditing) 
              IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () {
                  onRemove();
                },
              ),
            Checkbox(value: isConfirmed, onChanged: (value) {}),
            Icon(Icons.person, color: isConfirmed ? Colors.green : Colors.grey),
          ],
        ],
      ),
    );
  }


  Widget _buildActionButton(BuildContext context, String label, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  void _editField(
      BuildContext context, String title, TextEditingController controller,
      {TextEditingController? startTimeController,
      TextEditingController? endTimeController}) {
    if (title == 'Date') {
      _presentDatePicker().then((_) {
        if (_selectedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
          _presentTimePicker(context, 'Select Start Time', (TimeOfDay time) {
            _selectedStartTime = time;
            startTimeController?.text = _formatTimeOfDay(time);
            _presentTimePicker(context, 'Select End Time',
                (TimeOfDay time) async {
              _selectedEndTime = time;
              endTimeController?.text = _formatTimeOfDay(time);
              try {
                String eventId = widget.event['eventId'];
                Map<String, dynamic> updatedData = {
                  'date': DateTime.parse(_selectedDate.toString()),
                  'startTime': _selectedStartTime?.format(context),
                  'endTime': _selectedEndTime?.format(context),
                };
                debugPrint(updatedData.toString());
                await eventService.updateEvent(eventId, updatedData);
                _updateEventDetails();
              } catch (e) {
                debugPrint("Failed to update event: $e");
              }
            });
          });
        }
      });
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, StateSetter setState) {
              _setState = setState;
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Text('Edit $title',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),
                      TextField(
                        controller: title == 'Location'
                            ? _locationController
                            : controller,
                        decoration: InputDecoration(
                          labelText: title,
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.cancel),
                            iconSize: 16,
                            onPressed: () {
                              _locationController.clear();
                            },
                          ),
                        ),
                        onChanged: (value) {
                          _onChanged();
                        },
                      ),
                      if (title == 'Location') ...[
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: _placeList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                debugPrint(index.toString());
                                _handlePlaceSelection(index);
                              },
                              child: ListTile(
                                title: Text(_placeList[index]["description"]),
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          Map<String, dynamic> updatedData = {};
                          if (title == 'Event name') {
                            updatedData['eventName'] = controller.text;
                          } else if (title == 'Location') {
                            updatedData['place'] = selectedPlace;
                          }
                          String eventId = widget.event['eventId'];
                          try {
                            await eventService.updateEvent(
                                eventId, updatedData);
                            Navigator.pop(context);
                            _updateEventDetails();
                          } catch (e) {
                            debugPrint("Failed to update event: $e");
                          }
                        },
                        child: const Text('Save'),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
              );
            },
          );
        },
      );
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm();
    return format.format(dt);
  }

  Future<void> _presentTimePicker(BuildContext context, String title,
      void Function(TimeOfDay time) onTimePicked) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: title,
    );
    if (pickedTime != null) {
      setState(() {
        onTimePicked(pickedTime);
      });
    }
  }

  Future<void> _presentDatePicker() async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }
}
