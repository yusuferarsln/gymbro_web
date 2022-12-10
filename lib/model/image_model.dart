// ignore_for_file: public_member_api_docs, sort_constructors_first

class ImageModel {
  String? move_img;
  ImageModel({
    required this.move_img,
  });

  factory ImageModel.fromJson(Map<String, dynamic> map) {
    return ImageModel(
      move_img: map['move_img'] ??
          "https://hips.hearstapps.com/hmg-prod/images/mh0418-fit-pul-01-1558554157.jpg?crop=0.750xw:1.00xh;0.250xw,0&resize=1200:*",
    );
  }
}
