import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/lab_controller.dart';
import '../../../shared/widgets/custom_button.dart';

class LabDashboardView extends StatelessWidget {
  const LabDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LabController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Get.toNamed('/add-test'),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.currentLab == null) {
          return const Center(
            child: Text('No lab found. Please contact admin.'),
          );
        }

        return RefreshIndicator(
          onRefresh: controller.loadLabData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Lab Info Card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.currentLab!.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(controller.currentLab!.address),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber[600], size: 20),
                            const SizedBox(width: 4),
                            Text(controller.currentLab!.rating.toString()),
                            const SizedBox(width: 16),
                            Icon(
                              controller.currentLab!.isVerified 
                                  ? Icons.verified 
                                  : Icons.pending,
                              color: controller.currentLab!.isVerified 
                                  ? Colors.green 
                                  : Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.currentLab!.isVerified 
                                  ? 'Verified' 
                                  : 'Pending',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Stats Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Total Tests',
                        controller.labTests.length.toString(),
                        Icons.medical_services,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStatCard(
                        'Bookings',
                        controller.labBookings.length.toString(),
                        Icons.calendar_today,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Recent Bookings
                Text(
                  'Recent Bookings',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                if (controller.labBookings.isEmpty)
                  const Center(
                    child: Text('No bookings yet'),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.labBookings.take(5).length,
                    itemBuilder: (context, index) {
                      final booking = controller.labBookings[index];
                      return Card(
                        child: ListTile(
                          title: Text('Booking #${booking.id.substring(0, 8)}'),
                          subtitle: Text(booking.timeSlot),
                          trailing: _buildStatusChip(booking.bookingStatus),
                          onTap: () => _showBookingActions(context, controller, booking),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'confirmed':
        color = Colors.blue;
        break;
      case 'completed':
        color = Colors.green;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: color.withOpacity(0.1),
      side: BorderSide(color: color),
    );
  }

  void _showBookingActions(BuildContext context, LabController controller, booking) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (booking.bookingStatus == 'pending') ...[
              CustomButton(
                text: 'Accept Booking',
                onPressed: () {
                  Navigator.pop(context);
                  controller.updateBookingStatus(booking.id, 'confirmed');
                },
              ),
              const SizedBox(height: 8),
              CustomButton(
                text: 'Reject Booking',
                isOutlined: true,
                onPressed: () {
                  Navigator.pop(context);
                  controller.updateBookingStatus(booking.id, 'cancelled');
                },
              ),
            ],
            if (booking.bookingStatus == 'confirmed') ...[
              CustomButton(
                text: 'Upload Report',
                onPressed: () {
                  Navigator.pop(context);
                  // Navigate to report upload
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}