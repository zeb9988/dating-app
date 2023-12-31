import 'package:flutter/material.dart';
import 'package:theklicks/my_list_title.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final String appVersion;

  const MyDrawer({
    Key? key,
    required this.onProfileTap,
    required this.onSignOut,
    required this.appVersion,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        width: MediaQuery.of(context).size.width,
        color: Colors.grey[100], // Light grey background, similar to sign-in screen
        child: Column(
          children: [
            Container(
              height: 200,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color.fromARGB(255, 0, 0, 0), // Button color
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'John Doe',
                    style: TextStyle(
                      color: Colors.black, // Text color matching the sign-in screen
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MyListTile(
                icon: Icons.home,
                text: 'Home',
                onTap: () {
                  Navigator.pop(context);
                  // Add navigation to the home page
                },
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MyListTile(
                icon: Icons.person,
                text: 'Profile',
                onTap: onProfileTap,
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MyListTile(
                icon: Icons.privacy_tip,
                text: 'Privacy Policy',
                onTap: () {
                  // Implement Privacy Policy navigation here
                },
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MyListTile(
                icon: Icons.info_outline,
                text: 'Version $appVersion', // Display the app version here
                onTap: () {
                  // Implement App Version details display here
                },
              ),
            ),
            const Divider(),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.white,
              ),
              child: MyListTile(
                icon: Icons.logout,
                text: 'Logout',
                onTap: onSignOut,
              ),
            ),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Version 1.0.0'),
            ),
          ],
        ),
      ),
    );
  }
}
