import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Low Light',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  late final XFile? image;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  _changeScreenwithFile({XFile? file}) async {
    if (file == null) {
      Get.snackbar(
          "No Image Selected", "Please select or click a image to continue");
      return;
    }
    String? res = await Tflite.loadModel(
        model: "assets/model.tflite",
        labels: "assets/labels.txt",
        numThreads: 1, // defaults to 1
        isAsset:
            true, // defaults to true, set to false to load resources outside assets
        useGpuDelegate:
            true // defaults to false, set to true to use GPU delegate
        );
    debugPrint(res);
    var recognitions = await Tflite.runModelOnImage(
      path: file.path,
    );

    Get.snackbar("Image Results", "These are your results: $recognitions");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(),
                child: MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text("Gallery"),
                    onPressed: () async {
                      image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      _changeScreenwithFile(file: image);
                    }),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(),
                child: MaterialButton(
                    color: Colors.blue,
                    textColor: Colors.white,
                    child: const Text("Camera"),
                    onPressed: () async {
                      image =
                          await _picker.pickImage(source: ImageSource.camera);
                      _changeScreenwithFile(file: image);
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
