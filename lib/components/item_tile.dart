import 'package:flutter/material.dart';

class ItemTile extends StatefulWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final Color color;
  final void Function()? onPressed;

  const ItemTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
    required this.onPressed,
  });

  @override
  State<ItemTile> createState() => _ItemTileState();
}

class _ItemTileState extends State<ItemTile> {
  bool isNetworkImage(String path) {
    return path.startsWith('http://') || path.startsWith('https://');
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width and height
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      padding: EdgeInsets.all(screenWidth * 0.01),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          isNetworkImage(widget.imagePath)
              ? Image.network(
                  widget.imagePath,
                  height: screenHeight * 0.15,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: screenHeight * 0.15,
                      color: Colors.grey,
                    );
                  },
                )
              : Image.asset(
                  widget.imagePath,
                  height: screenHeight * 0.15,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace? stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      size: screenHeight * 0.15,
                      color: Colors.grey,
                    );
                  },
                ),
          Text(
            widget.itemName,
            style: TextStyle(
              fontSize: screenWidth * 0.045,
              fontWeight: FontWeight.w600,
            ),
          ),
          MaterialButton(
            onPressed: widget.onPressed,
            color: widget.color,
            child: Text(
              widget.itemPrice,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.045,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
