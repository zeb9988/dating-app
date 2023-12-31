import 'package:flutter/material.dart';
import 'package:theklicks/models/user.dart';

class swipecard extends StatelessWidget {
  const swipecard({super.key, required this.users, required this.index});

  final List<Usermodel> users;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(
                  users[index].profileImageUrl.isEmpty
                      ? 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRKKOdmJz8Z2pDtYgFgR2u9spABvNNPKYYtGw&usqp=CAU'
                      : users[index].profileImageUrl,
                ),
                fit: BoxFit.cover,
                alignment: const Alignment(-0.3, 0)
                // width: double.infinity,
                // height: double.infinity,
                ),
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.7, 1]),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  Container(
                    width: 50,
                    decoration: BoxDecoration(
                        color: const Color(0xffE3FFE4),
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Active',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 87, 85, 78),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: [
                      Text(
                        users[index].username,
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      const Icon(
                        Icons.verified_sharp,
                        color: Colors.blue,
                      ),
                      const Spacer(),
                      Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              shape: BoxShape.circle),
                          child: const Icon(
                            Icons.arrow_upward_rounded,
                            color: Colors.white,
                            size: 30,
                          ))
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "❛❛ ${users[index].bio}",
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
