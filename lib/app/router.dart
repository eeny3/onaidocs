import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:onaidocs/app/injection_container.dart';
import 'package:onaidocs/app/main_wrapper.dart';
import 'package:onaidocs/features/auth/presentation/pages/auth_page.dart';
import 'package:onaidocs/features/home/presentation/pages/home_page.dart';
import 'package:onaidocs/features/notifications/presentation/pages/notifications_page.dart';
import 'package:onaidocs/features/profile/presentation/pages/profile_page.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_bloc.dart';
import 'package:onaidocs/features/tasks/presentation/bloc/task_event.dart';
import 'package:onaidocs/features/tasks/presentation/pages/task_details_page.dart';
import 'package:onaidocs/features/tasks/presentation/pages/task_edit_page.dart';
import 'package:onaidocs/features/tasks/presentation/pages/tasks_list_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'shellHome');
final GlobalKey<NavigatorState> _shellNavigatorTasksKey = GlobalKey<NavigatorState>(debugLabel: 'shellTasks');
final GlobalKey<NavigatorState> _shellNavigatorNotificationsKey = GlobalKey<NavigatorState>(debugLabel: 'shellNotifications');
final GlobalKey<NavigatorState> _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'shellProfile');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
  routes: [
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return BlocProvider<TaskBloc>(
          create: (context) => sl<TaskBloc>()..add(LoadTasks()),
          child: MainWrapper(navigationShell: navigationShell),
        );
      },
      branches: [
        // Tab 1: Home
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        // Tab 2: Tasks
        StatefulShellBranch(
          navigatorKey: _shellNavigatorTasksKey,
          routes: [
            GoRoute(
              path: '/tasks',
              builder: (context, state) => const TasksListPage(),
              routes: [
                GoRoute(
                  path: 'create',
                  parentNavigatorKey: _shellNavigatorTasksKey,
                  builder: (context, state) => const TaskEditPage(),
                ),
                GoRoute(
                  path: 'details/:id',
                  parentNavigatorKey: _shellNavigatorTasksKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return TaskDetailsPage(taskId: id);
                  },
                ),
                GoRoute(
                  path: 'edit/:id',
                  parentNavigatorKey: _shellNavigatorTasksKey,
                  builder: (context, state) {
                    final id = state.pathParameters['id']!;
                    return TaskEditPage(taskId: id);
                  },
                ),
              ],
            ),
          ],
        ),
        // Tab 3: Notifications
        StatefulShellBranch(
          navigatorKey: _shellNavigatorNotificationsKey,
          routes: [
            GoRoute(
              path: '/notifications',
              builder: (context, state) => const NotificationsPage(),
            ),
          ],
        ),
        // Tab 4: Profile
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);
