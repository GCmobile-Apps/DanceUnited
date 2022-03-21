class CardInfo {
  String cardNumber;
  String cvc;

  Map<String, dynamic> toJson() => {'cardNumber': cardNumber, 'cvc': cvc};
}
