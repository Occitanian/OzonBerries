import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../di/di.dart';
import 'bloc/home_bloc.dart';
import '../../widgets/widgets.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _home = getIt<HomeBloc>();

  void loadHome() => _home.add(const HomeLoad());

  @override
  void initState() {
    loadHome();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: BlocBuilder<HomeBloc, HomeState>(
        bloc: _home,
        builder: (context, state) {
          return switch (state) {
            HomeInitial() => const SizedBox.shrink(),
            HomeLoadInProgress() => const Center(child: CircularProgressIndicator()),
            HomeLoadSuccess() => _buildHomeLoadSuccess(state),
            HomeLoadFailure() => _buildHomeLoadFailure(state),
          };
        },
      ),
    );
  }

  Widget _buildHomeLoadSuccess(HomeLoadSuccess state) {
    // Берем локальных животных (у них id < 0) и товары из API (id > 0)
    final shelters = state.content.where((c) => c.id < 0).toList();
    final products = state.content.where((c) => c.id > 0).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), // Серый фон
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.pets, color: Color(0xFF005BFF)), // Синий цвет Ozon
            const SizedBox(width: 8),
            const Text('OzonBerries', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: Color(0xFF005BFF))),
            const Spacer(),
            IconButton(onPressed: () {}, icon: const Icon(Icons.favorite_border)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.shopping_cart_outlined)),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Искать товары и питомцев...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- ПРИЮТ ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.volunteer_activism, color: Colors.green),
                  const SizedBox(width: 8),
                  Text('Помогите найти дом', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            SizedBox(
              height: 220, // Высота карусели
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: shelters.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) => ShelterCard(content: shelters[index]),
              ),
            ),

            // --- МАРКЕТПЛЕЙС ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Text('Хиты продаж', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            ),
            GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // 👇 ВОТ ТУТ МЕНЯЕМ ДЕЛЕГАТА СЕТКИ 👇
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200, // Максимальная ширина одной карточки
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.65, // Пропорции карточки
              ),
              itemCount: products.length,
              itemBuilder: (context, index) => ProductCard(content: products[index]),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeLoadFailure(HomeLoadFailure state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              'Ошибка: ${state.exception}',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: loadHome, child: const Text('Повторить')),
          ],
        ),
      ),
    );
  }
}