import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hi/assets/style/AppColors.dart';
import 'package:hi/mongoDB/db.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Uint8List? image;
  String? phone;
  int? age;
  int? creationDate;
  String? username;
  String? name;
  String? email;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    // Simula la obtención de datos de usuario desde una base de datos
    // Ejemplo de cómo obtener datos de SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLoggedIn') != null) {
      if (prefs.getBool('isLoggedIn')!) {
        Map<String, dynamic>? data =
            await MongoDataBase.userProfile(prefs.getString('email')!);
        if (data != null) {
          DateTime birthDate = DateTime.parse(data['birthdate']);
          Duration tiempo = DateTime.now().difference(birthDate);
          int ages = tiempo.inDays ~/ 365;
          DateTime now = DateTime.parse(data['now']);
          Duration tiempoDo = DateTime.now().difference(now);
          int antiquity = tiempoDo.inDays;
          setState(() {
            name = data['name'];
            username = data['userName'];
            age = ages;
            creationDate = antiquity;
            phone = data['phone'];
            if (data['image'] != null) {
              image = base64Decode(data['image']);
            }
          });
          if (kDebugMode) {
            print(
                "name = ${data['name']}; \n username = ${data['userName']}; \n age = $ages; \n creationDate = $antiquity; \n phone = ${data['phone']};");
          }
        } else {
          if (kDebugMode) print("data is null (_fetchUserProfile)");
        }
      } else if (prefs.getBool('isLoggedIn')! == false) {}
    }
    setState(() {
      email = prefs.getString('email') ?? 'usuario@ejemplo.com';
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const estilo = TextStyle(
      fontFamily: 'nuevo',
      color: AppColors.textSecondary,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pefil del usuario',
          style: estilo,
        ),
        leading: Padding(
          padding: const EdgeInsets.only(
              left: 20.0), // Ajusta el valor según necesites
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 192, 163, 0)
                              .withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 100,
                              width: 100,
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundColor: Colors.white,
                                  backgroundImage: image != null
                                      ? MemoryImage(image!)
                                      : null,
                                  child: image == null
                                      ? Center(
                                          child: Text(
                                            username?[0].toUpperCase() ?? 'O',
                                            style: const TextStyle(
                                              fontFamily: 'nuevo',
                                              fontSize: 40,
                                              color:
                                                  Color.fromARGB(255, 0, 0, 0),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Flexible(
                              child: Wrap(
                                spacing: 8.0, // gap between adjacent chips
                                runSpacing: 4.0, // gap between lines
                                direction: Axis
                                    .vertical, // main axis (rows or columns)
                                children: <Widget>[
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      'Username: $username',
                                      style: estilo,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      'Email: $email',
                                      style: estilo,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      'Nombre: $name',
                                      style: estilo,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      'Phone: $phone',
                                      style: estilo,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      'Age: $age esto contiene cosas su per pe que ñe as',
                                      style: estilo,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxWidth: 240),
                                    child: Text(
                                      'Antiquity: Tienes $creationDate dias de antiguedad',
                                      style: estilo,
                                      softWrap: true,
                                      overflow: TextOverflow.visible,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Simula una actualización de los datos del perfil
                          setState(() {
                            setState(() {
                              isLoading = true;
                            });
                            _fetchUserProfile();
                          });
                        },
                        child: const Text(
                          'Actualizar Información',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
