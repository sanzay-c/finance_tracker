import 'package:finance_tracker/common/widgets/custom_auth_buttons.dart';
import 'package:finance_tracker/core/constants/app_colors.dart';
import 'package:finance_tracker/features/onboardings/presentation/widget/onboarding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onFinish; //call this on last page
  const OnboardingScreen({super.key, required this.onFinish});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "image": 'assets/images/onboarding1.png',
      "title": "Gain total control\nof your money",
      "description":
          "Become your own money manager\nand make every rupees count",
    },
    {
      "image": 'assets/images/onboarding2.png',
      "title": "Knowing where your\n money goes ",
      "description":
          " Track your transaction easily,\nwith categories and financial report",
    },
    {
      "image": 'assets/images/onboarding3.png',
      "title": "  Planning ahead ",
      "description":
          " Setup your budget for each category\nso you stay in control",
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor.lightModeColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0).r,
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (_, index) {
                  final data = _pages[index];
                  return OnboardingWidget(
                    image: data['image']!,
                    title: data['title']!,
                    description: data['description']!,
                  );
                },
              ),
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, _buildDot),
            ),
            30.verticalSpace,
            CustomAuthButtons(),
            20.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 10,
      width: _currentPage == index ? 20 : 10,
      decoration: BoxDecoration(
        color:
            _currentPage == index
                ? AppColors.buttonColor.darkModeColor
                : AppColors.buttonColor.lightModeColor,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
