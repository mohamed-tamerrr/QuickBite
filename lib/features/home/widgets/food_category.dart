import 'dart:ui';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class FoodCategory extends StatefulWidget {
  const FoodCategory({
    super.key,
    required this.selectedIndex,
    required this.categories,
  });

  final int selectedIndex;
  final List<dynamic> categories;

  @override
  State<FoodCategory> createState() => _FoodCategoryState();
}

class _FoodCategoryState extends State<FoodCategory> {
  late int selectedIndex;

  @override
  void initState() {
    selectedIndex = widget.selectedIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 55,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  isSelected ? 22 : 18,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isSelected
                      ? AppColors.gradientsPrimary
                      : [
                          Colors.grey.withValues(alpha: .25),
                          Colors.grey.withValues(alpha: .35),
                        ],
                ),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryLight
                      : Colors.white.withValues(alpha: .7),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isSelected
                        ? AppColors.primary.withValues(
                            alpha: .25,
                          )
                        : Colors.black.withValues(alpha: .05),
                    blurRadius: isSelected ? 16 : 8,
                    spreadRadius: isSelected ? 1 : 0,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  isSelected ? 22 : 18,
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 10,
                    sigmaY: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(
                          milliseconds: 250,
                        ),
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? Colors.white
                              : AppColors.primary,
                        ),
                        child: Icon(
                          isSelected
                              ? Icons.check
                              : Icons.restaurant_menu,
                          size: 14,
                          color: isSelected
                              ? AppColors.primary
                              : Colors.white,
                        ),
                      ),

                      const SizedBox(width: 10),

                      Text(
                        widget.categories[index],
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
