import '../models/model_3d.dart';

// Lista de modelos com URLs do p3d.in
final List<Model3D> predefinedModels = [
  Model3D(
    id: 'bolo_cenoura',
    name: 'Bolo de Cenoura',
    imagePath: 'assets/images/bolo_cenoura.png',
    category: 'doces',
    p3dUrl: 'https://p3d.in/7rMTx',
    glbPath: 'modelos/bolo_cenoura.glb',
    price: 25.00,
    ingredients: 'Farinha de trigo, açúcar, ovos, cenoura, chocolate',
    description: 'Um delicioso bolo de cenoura com uma rica cobertura de chocolate. Perfeito para qualquer ocasião.',
  ),
  Model3D(
    id: 'torta_doce',
    name: 'Torta de Leite',
    imagePath: 'assets/images/torta_doce.png',
    category: 'doces',
    p3dUrl: 'https://p3d.in/7rMTx',
    glbPath: 'modelos/torta_doce.glb',
    price: 30.00,
    ingredients: 'Leite condensado, creme de leite, biscoito, manteiga',
    description: 'Uma torta cremosa de leite condensado com base de biscoito, ideal para os amantes de doces.',
  ),
  Model3D(
    id: 'coxinha',
    name: 'Coxinha de Frango',
    imagePath: 'assets/images/coxinha.png',
    category: 'salgados',
    p3dUrl: 'https://p3d.in/xxxx',
    glbPath: 'modelos/coxinha.glb',
    price: 7.50,
    ingredients: 'Massa de batata, frango desfiado, requeijão',
    description: 'A tradicional coxinha de frango com massa macia de batata e recheio cremoso de frango com requeijão.',
  ),
  Model3D(
    id: 'pastel',
    name: 'Pastel de Carne',
    imagePath: 'assets/images/pastel.png',
    category: 'salgados',
    p3dUrl: 'https://p3d.in/yyyy',
    glbPath: 'modelos/pastel.glb',
    price: 8.00,
    ingredients: 'Farinha, carne moída, azeitonas, temperos',
    description: 'Um pastel crocante recheado com carne moída bem temperada e azeitonas.',
  ),
];