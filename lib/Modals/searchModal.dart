class searchModal {
  String strDrink;
  String strDrinkThumb;
  String idDrink;

  searchModal({
    required this.idDrink,
    required this.strDrinkThumb,
    required this.strDrink,
  });

  factory searchModal.fromJson(Map<String, dynamic> json) {
    return searchModal(
        idDrink: json['idDrink'],
        strDrinkThumb: json['strDrinkThumb'],
        strDrink: json['strDrink']);
  }
}
