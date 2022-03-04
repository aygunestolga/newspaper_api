import 'package:flutter/material.dart';
import 'package:newspaper_api/models/article_models.dart';
import 'package:newspaper_api/network/network_enums.dart';
import 'package:newspaper_api/network/network_service.dart';
import 'package:newspaper_api/network/query_helper.dart';
import 'package:newspaper_api/services/service.dart';
import 'package:newspaper_api/widgets/article_widget.dart';

import 'network/query_param.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('NewsPaper For Human'),
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (context,snapshot){
            if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){

              final List<Article> articles = snapshot.data as List<Article>;
              return ListView.builder(
                itemBuilder: (context, index){
                  return ArticleWidget(article: articles[index]);
                },
                itemCount: articles.length,
              );
            } else if(snapshot.hasError){
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 25,
                    ),
                    SizedBox(height: 10,),
                    Text('Something went wrong'),
                  ],
                ),
              );
            }
            return const Center(child: CircularProgressIndicator(),);
          },
        ),
      ),
    );
  }

 Future<List<Article>?> getData() async {

    final response = await NetworkService.sendRequest(
        requestType: RequestType.get,
        url: Service.apiURL,
        queryParam: QP.apiQP(
            apiKey: Service.apiKey,
            country: Service.apiCountry
        )
    );

    print(response?.statusCode);

    return NetworkHelper.filterResponse(
        callBack: _listOfArticleFromJson,
        response: response,
        parameterName: CallBackParameterName.articles,
        onFailureCallBackWithMessage: (errorType, msg){
          print('Error Teype -$errorType - Message $msg');
          return null;
        }
    );
 }
}

List<Article> _listOfArticleFromJson(json) => (json as List)
    .map((e) => Article.fromJson(e as Map<String, dynamic>))
    .toList();

