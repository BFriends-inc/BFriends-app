import 'package:bfriends_app/pages/profile_setup_page.dart';
import 'package:flutter/material.dart';
import 'package:bfriends_app/pages/edit_profile_page.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:bfriends_app/services/auth_service.dart';

class StatsCard extends StatefulWidget {
  const StatsCard({
    super.key,
    required this.title,
    required this.count,
    this.rankColor = false,
  });
  final String title;
  final String count;
  final bool rankColor;

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  void _openCardOverlay(String info, String mode){
    showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      builder: (ctx) => (mode == 'show') ? ShowInfo(info: info) : EditInfo(info: info)
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        if(widget.title == 'My Preferred Languages'){
            _openCardOverlay('language', 'show');
        }
        else if(widget.title == 'My Interests') {_openCardOverlay('interest', 'show');}
        else if(widget.title == 'Edit My Interests') {_openCardOverlay('interest', 'edit');}
        else if(widget.title == 'Edit My Preferred Languages') {_openCardOverlay('language', 'edit');}
        debugPrint('card pressed');
      },
      child: Container(
        //ACTIVITY
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: theme.colorScheme.secondaryContainer,
          borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              widget.title,
              style: theme.textTheme.bodyMedium,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      widget.count,
                      style: theme.textTheme.bodySmall,
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: theme.textTheme.bodyMedium!.fontSize,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ShowInfo extends StatefulWidget{
  const ShowInfo({super.key, required this.info});

  final String info;

  @override
  State<ShowInfo> createState() => _ShowInfoState();
}

class _ShowInfoState extends State<ShowInfo>{
  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (widget.info == 'language') ? 'Your Preferred Languages:' : 'Your Interests',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: SizedBox(height: 200,
            child: ListView.builder(
              itemCount: (widget.info == 'language') ? user?.listLanguage?.length ?? 0 : user?.listInterest?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    (widget.info == 'language') ? user?.listLanguage![index].toString() ?? '' : user?.listInterest![index].toString() ?? '',
                    style: theme.textTheme.headlineLarge,
                  ),
                );
              }
            ),),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Done'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class EditInfo extends StatefulWidget{
  const EditInfo({super.key, required this.info});

  final String info;

  @override
  State<EditInfo> createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo>{

  @override
  Widget build(BuildContext context){
    final theme = Theme.of(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final user = authService.user;
    Map<String, String> userInfo = {
      'fullName': user?.username ?? '',
      'email': user?.email ?? '',
    };
    final ProfileSetupScreen pss = ProfileSetupScreen(userInfo: userInfo);
    //pss._selectedItems = user?.listLanguage;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            (widget.info == 'language') ? 'Your Preferred Languages:' : 'Your Interests',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20,),
          Expanded(
            child: SizedBox(height: 200,
            child: ListView.builder(
              itemCount: (widget.info == 'language') ? user?.listLanguage?.length ?? 0 : user?.listInterest?.length ?? 0,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    (widget.info == 'language') ? user?.listLanguage![index].toString() ?? '' : user?.listInterest![index].toString() ?? '',
                    style: theme.textTheme.headlineLarge,
                  ),
                );
              }
            ),),
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Done'),
              ),
            ),
          )
        ],
      ),
    );
  }
}