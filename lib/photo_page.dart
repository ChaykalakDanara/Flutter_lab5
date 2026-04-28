import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum PhotoType { dog, landscapes}

class PhotoPage extends StatefulWidget{
  const PhotoPage({super.key});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}
class _PhotoPageState extends State<PhotoPage> {
  String? _imageUrl;
  bool _isLoading = false;
  String? _errorMessage;
  PhotoType _animalType = PhotoType.dog;

  Future<void> _fetchPhoto() async {
    setState((){
      _isLoading = true;
      _errorMessage = null;
      _imageUrl = null;
    });
    try {
      String url;
      http.Response response;

      if (_animalType == PhotoType.dog){
        url = 'https://dog.ceo/breeds/image/random';
        response = await http.get(Uri.parse(url));
        Map<String, dynamic> data = jsonDecode(
          response.body,
        );
        _imageUrl = data['message'];
      } else {
        final random = DateTime.now().millisecondsSinceEpoch;
        _imageUrl = 'http://picsum.photos/seed/$random/800/800';
      }
    } catch (e) {
      _errorMessage = 'Не удалось загрузить фото. \nПроверьте подключение к интернету';
    }
    setState((){
      _isLoading = false;
    });
  }

  @overrige 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фото дня'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildAnimalToggle(),
          const SizedBox(height: 20),
          _buildContent(),
          const SizedBox(height: 20),
          _buildButton(),
          const SizedBox(height: 20),
        ],
      )
    );
  }
}