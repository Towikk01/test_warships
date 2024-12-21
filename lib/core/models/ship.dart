class Ship {
  final int size;
  bool isPlaced;
  bool isHorizontal; // New property for rotation
  List<int> positions;

  Ship({required this.size})
      : isPlaced = false,
        isHorizontal = false,
        positions = [];
}
