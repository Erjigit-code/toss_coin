String getCoinImage(String coinId, bool isHeads) {
  switch (coinId) {
    case 'euro':
      return isHeads
          ? 'assets/images/euro_head.png'
          : 'assets/images/euro_tail.png';
    case 'kg':
      return isHeads
          ? 'assets/images/kg_head.png'
          : 'assets/images/kg_tail.png';
    case 'rus':
      return isHeads
          ? 'assets/images/rus_head.png'
          : 'assets/images/rus_tail.png';
    case 'us':
      return isHeads
          ? 'assets/images/us_head.png'
          : 'assets/images/us_tail.png';
    default:
      return isHeads
          ? 'assets/images/euro_head.png'
          : 'assets/images/euro_tail.png';
  }
}
