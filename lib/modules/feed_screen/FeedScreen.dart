import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layout/cubit/AppCubit.dart';
import '../../layout/cubit/AppStates.dart';
import '../../shared/components/CustomPostCard.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AppCubit cubit = AppCubit.get(context);

    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) {
        Widget body;
        if (state is GetPostLoadingState) {
          body = const Center(child: CircularProgressIndicator());
        } else if (state is GetPostErrorState) {
          body = ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 220),
              Center(
                child: Text(
                  'Could not load posts. Pull down to retry.',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else if (cubit.posts.isEmpty) {
          body = ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              SizedBox(height: 220),
              Center(child: Text('No posts yet')),
            ],
          );
        } else {
          body = ListView.separated(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              return CustomPostCard(
                model: cubit.posts[index],
                index: index,
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemCount: cubit.posts.length,
          );
        }
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: cubit.getPosts,
            child: body,
          ),
        );
      },
      listener: (context, state) {},
    );
  }
}
