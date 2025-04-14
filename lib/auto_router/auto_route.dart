import 'package:auto_route/auto_route.dart';
import 'package:battle_of_the_intellects/pages/game_page.dart';
import 'package:battle_of_the_intellects/pages/start_page.dart';
import 'package:battle_of_the_intellects/pages/team_input_page.dart';
import 'package:flutter/material.dart';

import '../services/connectivity_service.dart';

part 'auto_route.gr.dart'; // This will be generated

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: StartRoute.page, initial: true),
        AutoRoute(page: TeamInputRoute.page),
        AutoRoute(page: GameRoute.page),
      ];
}
