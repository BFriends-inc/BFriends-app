import 'package:bfriends_app/model/user.dart';
import 'package:bfriends_app/services/auth_service.dart';
import 'package:bfriends_app/services/event_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> event;

  EventDetailsScreen({
    required this.event,
  });

  @override
  _EventDetailsScreenState createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late TextEditingController _eventNameController;
  late TextEditingController _eventDateController;
  late TextEditingController _startTimeController;
  late TextEditingController _endTimeController;
  late TextEditingController _locationController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedStartTime;
  TimeOfDay? _selectedEndTime;

  final eventService = EventService();

  @override
  void initState() {
    super.initState();
    _eventNameController = TextEditingController(text: widget.event['eventName']);
    _eventDateController = TextEditingController(text: (widget.event['date'] != null ? (widget.event['date'] as Timestamp).toDate().toIso8601String() : 'No date').substring(0, 10));
    _startTimeController = TextEditingController(text: widget.event['startTime']);
    _endTimeController = TextEditingController(text: widget.event['endTime']);
    _locationController = TextEditingController(text: widget.event['place']['placeName']);
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

  @override
  Widget build(BuildContext context) {
    final eventService = EventService();
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = FirebaseAuth.instance.currentUser;
    final bool isOwner = user?.uid == widget.event['ownerId'];

    final eventId = widget.event['eventId'] ?? 'No id';
    final image = NetworkImage(widget.event['imageUrl']);
    final eventName = _eventNameController.text;
    final eventDate = _eventDateController.text;
    final startTime = _startTimeController.text;
    final endTime = _endTimeController.text;
    final location = _locationController.text;
    final List<dynamic> participantsList = widget.event['participationList'];
    final participants = widget.event['participationList'].length.toString();
    final maxParticipants = widget.event['participants'] ?? "No limit specified";

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
                onEdit: () => _editField(context, 'Event name', _eventNameController),
              ),
              _buildDetailCard(
                context,
                title: 'Date',
                value: '$eventDate From $startTime to $endTime',
                icon: isOwner ? Icons.edit : null,
                onEdit: () => _editField(context, 'Date', _eventDateController, startTimeController: _startTimeController, endTimeController: _endTimeController),
              ),
              _buildDetailCard(
                context,
                title: 'Location',
                value: location,
                icon: isOwner ? Icons.edit : null,
                onEdit: () => _editField(context, 'Location', _locationController),
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
                child: FutureBuilder<List<Widget>>(
                  future: _buildParticipantsList(participantsList, authService),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Center(child: Text('Error loading participants'));
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

  Future<List<Widget>> _buildParticipantsList(List<dynamic> participantsList, AuthService authService) async {
    List<Widget> participantsWidgets = [];

    for (var participant in participantsList) {
      String uid = participant.toString();
      UserModel? userDetails = await authService.fetchUserData(uid);
      String name = userDetails?.username ?? "Unknown";
      bool isHost = widget.event['ownerId'] == uid;
      String imageUrl = userDetails?.avatarURL ?? "";
      participantsWidgets.add(_buildParticipantRow(name, isHost, false, imageUrl));
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

  Widget _buildParticipantRow(String name, bool isHost, bool isConfirmed, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: imageUrl.isNotEmpty
                ? NetworkImage(imageUrl)
                : const AssetImage('assets/images/avatar_placeholder.jpg') as ImageProvider,
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

  void _editField(BuildContext context, String title, TextEditingController controller, {TextEditingController? startTimeController, TextEditingController? endTimeController}) {
    if (title == 'Date') {
      _presentDatePicker().then((_) {
        if (_selectedDate != null) {
          controller.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
          _presentTimePicker(context, 'Select Start Time', (TimeOfDay time) {
            _selectedStartTime = time;
            startTimeController?.text = _formatTimeOfDay(time);
            _presentTimePicker(context, 'Select End Time', (TimeOfDay time) {
              _selectedEndTime = time;
              endTimeController?.text = _formatTimeOfDay(time);
              setState(() {});
            });
          });
        }
      });
    } else {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
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
                  Text('Edit $title', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: controller,
                    decoration: InputDecoration(labelText: title),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> updatedData = {};
                      if (title == 'Event name') {
                        updatedData['eventName'] = controller.text;
                      } else if (title == 'Location') {
                        updatedData['place'] = {'placeName': controller.text};                      }
                      String eventId = widget.event['eventId'];
                      try {
                        await eventService.updateEvent(eventId, updatedData);
                        Navigator.pop(context);
                        setState(() {});
                      } catch (e) {
                        debugPrint("Failed to update event: $e");
                      }
                    },
                    child: const Text('Save'),
                  ),
                  const SizedBox(height: 10), // Added padding below the Save button
                ],
              ),
            ),
          );
        },
      );
    }
  }

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat.jm(); // Change this format if you need to
    return format.format(dt);
  }

  Future<void> _presentTimePicker(BuildContext context, String title, void Function(TimeOfDay time) onTimePicked) async {
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
