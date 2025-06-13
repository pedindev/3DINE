import 'package:flutter/foundation.dart';
import '../models/model_3d.dart';

class CartItem {
  final Model3D model;
  int quantity;

  CartItem({required this.model, this.quantity = 1});

  // Método para aumentar a quantidade
  void incrementQuantity() {
    quantity++;
  }

  // Método para diminuir a quantidade
  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }
}

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  void addItem(Model3D model) {
    int index = _items.indexWhere((item) => item.model.id == model.id);
    if (index != -1) {
      // Se o item já existe, apenas aumenta a quantidade
      _items[index].incrementQuantity();
    } else {
      // Se o item não existe, adiciona um novo
      _items.add(CartItem(model: model));
    }
    notifyListeners(); // Notifica os ouvintes que a lista mudou
  }

  void removeItem(String modelId) {
    _items.removeWhere((item) => item.model.id == modelId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + (item.model.price * item.quantity));
  }
} 