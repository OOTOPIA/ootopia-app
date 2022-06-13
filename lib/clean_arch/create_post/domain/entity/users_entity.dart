class UsersEntity {
  String id;
  String fullname;
  String? email;
  String? photoUrl;

  UsersEntity({
    this.email,
    required this.fullname,
    required this.id,
    this.photoUrl,
  });
}
