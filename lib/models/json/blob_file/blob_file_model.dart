class BlobFileModel {
  final String id;
  final String url;
  final String fileName;
  final int fileSize;
  final String mediaType;

  BlobFileModel({
    required this.id,
    required this.url,
    required this.fileName,
    required this.fileSize,
    required this.mediaType,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'fileName': fileName,
      'fileSize': fileSize,
      'mediaType': mediaType,
    };
  }

  factory BlobFileModel.fromJson(Map<String, dynamic> map) {
    return BlobFileModel(
      id: map['id'] ?? '',
      url: map['url'] ?? '',
      fileName: map['fileName'] ?? '',
      fileSize: map['fileSize'] ?? 0,
      mediaType: map['mediaType'] ?? '',
    );
  }
}
