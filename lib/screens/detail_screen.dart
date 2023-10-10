import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toonflix2/models/webtoon_detail_model.dart';
import 'package:toonflix2/models/webtoon_episode_model.dart';
import 'package:toonflix2/models/webtoon_model.dart';
import 'package:toonflix2/services/api_service.dart';
import 'package:toonflix2/widgets/episode_widget.dart';

class DetailScreen extends StatefulWidget {
  final WebtoonModel webtoon;

  const DetailScreen({
    super.key,
    required this.webtoon,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Future<WebtoonDetailModel> detail;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences pref;
  bool isLike = false;

  Future initPrefs() async {
    pref = await SharedPreferences.getInstance();
    final likedToons = pref.getStringList('likedToons');
    if (likedToons != null) {
      if (likedToons.contains(widget.webtoon.id)) {
        setState(() {
          isLike = true;
        });
      }
    } else {
      pref.setStringList('likedToons', []);
    }
  }

  void onLikeTap() async {
    final likedToons = pref.getStringList('likedToons');
    if (likedToons != null) {
      if (isLike) {
        likedToons.remove(widget.webtoon.id);
      } else {
        likedToons.add(widget.webtoon.id);
      }
    }
    await pref.setStringList('likedToons', likedToons!);
    setState(() {
      isLike = !isLike;
    });
  }

  @override
  void initState() {
    super.initState();
    detail = ApiService.getToonById(widget.webtoon.id);
    episodes = ApiService.getEpisodeById(widget.webtoon.id);
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: onLikeTap,
              icon: isLike
                  ? const Icon(Icons.favorite_rounded)
                  : const Icon(Icons.favorite_outline_rounded)),
        ],
        elevation: 0.1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
          widget.webtoon.title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.webtoon.id,
                    child: Container(
                      width: 250,
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 5,
                            offset: const Offset(2, 6),
                            color: Colors.black.withOpacity(0.2),
                          ),
                        ],
                      ),
                      child: Image.network(
                        widget.webtoon.thumb,
                        headers: const {
                          'User-Agent':
                              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36',
                          'Referer': 'https://comic.naver.com',
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: detail,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          snapshot.data!.about,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Text(
                          '${snapshot.data!.genre} / ${snapshot.data!.age}',
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return const Text("...");
                },
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        for (var episode in snapshot.data!)
                          Episode(
                              episode: episode, webtoonId: widget.webtoon.id),
                      ],
                    );
                  }
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
