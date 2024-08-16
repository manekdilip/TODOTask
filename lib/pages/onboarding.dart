import 'package:flutter/material.dart';

import '../utils/app_pages.dart';

class OnboardPage extends StatelessWidget {
  const OnboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.blackTextColor,
        ),
        child: ListView(
          children: [
            Padding(
              padding:   EdgeInsets.only(top: 163.sp, bottom: 108.sp),
              child: Center(
                child: Assets.png.logo.image(height: 185.h, width: 110.w),
              ),
            ),
            Container(
              height: 420.h,
              decoration: const BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 31, 24, 47),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin:  EdgeInsets.fromLTRB(0, 0, 0, 50.sp),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          AppLocalizations.of(context)!.appTitle,
                          style: GoogleFonts.getFont(AppStrings.fontName,
                              fontWeight: FontWeight.w700,
                              fontSize: 35,
                              height: 1.5,
                              letterSpacing: 0.4,
                              color: AppColors.blackTextColor),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          locale.getStarted,
                          style: GoogleFonts.getFont('Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                              height: 2.1,
                              letterSpacing: 0.3,
                              color: AppColors.blackTextColor),
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomePage()));
                            },
                            child: Assets.svg.onboardIcon
                                .svg(height: 66.h, width: 66.w)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
