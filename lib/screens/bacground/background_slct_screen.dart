import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/background_bloc.dart';

class BackgroundSelectionScreen extends StatelessWidget {
  final String initialSelectedImage;

  const BackgroundSelectionScreen(
      {super.key, required this.initialSelectedImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Выбор Фона"),
      ),
      body: BlocBuilder<BackgroundBloc, BackgroundState>(
        builder: (context, state) {
          if (state is BackgroundsLoaded) {
            return GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 30,
                crossAxisSpacing: 16,
                childAspectRatio: 0.6,
              ),
              itemCount: state.backgrounds.length,
              itemBuilder: (context, index) {
                final background = state.backgrounds[index];
                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<BackgroundBloc>(context)
                        .add(ChangeBackground(background['path']!));
                    Navigator.pop(context, background['path']!);
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(background['path']!),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(8),
                          border: state.selectedPath == background['path']
                              ? Border.all(
                                  color: Colors.white.withOpacity(0.7),
                                  width: 5)
                              : null,
                        ),
                      ),
                      if (state.selectedPath == background['path'])
                        Icon(
                          Icons.check_circle,
                          color: Colors.white.withOpacity(0.7),
                          size: 100,
                        ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
