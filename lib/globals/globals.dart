class Globals {
  // Bookstore Plant ID: C2620614616S2T
  // Clothing Store Plant ID: C7416406502S2T
  static String plant = "C2620614616S2T"; // default: bookstore

  static bool get isClothingStore =>
      plant == "C7416406502S2T";

  
  static bool get isBookstore =>
      plant == "C2620614616S2T";

  // static String ORIGIN = "localhost:3000";
  static String ORIGIN = "https://mooremarket.in";

  // 🌐 BASE API URL (keep old ones commented)
  static String API_BASE_URL =
      "https://api-fmworker-ind.u-clo.com/AlphabitEcommerce.0.1/api";

  // static String API_BASE_URL = "http://10.0.2.2:9071/api";
}
