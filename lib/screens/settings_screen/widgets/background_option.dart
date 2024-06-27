import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bacground/background_slct_screen.dart';
import '../../../bloc/background_bloc/background_bloc.dart';

class BackgroundOption extends StatelessWidget {
  final String selectedImage;

  const BackgroundOption({super.key, required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BackgroundBloc, BackgroundState>(
      builder: (context, state) {
        if (state is BackgroundsLoaded) {
          return _buildSettingsOption(
            title: "Выбор Фона",
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BackgroundSelectionScreen(
                    initialSelectedImage: selectedImage,
                  ),
                ),
              );
              if (result != null) {
                if (context.mounted) {
                  BlocProvider.of<BackgroundBloc>(context)
                      .add(ChangeBackground(result));
                }
              }
            },
          );
        } else if (state is BackgroundInitial) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return Container();
      },
    );
  }

  Widget _buildSettingsOption(
      {required String title, required VoidCallback onTap}) {
    return ListTile(
      title: Text(title),
      onTap: onTap,
    );
  }
}
