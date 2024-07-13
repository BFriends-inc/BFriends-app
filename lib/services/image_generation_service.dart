import 'dart:convert';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class ImageGenerationService {
  static final String _apiKey = '${dotenv.env['PIC_AIAPIKEY']}';
  static const String _url = 'https://api.edenai.run/v2/image/generation';

  Future<XFile?> generateImage(String prompt) async {
    debugPrint('Generating image with prompt: $prompt');
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'providers': "amazon",
          'text': prompt,
          'resolution': "512x512",
          "num_images": 1,
          'fallback_providers': "",
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        debugPrint(data.toString());
        var items = data['amazon']['items'];
        debugPrint(items.toString());
        String imageUrl = items[0]['image_resource_url'];
        debugPrint('Generated image: $imageUrl');
        return XFile(imageUrl);
      } else {
        debugPrint('Failed to generate image: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error generating image: $e');
      return null;
    }
  }
}
