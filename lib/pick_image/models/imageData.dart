class ImageData {
  ImageData({
    required this.idCam,
    required this.address,
    required this.imageUrl,
    required this.nameOfPersonImage,
  });
  final String nameOfPersonImage;
  final String idCam;
  final String imageUrl;
  final String address;
}

class ImageDetailLocation {
  const ImageDetailLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  final double latitude;
  final double longitude;
  final String address;
}
