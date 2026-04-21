class Content {
  final int id;
  final String title;
  final String description;
  final String contentType;
  final String status;
  final String? imageFile;
  final String? videoFile;
  final String? audioFile;
  final String? fileUrl;
  final String tags;
  final String? category;
  final int authorId;
  final String authorName;
  final String authorEmail;
  final String authorRole;
  final int likesCount;
  final int commentsCount;
  final bool isLikedByUser;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? publishedAt;
  final String createdAtFormatted;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.contentType,
    required this.status,
    this.imageFile,
    this.videoFile,
    this.audioFile,
    this.fileUrl,
    required this.tags,
    this.category,
    required this.authorId,
    required this.authorName,
    required this.authorEmail,
    required this.authorRole,
    required this.likesCount,
    required this.commentsCount,
    required this.isLikedByUser,
    required this.createdAt,
    required this.updatedAt,
    this.publishedAt,
    required this.createdAtFormatted,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      contentType: json['content_type'],
      status: json['status'],
      imageFile: json['image_file'],
      videoFile: json['video_file'],
      audioFile: json['audio_file'],
      fileUrl: json['file_url'],
      tags: json['tags'] ?? '',
      category: json['category'],
      authorId: json['author'],
      authorName: json['author_name'] ?? 'Auteur inconnu',
      authorEmail: json['author_email'] ?? 'email@inconnu.com',
      authorRole: json['author_role'] ?? 'unknown',
      likesCount: json['likes_count'] ?? 0,
      commentsCount: json['comments_count'] ?? 0,
      isLikedByUser: json['is_liked_by_user'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      publishedAt: json['published_at'] != null ? DateTime.parse(json['published_at']) : null,
      createdAtFormatted: json['created_at_formatted'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'content_type': contentType,
      'status': status,
      'image_file': imageFile,
      'video_file': videoFile,
      'audio_file': audioFile,
      'file_url': fileUrl,
      'tags': tags,
      'category': category,
      'author': authorId,
      'author_name': authorName,
      'author_email': authorEmail,
      'author_role': authorRole,
      'likes_count': likesCount,
      'comments_count': commentsCount,
      'is_liked_by_user': isLikedByUser,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'published_at': publishedAt?.toIso8601String(),
      'created_at_formatted': createdAtFormatted,
    };
  }

  List<String> get tagsList {
    return tags.split(',').map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
  }

  String get displayType {
    switch (contentType) {
      case 'video':
        return 'Vidéo';
      case 'audio':
        return 'Audio';
      case 'image':
        return 'Image';
      case 'text':
        return 'Article';
      default:
        return 'Contenu';
    }
  }

  bool get isPublished => status == 'published';
  bool get isDraft => status == 'draft';
  bool get isArchived => status == 'archived';
}
