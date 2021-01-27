class PostData {
  final int postId;
  final String author;
  final String caption;
  final String imageUrl;

  static PostData defaultPost1 = PostData(
      1,
      "sav",
      "I'm super proud of this. Never thought cooking with week old rice would turn out so delicious.",
      "https://cookwithculi.com/images/sav.png");
  static PostData defaultPost2 = PostData(
      1,
      "graham",
      "I'm super proud of this. Never thought cooking with week old rice would turn out so delicious.",
      "https://cookwithculi.com/images/graham.jpg");

  PostData(this.postId, this.author, this.caption, this.imageUrl);
}
