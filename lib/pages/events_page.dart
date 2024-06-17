import 'dart:convert';
import 'dart:math';

import 'package:bfriends_app/pages/user_image_picker.dart';
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

  @override
  void initState() {
    super.initState();
    _locationSearchController.addListener(_onChanged);
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationSearchController.removeListener(_onChanged);
    _locationSearchController.dispose();
    _pageController.dispose();
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
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }

      _currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
      String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
      String location = '${_currentPosition!.latitude},${_currentPosition!.longitude}';
      int radius = 50000; // 50 km
      String request = '$baseURL?input=$input&key=$placesApiKey&sessiontoken=$_sessionToken&location=$location&radius=$radius';
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
      String baseURL = 'https://maps.googleapis.com/maps/api/place/details/json';
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
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _pageController,
                    onPageChanged: (index) {
                      _setState(() {
                      });
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
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: eventNameController,
            onChanged: (value) {},
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your username';
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
                return 'Please enter number of participants';
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
            controller: TextEditingController(text: _selectedDate == null
                ? 'Event Date'
                : '${_selectedDate!.day.toString().padLeft(2, '0')}/${_selectedDate!.month.toString().padLeft(2, '0')}/${_selectedDate!.year}'),
            style: TextStyle(
              fontSize: 14,
              color: _isDateValid.value ? Colors.black : const Color.fromARGB(255, 195, 65, 63),
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
              if (value == null || value == 'Event Date') {
                _setState(() {
                  _isDateValid.value = false;
                });
                return 'Please select the event date';
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
                    const SnackBar(content: Text('Please enter the event name')),
                  );
                } else if (_selectedImage == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select an image')),
                  );
                } else if (participantsController.text.isEmpty || int.tryParse(participantsController.text) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid number of participants')),
                  );
                } else if (_selectedDate == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select the event date')),
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
              return GestureDetector(
                onTap: () => _handlePlaceSelection(index),
                child: ListTile(
                  title: Text(_placeList[index]["description"]),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
             if (_formProfileSetupKey.currentState!.validate()) {
              _formProfileSetupKey.currentState!.save();
              var eventName = eventNameController.text;
              var participants = participantsController.text;

              if (eventName.isEmpty || _selectedImage == null || participants.isEmpty || _selectedDate == null) {
                return;
              }

              var eventId = const Uuid().v4();
              var random = Random();
              var id = random.nextInt(90000) + 10000;
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  void _submitForm() {
    if (_formProfileSetupKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select the event date')),
        );
      } else {
        _setState(() {
          _selectedDate = null;
        });
        debugPrint('Form submitted');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
      ),
    );
  }
}
