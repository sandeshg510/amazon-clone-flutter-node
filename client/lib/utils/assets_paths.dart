/*
* In this file we keep all the paths to the required assets of amazon_clone
* ImagePaths contains all the paths to the necessary images
* SvgPaths contains all the paths to the necessary svgs
* VideoPaths contains all the paths to the necessary videos
*/

const String _images = "assets/images"; // * Path to the images folder
const String _svgs = "assets/svgs"; // * Path to the svgs folder
// const String _videos = "assets/videos"; // * Path to the videos folder
const String _anims = "assets/anims"; // * Path to the animations folder

class ImagePaths {
  static ImagePaths instance =
      ImagePaths(); // * A singleton instance of the class to be used all over the project codebase

  final String brandNameLogoPath = "$_images/amazon_in.png";
  final String cartLogoPath = "$_images/cart.jpg";
  final String sponsoredImagePath = "$_images/titan.jpg";
  final String flagPath = "$_images/flag.png";
  final String deliveryPath = "$_images/delivery_card.jpg";
  final String kellogsAdPath = "$_images/kellogs_ad.jpg";
  final String cameraLogoPath = "$_images/camera_logo.jpg";
  final String ragaAdPath = "$_images/raga.jpg";
  final String fashionAdPath = "$_images/fashion_sponsored.jpg";
  final String mobilesAdPath = "$_images/realme_sponsored.jpg";
}

class SvgPaths {
  static SvgPaths instance = SvgPaths();
}

class VideoPaths {
  static VideoPaths instance = VideoPaths();
}

class AnimPaths {
  static AnimPaths instance = AnimPaths();
}
