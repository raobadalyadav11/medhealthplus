import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../controllers/search_controller.dart' as search;
import '../../../shared/widgets/custom_text_field.dart';
import '../../../shared/widgets/lab_card.dart';
import '../../../shared/widgets/test_card.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(search.SearchController());
    final l10n = AppLocalizations.of(context)!;
    final searchController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Labs & Tests'),
        actions: [
          PopupMenuButton<String>(
            onSelected: controller.setSortBy,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'distance',
                child: Text('Sort by Distance'),
              ),
              const PopupMenuItem(
                value: 'rating',
                child: Text('Sort by Rating'),
              ),
              const PopupMenuItem(
                value: 'price',
                child: Text('Sort by Price'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: CustomTextField(
              controller: searchController,
              label: l10n.searchTests,
              prefixIcon: Icons.search,
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  searchController.clear();
                  controller.clearSearch();
                },
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  controller.searchLabs(value);
                }
              },
            ),
          ),

          // Filter Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip(
                    'All',
                    controller.selectedCategory.isEmpty,
                    () => controller.clearSearch(),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'X-Ray',
                    controller.selectedCategory == 'xray',
                    () => controller.searchByCategory('xray'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Ultrasound',
                    controller.selectedCategory == 'ultrasound',
                    () => controller.searchByCategory('ultrasound'),
                  ),
                  const SizedBox(width: 8),
                  _buildFilterChip(
                    'Blood Test',
                    controller.selectedCategory == 'blood_test',
                    () => controller.searchByCategory('blood_test'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Results
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.searchResults.isEmpty && controller.testResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No results found',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Try searching with different keywords',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    TabBar(
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      indicatorColor: Theme.of(context).primaryColor,
                      tabs: [
                        Tab(text: 'Labs (${controller.searchResults.length})'),
                        Tab(text: 'Tests (${controller.testResults.length})'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Labs Tab
                          ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.searchResults.length,
                            itemBuilder: (context, index) {
                              final lab = controller.searchResults[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: LabCard(
                                  lab: lab,
                                  onTap: () => Get.toNamed('/lab-details', arguments: lab),
                                ),
                              );
                            },
                          ),
                          // Tests Tab
                          ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: controller.testResults.length,
                            itemBuilder: (context, index) {
                              final test = controller.testResults[index];
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: TestCard(
                                  test: test,
                                  onTap: () => Get.toNamed('/test-details', arguments: test),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Get.theme.primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}