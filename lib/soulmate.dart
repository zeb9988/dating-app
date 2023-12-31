import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:theklicks/home_page.dart';
import 'package:theklicks/likeuser.dart';
import 'package:theklicks/models/user.dart';
import 'package:theklicks/widget/essentials.dart';
import 'package:theklicks/widget/intrest.dart';
import 'package:theklicks/widget/swipecard.dart';

class SoulmatePage extends StatefulWidget {
  final List<String> postLikes;

  const SoulmatePage({Key? key, required this.postLikes}) : super(key: key);

  @override
  State<SoulmatePage> createState() => _SoulmatePageState();
}

class _SoulmatePageState extends State<SoulmatePage>
    with TickerProviderStateMixin {
  List<Usermodel> users = [];
  int currentIndex = 0;
  late PageController _pageController;
  double swipeValue = 0.0;

  late AnimationController _homeIconAnimationController;
  late Animation<double> _homeIconOpacity;
  late Animation<Offset> _homeIconPosition;

  // Use a single TickerProviderStateMixin for both controllers
  late AnimationController _iconAnimationController;
  late Animation<double> _heartIconScale;
  late AnimationController _clearAnimationController;
  late Animation<double> _clearIconScale;
  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      initialPage: 0,
      viewportFraction:
          1.0, // Set viewportFraction to 1.0 to cover the whole page
      keepPage: true,
    );

    _homeIconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _homeIconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _homeIconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _homeIconPosition =
        Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _homeIconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Use the same vsync for both controllers
    _iconAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heartIconScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _clearAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _clearIconScale = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(
        parent: _clearAnimationController,
        curve: Curves.easeInOut,
      ),
    );
    _pageController.addListener(_onPageChanged);

    _fetchUsers();
  }

  void _onPageChanged() {
    if (currentIndex >= users.length - 1) {
      _homeIconAnimationController.forward();
      // Check if there are more users, and reset the index if needed
      if (users.isNotEmpty) {
        setState(() {
          currentIndex = 0;
        });
      } else {
        // Show the home icon when all users are gone
        // You can customize this part based on your requirement
        print('All users are gone. Show home icon or perform another action.');
      }
    } else {
      _homeIconAnimationController.reverse();
    }
  }

  void _resetIconAnimation() {
    _iconAnimationController.reset();
    _clearAnimationController.reset();
  }

  Future<List<Usermodel>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users1').get();

      List<Usermodel> users = querySnapshot.docs.map((doc) {
        return Usermodel.fromSnap(doc);
      }).toList();

      // Filter out users who have been liked
      users = users
          .where((user) => !widget.postLikes.contains(user.email))
          .toList();

      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  Future<void> _fetchUsers() async {
    final userList = await getAllUsers();
    setState(() {
      users = userList;
    });
  }

  void _handleSwipe(bool isLiked) async {
    if (currentIndex >= users.length) {
      print('Invalid index. No users available.');
      return;
    }

    final likedUserEmail = users[currentIndex].email;
    print('Liked user Email: $likedUserEmail');

    if (likedUserEmail != null && likedUserEmail.isNotEmpty) {
      // Update liked status in Firestore based on email
      print('Updating liked status in Firestore based on email...');

      try {
        await FirebaseFirestore.instance
            .collection('users1')
            .doc(currentUser?.uid)
            .update({
          'likedPeople': FieldValue.arrayUnion([likedUserEmail]),
        });

        // Add the current user's email to the liked user's "likedBy" array
        await FirebaseFirestore.instance
            .collection('users1')
            .where('email', isEqualTo: likedUserEmail)
            .get()
            .then((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            var likedUserId = querySnapshot.docs.first.id;
            FirebaseFirestore.instance
                .collection('users1')
                .doc(likedUserId)
                .update({
              'likedBy': FieldValue.arrayUnion([currentUser?.email]),
            });
          }
        });
        print('Firestore update based on email successful.');
      } catch (e) {
        print('Error updating Firestore: $e');
      }
    } else {
      print('Liked user email is null or empty.');
    }

    setState(() {
      currentIndex++;
      swipeValue = 0.0;
    });

    // Check if there is a next page before attempting to swipe
    if (currentIndex < users.length) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.linear,
      );
    } else {
      print('No next page available.');
      // If the user is on the last card, reset to the first card
      setState(() {
        currentIndex = 0;
      });
    }

    _resetIconAnimation(); // Reset the heart icon animation
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Soulmates',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF333333), // Dark gray
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '💞 Soulmates',
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      onPressed: () {
                        // Navigate to the Soulmates Page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LikedMe()),
                        );
                      },
                      icon: const Icon(
                        Icons.favorite_rounded,
                        color: Colors.pink,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),

              if (users.isNotEmpty && currentIndex < users.length)
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: users.length,
                        onPageChanged: (index) {
                          setState(() {
                            currentIndex = index;
                            swipeValue = 0.0;
                          });
                        },
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onPanUpdate: (details) {
                              if (details.delta.dx < 0) {
                                setState(() {
                                  swipeValue = details.primaryDelta != null
                                      ? details.primaryDelta! / 200
                                      : 0.0;
                                });
                              } else if (details.delta.dx > 0) {
                                setState(() {
                                  swipeValue = details.primaryDelta != null
                                      ? details.primaryDelta! / 200
                                      : 0.0;
                                });
                              }
                            },
                            onPanEnd: (_) {
                              if (swipeValue < -0.5) {
                                _handleSwipe(false);
                              } else if (swipeValue > 0.5) {
                                _handleSwipe(true);
                              } else {
                                setState(() {
                                  swipeValue = 0.0;
                                });
                              }
                            },
                            child: Transform(
                              transform: Matrix4.translationValues(
                                  swipeValue * 400, 0, 0),
                              child: swipecard(users: users, index: index),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'About Me:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            RichText(
                              text: const TextSpan(
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                                children: [
                                  TextSpan(text: 'I am a passionate '),
                                  WidgetSpan(
                                    child: Icon(Icons.code,
                                        size: 18, color: Colors.blue),
                                  ),
                                  TextSpan(
                                      text:
                                          ' Flutter developer with a love for creating amazing mobile applications.'),
                                  TextSpan(text: ' My expertise includes '),
                                  WidgetSpan(
                                    child: Icon(Icons.design_services,
                                        size: 18, color: Colors.blue),
                                  ),
                                  TextSpan(text: ' UI/UX design, '),
                                  WidgetSpan(
                                    child: Icon(Icons.code,
                                        size: 18, color: Colors.blue),
                                  ),
                                  TextSpan(
                                      text:
                                          ' mobile development, and a deep appreciation for clean code.'),
                                  TextSpan(text: ' In my free time, I enjoy '),
                                  WidgetSpan(
                                    child: Icon(Icons.book,
                                        size: 18, color: Colors.blue),
                                  ),
                                  TextSpan(text: ' reading, '),
                                  WidgetSpan(
                                    child: Icon(Icons.code,
                                        size: 18, color: Colors.blue),
                                  ),
                                  TextSpan(
                                      text:
                                          ' coding, and exploring new technologies.'),
                                ],
                              ),
                            ),
                            const Divider(
                              color: Colors.black38,
                            ),
                            const Text(
                              'Interests:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: [
                                InterestChip('Flutter', Icons.code),
                                InterestChip(
                                    'Mobile Development', Icons.phone_android),
                                InterestChip(
                                    'UI/UX Design', Icons.design_services),
                                InterestChip('Coffee', Icons.local_cafe),
                                InterestChip('Reading', Icons.book),
                                InterestChip('Traveling', Icons.flight),
                              ],
                            ),
                            const Divider(
                              color: Colors.black38,
                            ),
                            const Text(
                              'Essentials:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            EssentialItem('Education',
                                'Started School at ABC University'),
                            EssentialItem('Body Height', '5\'10"'),
                            EssentialItem('Hometown', 'Cityville, USA'),
                            EssentialItem('Relationship Status', 'Single'),
                          ],
                        ),
                      ),
                    )
                  ],
                )
              else
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No more soulmates available.',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    AnimatedBuilder(
                      animation: _homeIconAnimationController,
                      builder: (context, child) {
                        return Opacity(
                          opacity: _homeIconOpacity.value,
                          child: SlideTransition(
                            position: _homeIconPosition,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.home_rounded,
                                        size: 60, color: Colors.black),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()));
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              // const SizedBox(
              //   height: 10,
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    primary: Colors.white,
                    shape: const CircleBorder(),
                    minimumSize: const Size.square(60),
                    maximumSize: const Size.square(80)),
                onPressed: () {
                  _handleSwipe(false);
                  _clearAnimationController.forward(from: 0.0);
                },
                child: ScaleTransition(
                  scale: _clearIconScale,
                  child: const Icon(
                    Icons.clear,
                    color: Colors.red,
                    size: 40,
                  ),
                )),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    primary: Colors.white,
                    shape: const CircleBorder(),
                    minimumSize: const Size.square(60),
                    maximumSize: const Size.square(80)),
                onPressed: () {},
                child: const Icon(
                  Icons.star,
                  color: Colors.blue,
                  size: 40,
                )),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 8,
                primary: Colors.white,
                shape: const CircleBorder(),
                minimumSize: const Size.square(60),
                maximumSize: const Size.square(80),
              ),
              onPressed: () {
                _iconAnimationController.forward();

                _handleSwipe(true);
              },
              child: ScaleTransition(
                scale: _heartIconScale, // Use the heart icon scale animation
                child: const Icon(
                  Icons.favorite,
                  color: Colors.teal,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _homeIconAnimationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }
}
