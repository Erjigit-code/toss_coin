import 'package:coin_flip/bloc/UserProfile_bloc/user_profile_bloc.dart';
import 'package:coin_flip/screens/user_record_screen/get_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:hive/hive.dart';

import 'widgets/prediction_buttons_widget.dart';

import '../background/widgets/background_widget.dart';
import 'widgets/coin_flip2.dart';
import 'widgets/result_container_widget.dart';
import 'widgets/score_container_widget.dart';
import 'widgets/сoin_flip_animation.dart';
import '../../bloc/background_bloc/background_bloc.dart';
import '../settings_screen/settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen>
    with AutomaticKeepAliveClientMixin {
  String? result;
  String? userPrediction;
  String? activeButton;
  ImageProvider? backgroundImage;
  String? currentUserNickname;
  String? currentUserAvatarUrl;
  final GlobalKey<CoinFlipAnimationState> _coinFlipKey =
      GlobalKey<CoinFlipAnimationState>();

  @override
  void initState() {
    super.initState();
    _preloadBackgroundImage();
    context.read<UserProfileBloc>().add(LoadUserProfile());
  }

  Future<void> _preloadBackgroundImage() async {
    final box = Hive.box('settings');
    final backgroundImagePath =
        box.get('backgroundImage', defaultValue: 'assets/images/school.jpeg');

    if (backgroundImagePath.startsWith('assets/')) {
      setState(() {
        backgroundImage = AssetImage(backgroundImagePath);
      });
    } else {
      final file =
          await DefaultCacheManager().getSingleFile(backgroundImagePath);
      setState(() {
        backgroundImage = FileImage(file);
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    BlocProvider.of<BackgroundBloc>(context).stream.listen((state) async {
      if (state is BackgroundsLoaded) {
        if (state.selectedPath.startsWith('assets/')) {
          setState(() {
            backgroundImage = AssetImage(state.selectedPath);
          });
        } else {
          final file =
              await DefaultCacheManager().getSingleFile(state.selectedPath);
          setState(() {
            backgroundImage = FileImage(file);
          });
        }
      }
    });
  }

  @override
  void didUpdateWidget(MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return _buildScaffold(context);
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: BlocBuilder<UserProfileBloc, UserProfileState>(
          builder: (context, state) {
            if (state is UserProfileLoaded) {
              return Row(
                children: [
                  SizedBox(
                    height: 40,
                    width: 40,
                    child: ClipOval(
                      child: getImageWidget(state.avatarUrl),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    state.nickname,
                    style: TextStyle(color: Colors.white, fontFamily: 'Exo'),
                  ),
                ],
              );
            } else if (state is UserProfileLoading) {
              return CircularProgressIndicator();
            } else {
              return const Text('User Records');
            }
          },
        ),
        backgroundColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            color: Colors.white,
            onPressed: () async {
              final selectedBackground = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsScreen(
                    initialSelectedImage:
                        (BlocProvider.of<BackgroundBloc>(context).state
                                as BackgroundsLoaded)
                            .selectedPath,
                  ),
                ),
              );
              if (selectedBackground != null) {
                BlocProvider.of<BackgroundBloc>(context)
                    .add(ChangeBackground(selectedBackground));
              }
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (backgroundImage != null)
            BackgroundWidget(backgroundImage: backgroundImage!),
          Padding(
            padding: const EdgeInsets.only(top: kToolbarHeight + 16.0),
            child: Center(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: kToolbarHeight),
                  ScoreContainerWidget(),
                  const Spacer(),
                  const SizedBox(height: 110),
                  CoinFlipAnimationWidget(
                    coinFlipKey: _coinFlipKey,
                    updateResult: updateResult,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
          if (result != null) ResultContainerWidget(result: result!),
          PredictionButtonsWidget(
            activeButton: activeButton,
            onPredictionSelected: startCoinFlip,
          ),
        ],
      ),
    );
  }

  void updateResult(String newResult) {
    setState(() {
      result = newResult;
    });
  }

  void startCoinFlip(String prediction) {
    setState(() {
      userPrediction = prediction;
      activeButton = prediction;
    });
    _coinFlipKey.currentState?.flipCoin(prediction);
  }
}
