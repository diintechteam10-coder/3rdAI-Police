class GoogleUserModel {
  final String? uid;
  final String? name;
  final String? email;
  final String? photoUrl;
  final String? idToken;
  final String? accessToken;

  const GoogleUserModel({
    this.uid,
    this.name,
    this.email,
    this.photoUrl,
    this.idToken,
    this.accessToken,
  });
}
