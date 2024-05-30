// ignore_for_file: file_names

import 'package:image_picker/image_picker.dart'
    show ImagePicker, ImageSource, XFile;

Future<XFile?> getImage() async {
  final ImagePicker picker = ImagePicker();

  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  return image;
}
