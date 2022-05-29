import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myz_el_fali_version_1_1/varaible/varaible.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'dart:io';
import 'package:myz_el_fali_version_1_1/desing/context_extension.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: buildBottomNavigationBar,
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: buildBackGround(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: context.dynamicHeight(0.5),
              horizontal: context.dynamicWidth(0.1)),
          child: Column(
            children: [
              Expanded(child: Text(namemail)),
              Expanded(
                flex: 3,
                child: buildListTile(),
              ),
              const Expanded(
                flex: 1,
                child: Text(""),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _upload(String inputSource) async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: inputSource == 'camera'
              ? ImageSource.camera
              : ImageSource.gallery,
          maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        // Uploading the selected image with some custom meta data
        await storage.ref(fileName).putFile(
            imageFile,
            SettableMetadata(customMetadata: {
              'uploaded_by': 'Kötü bir adam',
              'description': 'Açıklamacıklar...',
              "kisi": namemail
            }));

        // Refresh the UI
        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  Future<void> _delete(String ref) async {
    await storage.ref(ref).delete();
    // Rebuild the UI
    setState(() {});
  }

  Future<List<Map<String, dynamic>>> _loadImages() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    // final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;
    // final List<Reference> allFiles = result.items;
    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      if (fileMeta.customMetadata?['kisi'] == namemail) {
        files.add({
          "url": fileUrl,
          "path": file.fullPath,
          "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
          "description":
              fileMeta.customMetadata?['description'] ?? 'No description',
          "kisi": fileMeta.customMetadata?['kisi'] ?? 'none'
        });
      }
    });

    return files;
  }

  BoxDecoration buildBackGround() {
    return const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('image/lgscreen.png'),
        fit: BoxFit.cover,
      ),
    );
  }

  var borderRadius = const BorderRadius.only(
      topRight: Radius.circular(32),
      bottomRight: Radius.circular(32),
      topLeft: Radius.circular(32),
      bottomLeft: Radius.circular(32));
  FutureBuilder<List<Map<String, dynamic>>> buildListTile() {
    return FutureBuilder(
      future: _loadImages(),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              final Map<String, dynamic> image = snapshot.data![index];

              return Card(
                color: Colors.transparent,
                shadowColor: Colors.transparent,
                //margin: const EdgeInsets.symmetric(vertical: 5),
                child: GridView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                  ),
                  children: [
                    GestureDetector(
                      child: Image.network(image['url']),
                      onTap: () {
                        Alert(
                                context: context,
                                title: "Anasayfa",
                                desc: image['kisi'].toString())
                            .show();
                      },
                    )
                  ],
                ),
                // ListTile(
                //   dense: false,
                //   leading: Image.network(
                //     image['url'],
                //     height: 100,
                //   ),
                //   title: Text(image['uploaded_by']),
                //   subtitle: Text(image['description'] + ' \n' + image['kisi']),
                //   trailing: IconButton(
                //     onPressed: () => _delete(image['path']),
                //     icon: const Icon(
                //       Icons.delete,
                //       color: Color.fromRGBO(227, 179, 76, 1),
                //     ),
                //   ),
                // ),
              );
            },
          );
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  int index = 1;
  BottomNavigationBar get buildBottomNavigationBar {
    return BottomNavigationBar(
      backgroundColor: const Color.fromARGB(255, 37, 52, 57),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.camera),
          label: 'Kamera',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
        BottomNavigationBarItem(icon: Icon(Icons.photo), label: 'Galeri'),
      ],
      currentIndex: index,
      onTap: (int i) {
        setState(() {
          index = i;
          if (index == 0) {
            _upload('camera');
          } else if (index == 1) {
            Alert(
                    context: context,
                    title: "Anasayfa",
                    desc: "Bu sayfa daha yapılmadı")
                .show();
          } else if (index == 2) {
            _upload('gallery');
          }
        });
      },
      fixedColor: const Color.fromRGBO(227, 179, 76, 1),
      type: BottomNavigationBarType.fixed,
      iconSize: 30,
    );
  }
}
