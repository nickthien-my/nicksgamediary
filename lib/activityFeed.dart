
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<ActivityData>> fetchActivityData(http.Client client) async {
  final response = await client
      .get(Uri.parse('https://raw.githubusercontent.com/nickthien-my/games/master/data/activities.json'));

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseActivityData, response.body);
}

// A function that converts a response body into a List<Photo>.
List<ActivityData> parseActivityData(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<ActivityData>((json) => ActivityData.fromJson(json)).toList();
}

class ActivityData {
  final String activityDate;
  final String gameLogo;
  final String gameName;
  final String trophyName;
  final String caption;
  final int screenshotName;

  const ActivityData({
    required this.activityDate,
    required this.gameLogo,
    required this.gameName,
    required this.trophyName,
    required this.caption,
    required this.screenshotName,
  });

  factory ActivityData.fromJson(Map<String, dynamic> json) {
    return ActivityData(
      activityDate: json['activityDate'] as String,
      gameLogo: json['gameLogo'] as String,
      gameName: json['gameName'] as String,
      trophyName: json['trophyName'] as String,
      caption: json['caption'] as String,
      screenshotName: json['screenshotName'] as int,
    );
  }
}

class ActivityFeed extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ActivityData>>(
      future: fetchActivityData(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('An error has occurred!'),
          );
        } else if (snapshot.hasData) {
          return ActivityList(activityentry: snapshot.data!);
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({Key? key, required this.activityentry}) : super(key: key);

  final List<ActivityData> activityentry;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: activityentry.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Image.network(
                              'https://raw.githubusercontent.com/nickthien-my/games/master/assets/assets/gameLogos/' + activityentry[index].gameLogo + '.png'
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: 'Earned ',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: activityentry[index].trophyName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: ' trophy.',
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                  activityentry[index].gameName + ' - ' + activityentry[index].activityDate,
                                  style: const TextStyle(
                                      color: Colors.grey
                                  )
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Image.network(
                    'https://raw.githubusercontent.com/nickthien-my/games/master/assets/assets/screenshots/' "${activityentry[index].screenshotName}" '.png',
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Center(
                      child: Text(
                        activityentry[index].caption,
                      ),
                    ),
                  ),
                ],
              ),
          );
        }
    );
  }
}