import 'package:flutter/material.dart';
import '../models/model_3d.dart';
import '../data/models_data.dart';
import '../widgets/search_bar.dart';
import '../widgets/category_button.dart';
import '../widgets/model_card.dart';
import 'category_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Model3D> _allModels = predefinedModels;
  List<Model3D> _filteredModels = predefinedModels;
  String _searchQuery = '';
  
  // Definição das categorias
  final List<Map<String, dynamic>> _categories = [
    {
      'id': 'doces',
      'name': 'Doces',
      'icon': Icons.cake,
      'color': const Color(0xFFE57373), // Vermelho claro
    },
    {
      'id': 'salgados',
      'name': 'Salgados',
      'icon': Icons.local_dining,
      'color': const Color(0xFF81C784), // Verde claro
    },
  ];
  
  // Pesquisar modelos
  void _searchModels(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredModels = _allModels;
      } else {
        _filteredModels = _allModels
            .where((model) => model.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF336633),
        title: const Text(
          '3dine',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              // Implementar a navegação para a tela do carrinho ou lógica do carrinho aqui
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
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Barra de pesquisa
              // CustomSearchBar(onSearch: _searchModels),
              // const SizedBox(height: 24),
              
              // Título de categorias
              // const Text(
              //   'Categorias',
              //   style: TextStyle(
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //     color: Colors.black,
              //   ),
              // ),
              // const SizedBox(height: 16),
              
              // Botões de categorias
              Center(
                child: Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.center,
                  children: _categories.map((category) {
                    return CategoryButton(
                      title: category['name'],
                      icon: category['icon'],
                      color: category['color'],
                      onTap: () {
                        // Navegar para a tela da categoria
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryScreen(
                              categoryId: category['id'],
                              categoryName: category['name'],
                              categoryColor: category['color'],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 32),
              
              // Título da lista de modelos
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pratos em Destaque:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  if (_searchQuery.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                          _filteredModels = _allModels;
                        });
                      },
                      child: const Text('Limpar busca'),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Lista de modelos
              _filteredModels.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text('Nenhum modelo encontrado'),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _filteredModels.length,
                      itemBuilder: (context, index) {
                        return ModelCard(model: _filteredModels[index]);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}