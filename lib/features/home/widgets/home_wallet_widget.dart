import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:sixam_mart_delivery/features/profile/controllers/profile_controller.dart';
import 'package:sixam_mart_delivery/helper/price_converter_helper.dart';
import 'package:sixam_mart_delivery/helper/route_helper.dart';
import 'package:sixam_mart_delivery/util/dimensions.dart';
import 'package:sixam_mart_delivery/util/styles.dart';

/// Unified Home Wallet Widget.
/// Merges earnings stats (Today / This Week / This Month) and wallet balances
/// (Withdrawable Balance, Total Earned, Pending Withdraw) into a single card.
/// Shown for all delivery-mode riders regardless of the `earnings` feature flag.
class HomeWalletWidget extends StatelessWidget {
  final ProfileController profileController;
  const HomeWalletWidget({super.key, required this.profileController});

  @override
  Widget build(BuildContext context) {
    final model = profileController.profileModel;
    final bool isDark = Get.isDarkMode;

    // Determine if earnings breakdown is available for this account
    final bool hasEarnings = model != null && model.earnings == 1;

    // Wallet fields
    final double withdrawable = model?.withDrawableBalance ?? 0;
    final double totalEarned = model?.balance ?? 0;
    final double pending = model?.pendingWithdraw ?? 0;

    // Earnings breakdown fields (only meaningful when earnings flag is enabled)
    final double? todayEarning = model?.todaysEarning;
    final double? weekEarning = model?.thisWeekEarning;
    final double? monthEarning = model?.thisMonthEarning;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        Dimensions.paddingSizeDefault,
        0,
        Dimensions.paddingSizeDefault,
        Dimensions.paddingSizeLarge,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section Header ─────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
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
                    'My wallet'.tr,
                    style: robotoBold.copyWith(
                      fontSize: Dimensions.fontSizeLarge,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => Get.toNamed(RouteHelper.getMyAccountRoute()),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      Text(
                        'view_all'.tr,
                        style: robotoMedium.copyWith(
                          fontSize: Dimensions.fontSizeSmall,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 12,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Dimensions.paddingSizeDefault),

          // ── Main Gradient Card ───────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1A2744), const Color(0xFF0B192C)]
                    : [const Color(0xFF0052CC), const Color(0xFF003580)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(
                    0xFF0052CC,
                  ).withValues(alpha: isDark ? 0.15 : 0.35),
                  blurRadius: 20,
                  spreadRadius: 0,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Decorative circle top-right
                Positioned(
                  top: -30,
                  right: -20,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.05),
                    ),
                  ),
                ),
                // Decorative circle bottom-left
                Positioned(
                  bottom: -20,
                  left: 20,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.04),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Top row: icon + label + withdraw button ──────
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.account_balance_wallet_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Earnings'.tr,
                                style: robotoMedium.copyWith(
                                  color: Colors.white.withValues(alpha: 0.85),
                                  fontSize: Dimensions.fontSizeSmall,
                                ),
                              ),
                            ],
                          ),

                          // Withdraw shortcut button
                          InkWell(
                            onTap: () =>
                                Get.toNamed(RouteHelper.getMyAccountRoute()),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF7A00),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'withdraw'.tr,
                                style: robotoBold.copyWith(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Dimensions.paddingSizeSmall),

                      // ── Big Withdrawable Balance ─────────────────────
                      model != null
                          ? Text(
                              PriceConverterHelper.convertPrice(withdrawable),
                              style: robotoBold.copyWith(
                                fontSize: 32,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            )
                          : _shimmer(width: 120, height: 36),
                      const SizedBox(height: Dimensions.paddingSizeLarge),

                      // ── Divider ──────────────────────────────────────
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                      const SizedBox(height: Dimensions.paddingSizeDefault),

                      // ── Wallet Stats Row: Total Earned | Pending ─────
                      Row(
                        children: [
                          _WalletStatItem(
                            label: 'total_earned'.tr,
                            value: model != null
                                ? PriceConverterHelper.convertPrice(totalEarned)
                                : null,
                            icon: Icons.trending_up_rounded,
                            iconColor: const Color(0xFF34D399),
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.white.withValues(alpha: 0.15),
                          ),
                          _WalletStatItem(
                            label: 'pending_withdraw'.tr,
                            value: model != null
                                ? PriceConverterHelper.convertPrice(pending)
                                : null,
                            icon: Icons.hourglass_top_rounded,
                            iconColor: const Color(0xFFFBBF24),
                          ),
                        ],
                      ),

                      // ── Earnings Breakdown (only shown when flag is on) ──
                      if (hasEarnings) ...[
                        const SizedBox(height: Dimensions.paddingSizeDefault),
                        Container(
                          height: 1,
                          color: Colors.white.withValues(alpha: 0.15),
                        ),
                        const SizedBox(height: Dimensions.paddingSizeDefault),

                        Row(
                          children: [
                            _EarningStatItem(
                              label: 'today'.tr,
                              amount: todayEarning,
                            ),
                            Container(
                              width: 1,
                              height: 34,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            _EarningStatItem(
                              label: 'this_week'.tr,
                              amount: weekEarning,
                            ),
                            Container(
                              width: 1,
                              height: 34,
                              color: Colors.white.withValues(alpha: 0.15),
                            ),
                            _EarningStatItem(
                              label: 'this_month'.tr,
                              amount: monthEarning,
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
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

// ── Sub-widget: Wallet stat (Total Earned / Pending) ──────────────────────────
class _WalletStatItem extends StatelessWidget {
  final String label;
  final String? value;
  final IconData icon;
  final Color iconColor;

  const _WalletStatItem({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconColor,
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
                color: iconColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor, size: 16),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: robotoRegular.copyWith(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  value != null
                      ? Text(
                          value!,
                          style: robotoBold.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : Container(
                          height: 14,
                          width: 50,
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

// ── Sub-widget: Today / This Week / This Month earning columns ─────────────────
class _EarningStatItem extends StatelessWidget {
  final String label;
  final double? amount;

  const _EarningStatItem({required this.label, this.amount});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: robotoMedium.copyWith(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 4),
          amount != null
              ? Text(
                  PriceConverterHelper.convertPrice(amount),
                  style: robotoBold.copyWith(
                    fontSize: Dimensions.fontSizeSmall,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                )
              : Shimmer(
                  duration: const Duration(seconds: 2),
                  color: Colors.white.withValues(alpha: 0.3),
                  child: Container(
                    height: 14,
                    width: 40,
                    color: Colors.white.withValues(alpha: 0.2),
                  ),
                ),
        ],
      ),
    );
  }
}
