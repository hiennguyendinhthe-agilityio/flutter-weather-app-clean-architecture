class ApiUser {
  String? userId;
  String? name;
  String? email;
  String? password;
  bool isLoggedIn;
  String? avatarUrl;
  String? phoneNumber;
  String? personalWebsite;
  String? portfolioUrl;
  String? coverLetter;

  ApiUser({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.isLoggedIn = false,
    this.avatarUrl,
    this.phoneNumber,
    this.personalWebsite,
    this.portfolioUrl,
    this.coverLetter,
  });

  factory ApiUser.fromJson(Map<String, dynamic> json) {
    return ApiUser(
      userId: json['id'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      isLoggedIn: json['isLoggedIn'] ?? false,
      avatarUrl: json['avatarUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      personalWebsite: json['personalWebsite'] as String?,
      portfolioUrl: json['portfolioUrl'] as String?,
      coverLetter: json['coverLetter'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': userId,
      'name': name,
      'email': email,
      'password': password,
      'isLoggedIn': isLoggedIn,
      'avatarUrl': avatarUrl,
      'phoneNumber': phoneNumber,
      'personalWebsite': personalWebsite,
      'portfolioUrl': portfolioUrl,
      'coverLetter': coverLetter,
    };
  }
}
