import 'package:flutter/material.dart';
import '../models/model_3d.dart';
import 'model_viewer_screen.dart';
import 'rating_screen.dart';
import '../services/supabase_rating_service.dart';
import 'cart_screen.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';

class InformacoesScreen extends StatefulWidget {
  final Model3D model;

  const InformacoesScreen({Key? key, required this.model}) : super(key: key);

  @override
  _InformacoesScreenState createState() => _InformacoesScreenState();
}

class _InformacoesScreenState extends State<InformacoesScreen> {
  final SupabaseRatingService _ratingService = SupabaseRatingService();
  double _averageRating = 0.0;
  bool _isLoadingRating = true;

  @override
  void initState() {
    super.initState();
    _loadAverageRating();
  }

  Future<void> _loadAverageRating() async {
    try {
      final average = await _ratingService.getAverageRating(widget.model.id);
      if (mounted) {
        setState(() {
          _averageRating = average;
          _isLoadingRating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRating = false;
        });
      }
      print('Erro ao carregar média de avaliação na InformacoesScreen: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.model.name),
        backgroundColor: const Color(0xFF336633),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CartScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Foto do modelo e Nome
            Center(
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      widget.model.imagePath,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.model.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        _isLoadingRating ? 'Carregando...' : _averageRating.toStringAsFixed(1),
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Preço acima dos ingredientes e descrição
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'R\$ ${widget.model.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF336633),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Descrição
            const Text(
              'Descrição:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.model.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Ingredientes
            const Text(
              'Ingredientes:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.model.ingredients,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),

            // Botões na parte inferior
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Visual 3D (esquerda)
                SizedBox(
                  height: 45,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.view_in_ar),
                    label: const Text('Visual 3D'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF336633),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ModelViewerScreen(model: widget.model),
                        ),
                      );
                    },
                  ),
                ),
                // Botão Add to Cart (centro)
                SizedBox(
                  height: 45,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF336633),
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addItem(widget.model);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${widget.model.name} adicionado ao carrinho!')),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Add to '),
                        const Icon(Icons.shopping_cart, size: 20),
                      ],
                    ),
                  ),
                ),
                // Botão Avaliar (direita)
                SizedBox(
                  height: 45,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.star, size: 20),
                    label: const Text('Avaliar'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF336633),
                      side: const BorderSide(color: Color(0xFF336633)),
                    ),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RatingScreen(model: widget.model),
                        ),
                      );
                      // Recarregar a média de avaliação após o retorno da tela de avaliação
                      _loadAverageRating();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 