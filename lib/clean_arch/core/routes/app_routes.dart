import 'package:flutter/material.dart';
import 'package:ootopia_app/clean_arch/core/constants/routes.dart';
import 'package:ootopia_app/clean_arch/create_post/presentation/ui/interesting_tags_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  NamedRoutes.interestingTags: (context) => const InterestingTagsPage(),
};
