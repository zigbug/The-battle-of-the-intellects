// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'auto_route.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    GameRoute.name: (routeData) {
      final args = routeData.argsAs<GameRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: GamePage(
          key: args.key,
          team1Name: args.team1Name,
          team2Name: args.team2Name,
          selectedPackPath: args.selectedPackPath,
        ),
      );
    },
    StartRoute.name: (routeData) {
      final args = routeData.argsAs<StartRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: StartPage(
          key: args.key,
          connectivityService: args.connectivityService,
        ),
      );
    },
    TeamInputRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const TeamInputPage(),
      );
    },
  };
}

/// generated route for
/// [GamePage]
class GameRoute extends PageRouteInfo<GameRouteArgs> {
  GameRoute({
    Key? key,
    required String team1Name,
    required String team2Name,
    required String selectedPackPath,
    List<PageRouteInfo>? children,
  }) : super(
          GameRoute.name,
          args: GameRouteArgs(
            key: key,
            team1Name: team1Name,
            team2Name: team2Name,
            selectedPackPath: selectedPackPath,
          ),
          initialChildren: children,
        );

  static const String name = 'GameRoute';

  static const PageInfo<GameRouteArgs> page = PageInfo<GameRouteArgs>(name);
}

class GameRouteArgs {
  const GameRouteArgs({
    this.key,
    required this.team1Name,
    required this.team2Name,
    required this.selectedPackPath,
  });

  final Key? key;

  final String team1Name;

  final String team2Name;

  final String selectedPackPath;

  @override
  String toString() {
    return 'GameRouteArgs{key: $key, team1Name: $team1Name, team2Name: $team2Name, selectedPackPath: $selectedPackPath}';
  }
}

/// generated route for
/// [StartPage]
class StartRoute extends PageRouteInfo<StartRouteArgs> {
  StartRoute({
    Key? key,
    required ConnectivityService connectivityService,
    List<PageRouteInfo>? children,
  }) : super(
          StartRoute.name,
          args: StartRouteArgs(
            key: key,
            connectivityService: connectivityService,
          ),
          initialChildren: children,
        );

  static const String name = 'StartRoute';

  static const PageInfo<StartRouteArgs> page = PageInfo<StartRouteArgs>(name);
}

class StartRouteArgs {
  const StartRouteArgs({
    this.key,
    required this.connectivityService,
  });

  final Key? key;

  final ConnectivityService connectivityService;

  @override
  String toString() {
    return 'StartRouteArgs{key: $key, connectivityService: $connectivityService}';
  }
}

/// generated route for
/// [TeamInputPage]
class TeamInputRoute extends PageRouteInfo<void> {
  const TeamInputRoute({List<PageRouteInfo>? children})
      : super(
          TeamInputRoute.name,
          initialChildren: children,
        );

  static const String name = 'TeamInputRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
