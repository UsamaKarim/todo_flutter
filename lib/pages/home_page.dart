import 'package:dribble_ui/data/ad_helper.dart';
import 'package:dribble_ui/models/todo.dart';
import 'package:dribble_ui/models/todo_item.dart';
import 'package:dribble_ui/state/todo_provider.dart';
import 'package:dribble_ui/utils/contants.dart';
import 'package:dribble_ui/widgets/todo_item_widget.dart';
import 'package:dribble_ui/widgets/todo_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

const _maxTriesUponAdLoadingFailed = 3;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BannerAd _bottomBannerAd;
  late BannerAd _inlineBannerAd;
  InterstitialAd? _interstitialAd;

  bool _isBottomAdLoaded = false;
  bool _isInlineAdLoaded = false;

  final controller = TextEditingController();

  final _inlineAdIndex = 2;
  int _interstitialAdLoadAttempts = 0;

  Future<void> createBottomBannerAd() async {
    _bottomBannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          _isBottomAdLoaded = true;
        }),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    );
    await _bottomBannerAd.load();
  }

  Future<void> createInlineBannerAd() async {
    _inlineBannerAd = BannerAd(
      size: AdSize.mediumRectangle,
      adUnitId: AdHelper.bannerAdUnitId,
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() {
          _isInlineAdLoaded = true;
        }),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
      request: const AdRequest(),
    );
    await _inlineBannerAd.load();
  }

  int getInlineAdDifferenciateIndex(int index) {
    if (_isInlineAdLoaded && index >= _inlineAdIndex) {
      return index - 1;
    }
    return index;
  }

  Future<void> createInterstitialAd() async {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: ((ad) {
          _interstitialAd = ad;
          _interstitialAdLoadAttempts = 0;
          // throw LoadAdError(code, domain, message, responseInfo)
        }),
        onAdFailedToLoad: ((error) {
          _interstitialAd = null;
          _interstitialAdLoadAttempts += 1;
          if (_interstitialAdLoadAttempts <= _maxTriesUponAdLoadingFailed) {
            createInterstitialAd();
          }
        }),
      ),
    );
  }

  Future<void> showInterstitialAd() async {
    if (_interstitialAd != null) {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
          overlays: []);
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) async {
          await ad.dispose();
          await createInterstitialAd();
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
        },
        onAdFailedToShowFullScreenContent: (ad, error) async {
          await ad.dispose();
          await createInterstitialAd();
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values);
        },
      );
      await _interstitialAd!.show();
    }
  }

  @override
  void initState() {
    super.initState();
    createBottomBannerAd();
    createInlineBannerAd();
    createInterstitialAd();
  }

  @override
  void dispose() {
    controller.dispose();
    _bottomBannerAd.dispose();
    _inlineBannerAd.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      persistentFooterButtons: [
        if (_isBottomAdLoaded)
          Center(
            child: SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            ),
          )
      ],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'TODAY',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'January 28',
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Colors.black45,
              size: 16,
            )
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Consumer<TodoProvider>(
              builder: (context, todo, child) {
                return ListView.builder(
                  itemCount:
                      todo.listOfTodos.length + 1 + (_isInlineAdLoaded ? 1 : 0),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemBuilder: ((context, index) {
                    if (index ==
                        todo.listOfTodos.length + (_isInlineAdLoaded ? 1 : 0)) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TodoTextField(
                          controller: controller,
                          addTodo: addTodo,
                          hintText: 'Add a new Todo',
                        ),
                      );
                    }
                    if (_isInlineAdLoaded && _inlineAdIndex == index) {
                      return SizedBox(
                        width: _inlineBannerAd.size.width.toDouble(),
                        height: _inlineBannerAd.size.height.toDouble(),
                        child: AdWidget(ad: _inlineBannerAd),
                      );
                    }
                    final color = randomColors[index % randomColors.length];
                    return TodoItemWidget(
                      barColor: color,
                      todo: todo
                          .listOfTodos[getInlineAdDifferenciateIndex(index)],
                    );
                  }),
                );
              },
            ),
          ),

          // const SizedBox(
          //   height: 10,
          // )
        ],
      ),
    );
  }

  Future<void> addTodo() async {
    await showInterstitialAd();
    if (mounted) {
      if (controller.text.isNotEmpty) {
        final todo = Todo(
          todoItem: TodoItem(
            id: const Uuid().v4(),
            name: controller.text,
          ),
        );
        context.read<TodoProvider>().addTodo(todo);
        controller.text = '';
        FocusScope.of(context).unfocus();
      }
    }
  }
}
