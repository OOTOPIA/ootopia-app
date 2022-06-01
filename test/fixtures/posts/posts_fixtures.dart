import 'package:ootopia_app/clean_arch/create_post/domain/entity/create_post_entity.dart';

List<Map<String, dynamic>> postsMap = [
  {
    "id": "60e01960-4368-4c6a-b47a-7a1a43a44ed2",
    "userId": "b04b7fba-1c47-4b05-801e-09b3a61fff55",
    "description": "",
    "type": "image",
    "imageUrl":
        "https://ootopia-files-staging.s3.sa-east-1.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1650989490987.png",
    "videoUrl": null,
    "thumbnailUrl":
        "https://ootopia-files-staging.s3.sa-east-1.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1650989490987.png",
    "videoStatus": "ready",
    "oozTotalCollected": "0",
    "photoUrl":
        "https://ootopia-staging.s3.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1632491314601.jpg",
    "username": "Lucas Persona",
    "likesCount": 0,
    "commentsCount": 0,
    "city": "São Paulo",
    "state": "São Paulo",
    "country": "BR",
    "tags": ["Policy", "Education"],
    "badges": [],
    "medias": [
      {
        "mediaUrl":
            "https://ootopia-files-staging.s3.sa-east-1.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1650989490987.png",
        "thumbUrl":
            "https://ootopia-files-staging.s3.sa-east-1.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1650989490987.png",
        "type": "image"
      },
      {
        "mediaUrl":
            "https://ootopia-files-staging.s3.sa-east-1.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1650989492908.png",
        "thumbUrl":
            "https://ootopia-files-staging.s3.sa-east-1.amazonaws.com/users/b04b7fba-1c47-4b05-801e-09b3a61fff55/photo-1650989492908.png",
        "type": "image"
      }
    ],
    "usersTagged": null,
    "oozRewarded": null,
    "oozToTransfer": 0,
    "liked": false
  },
];

List<CreatePostEntity> postsFixture = [
  CreatePostEntity(
    description:
        "Mussum Ipsum, cacilds vidis litro abertis. Manduma pindureta quium dia nois paga.A ordem dos tratores não altera o pão duris.Per aumento de cachacis, eu reclamis.Tá deprimidis, eu conheço uma cachacis que pode alegrar sua vidis.",
  ),
  CreatePostEntity(
    description: "",
  ),
];
