import 'package:image_picker/image_picker.dart';

class ImageUtils {
  Future getCameraImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    return image;
  }

  Future getGalleryImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    return image;
  }
}