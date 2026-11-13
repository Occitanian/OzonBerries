class Endpoints {
  Endpoints._();
  static const String content = '/products';
  static String contentById(int id) => '/products/$id';
}