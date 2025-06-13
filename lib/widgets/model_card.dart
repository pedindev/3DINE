import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/model_3d.dart';
import '../services/supabase_rating_service.dart';
import '../screens/rating_screen.dart';
import '../screens/model_viewer_screen.dart';
import '../screens/informacoes_screen.dart';
import '../services/cart_provider.dart';

class ModelCard extends StatefulWidget {
  final Model3D model;
  
  const ModelCard({
    Key? key,
    required this.model,
  }) : super(key: key);
  
  @override
  _ModelCardState createState() => _ModelCardState();
}

class _ModelCardState extends State<ModelCard> {
  final SupabaseRatingService _ratingService = SupabaseRatingService();
  double _averageRating = 0.0;
  bool _isLoading = true;
  
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
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      print('Erro ao carregar média: $e');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Imagem do modelo
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.model.imagePath,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                
                // Informações do modelo
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.model.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            _isLoading ? 'Carregando...' : _averageRating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Botões e Preço
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão + Info (esquerda)
                SizedBox(
                  height: 36,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF336633),
                      side: const BorderSide(color: Color(0xFF336633)),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InformacoesScreen(model: widget.model),
                        ),
                      );
                    },
                    child: const Text('+ Info'),
                  ),
                ),
                // Botão Add to Cart (centro)
                SizedBox(
                  height: 36,
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
                // Preço (direita)
                Text(
                  'R\$ ${widget.model.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF336633),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  String _formatCategory(String category) {
    switch (category) {
      case 'doces':
        return 'Doces';
      case 'salgados':
        return 'Salgados';
      default:
        return 'Outros';
    }
  }
  
  Color _getCategoryColor(String category) {
    switch (category) {
      case 'doces':
        return const Color(0xFFE57373); // Vermelho claro
      case 'salgados':
        return const Color(0xFF81C784); // Verde claro
      default:
        return Colors.grey;
    }
  }
}