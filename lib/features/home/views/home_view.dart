import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/home_controller.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/lab_card.dart';
import '../../../shared/widgets/test_card.dart';
import '../../../shared/widgets/category_card.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final l10n = AppLocalizations.of(context)!;
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () => Get.toNamed('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => Get.toNamed('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: controller.refresh,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.welcome,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Book diagnostic tests at nearby labs',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Search Bar
              CustomTextField(
                controller: searchController,
                label: l10n.searchTests,
                prefixIcon: Icons.search,
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.searchTests(value);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Test Categories
              Text(
                'Test Categories',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.testCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.testCategories[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 16),
                      child: CategoryCard(
                        name: category['name'],
                        icon: category['icon'],
                        onTap: () => controller.selectCategory(category['category']),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),

              // Nearby Labs
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.nearbyLabs,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed('/search'),
                    child: const Text('View All'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (controller.nearbyLabs.isEmpty) {
                  return const Center(
                    child: Text('No nearby labs found'),
                  );
                }

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.nearbyLabs.length,
                    itemBuilder: (context, index) {
                      final lab = controller.nearbyLabs[index];
                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: LabCard(
                          lab: lab,
                          currentLocation: controller.currentLocation,
                          onTap: () => Get.toNamed('/lab-details', arguments: lab),
                        ),
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 32),

              // Popular Tests
              Text(
                'Popular Tests',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                if (controller.popularTests.isEmpty) {
                  return const Center(
                    child: Text('No tests available'),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.popularTests.length,
                  itemBuilder: (context, index) {
                    final test = controller.popularTests[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TestCard(
                        test: test,
                        onTap: () => Get.toNamed('/test-details', arguments: test),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}