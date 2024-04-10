import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

extension SizeExtensions on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
  ResponsiveBreakpointsData get breakpointsData =>
      ResponsiveBreakpoints.of(this);

  // Booleans
  bool get isDesktop => breakpointsData.isDesktop;
  bool get isTablet => breakpointsData.isTablet;
  bool get isMobile => breakpointsData.isMobile;
  bool get isPhone => breakpointsData.isPhone;

// Conditionals
  bool get equalsDesktop => breakpointsData.equals(DESKTOP);
  bool get largerThanMobile => breakpointsData.largerThan(MOBILE);
  bool get largerThanTablet => breakpointsData.largerThan(TABLET);
  bool get smallerThanTablet => breakpointsData.smallerThan(TABLET);
  bool get betweenMobileAndTablet => breakpointsData.between(MOBILE, TABLET);
}

extension ThemeExtensions on BuildContext {
  ThemeData get themeData => Theme.of(this);
  Color get primaryColor => themeData.colorScheme.primary;
}

extension RouteExtensions on String {
  String get path => "/$this";
}
