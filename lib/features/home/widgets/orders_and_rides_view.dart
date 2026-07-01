import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';

/// Attractive, modern Orders & Rides View.
/// Redesigned with premium gradient cards, glassmorphic accents, decorative circles,
/// and sleek statistics typography to match the HomeWalletWidget aesthetic.
class OrdersAndRidesView extends StatelessWidget {
  final ProfileController profileController;
  const OrdersAndRidesView({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    final model = profileController.profileModel;
    final bool isDark = Get.isDarkMode;

    final bool isDeliveryOn = model?.isDeliveryOn ?? false;
    final bool isRideOn = model?.isRideOn ?? false;
    final bool isActiveBoth = isDeliveryOn && isRideOn;

    // If both cards are shown, width is slightly smaller to show preview of next card in carousel
    final double cardWidth = isActiveBoth
        ? Get.width * 0.85
        : Get.width - Dimensions.paddingSizeDefault * 2;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSizeDefault,
        vertical: Dimensions.paddingSizeSmall,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ─────────────────────────────────────────
          Row(
            children: [
              Container(
                width: 4,
                height: 18,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF7A00),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: Dimensions.paddingSizeSmall),
              Text(
                'activity overview'.tr,
                style: robotoBold.copyWith(fontSize: Dimensions.fontSizeLarge),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // ── Cards Carousel / List ──────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                // Delivery Orders Card
                if (isDeliveryOn) ...[
                  _buildActivityCard(
                    context: context,
                    width: cardWidth,
                    title: 'orders'.tr,
                    badgeText: 'delivery'.tr,
                    icon: Icons.local_shipping_rounded,
                    gradientColors: isDark
                        ? [const Color(0xFF134E4A), const Color(0xFF042F2E)]
                        : [const Color(0xFF0D9488), const Color(0xFF0F766E)],
                    shadowColor: const Color(0xFF0D9488),
                    totalLabel: 'total_orders'.tr,
                    totalValue: model?.orderCount?.toString(),
                    todayLabel: 'todays_orders'.tr,
                    todayValue: model?.todaysOrderCount?.toString(),
                    weekLabel: 'this_week_orders'.tr,
                    weekValue: model?.thisWeekOrderCount?.toString(),
                  ),
                ],

                if (isActiveBoth)
                  const SizedBox(width: Dimensions.paddingSizeDefault),

                // Rides Card
                if (isRideOn) ...[
                  _buildActivityCard(
                    context: context,
                    width: cardWidth,
                    title: 'rides'.tr,
                    badgeText: 'ride_share'.tr,
                    icon: Icons.directions_car_filled_rounded,
                    gradientColors: isDark
                        ? [const Color(0xFF312E81), const Color(0xFF1E1B4B)]
                        : [const Color(0xFF6366F1), const Color(0xFF4338CA)],
                    shadowColor: const Color(0xFF6366F1),
                    totalLabel: 'total_rides'.tr,
                    totalValue: model?.totalRides?.toString(),
                    todayLabel: 'todays_rides'.tr,
                    todayValue: model?.todayRideCount?.toString(),
                    weekLabel: 'this_week_rides'.tr,
                    weekValue: model?.thisWeekRideCount?.toString(),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard({
    required BuildContext context,
    required double width,
    required String title,
    required String badgeText,
    required IconData icon,
    required List<Color> gradientColors,
    required Color shadowColor,
    required String totalLabel,
    required String? totalValue,
    required String todayLabel,
    required String? todayValue,
    required String weekLabel,
    required String? weekValue,
  }) {
    final bool isDark = Get.isDarkMode;

    return Container(
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: isDark ? 0.15 : 0.3),
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative background circle top-right
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          // Decorative background circle bottom-left
          Positioned(
            bottom: -20,
            left: 20,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Top Row: Icon + Title + Badge ───────────────────
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(icon, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          title,
                          style: robotoBold.copyWith(
                            color: Colors.white,
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        badgeText,
                        style: robotoMedium.copyWith(
                          fontSize: 10,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                // ── Big Total Stat ──────────────────────────────────
                Text(
                  totalLabel,
                  style: robotoMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: 4),
                totalValue != null
                    ? Text(
                        totalValue,
                        style: robotoBold.copyWith(
                          fontSize: 34,
                          color: Colors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : _shimmer(width: 80, height: 38),
                const SizedBox(height: Dimensions.paddingSizeLarge),

                // ── Divider Line ────────────────────────────────────
                Container(
                  height: 1,
                  color: Colors.white.withValues(alpha: 0.15),
                ),
                const SizedBox(height: Dimensions.paddingSizeDefault),

                // ── Bottom Stat Row (Today | This Week) ─────────────
                Row(
                  children: [
                    _StatSubItem(
                      label: todayLabel,
                      value: todayValue,
                      icon: Icons.calendar_today_rounded,
                      accentColor: const Color(0xFF34D399),
                    ),
                    Container(
                      width: 1,
                      height: 36,
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                    _StatSubItem(
                      label: weekLabel,
                      value: weekValue,
                      icon: Icons.date_range_rounded,
                      accentColor: const Color(0xFFFBBF24),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmer({required double width, required double height}) {
    return Shimmer(
      duration: const Duration(seconds: 2),
      color: Colors.white.withValues(alpha: 0.3),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

// ── Sub-widget: Stat Item (Today / Week) ────────────────────────────────────
class _StatSubItem extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color accentColor;

  const _StatSubItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Dimensions.paddingSizeSmall,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 15),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: robotoRegular.copyWith(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.75),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  value != null
                      ? Text(
                          value!,
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Container(
                          height: 14,
                          width: 35,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
