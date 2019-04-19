import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
class FutureWidget extends StatefulWidget {
  @override
  FutureState createState() => FutureState();
}
class FutureState extends State<FutureWidget> {
  String txt = "";///显示网页内容
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    if(isLoading){///正在加载
      return Scaffold(
         body: Center(child: Text("loading...."),),
      );
    }else{
      return Scaffold(
          body: SingleChildScrollView(///scrollView
            child: Text(txt),
          ));
    }
  }
  @override
  void initState() {
    super.initState();
    //调用getData方法
    getData().then((str){
      if (!mounted) {
        return;
      }
      //刷新页面
      setState(() {
        isLoading=false;
        txt = str;
      });
    },onError: (e){
      print("--请求出错--");
    });
  }

  ///返回网络请求的字符串
  Future<String> getData() async {
    var httpClient =  new HttpClient();
    var request = await httpClient.getUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
    var response = await request.close();
    return await response.transform(utf8.decoder).join();
  }

  ///不使用async和await
  Future<String> getData2() {
    var httpClient =  new HttpClient();
    Future<HttpClientRequest> requestTask =  httpClient.getUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"));

    return requestTask.then((request){
      return request.close();//返回一个Future<HttpClientResponse>
    }).then((response){//操作Future<HttpClientResponse>这个Future返回的值，即HttpClientResponse
      return response.transform(utf8.decoder).join();
    });
  }

  /////////最差的情况:回调地狱(Callback hell)////

  ///先要获取HttpClientRequest对象
  Future<HttpClientRequest> getRequest(HttpClient httpClient){
     return httpClient.getUrl(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
  }

  ///先要获取HttpClientRequest对象
  Future<HttpClientResponse> getResponse(HttpClientRequest request){
    return request.close();
  }

  ///获取数据
  Future<String> loadData(HttpClientResponse response) {
    return response.transform(utf8.decoder).join();
  }

  ///回调地狱(Callback hell)
  Future<String> getData3(){
    var httpClient =  new HttpClient();
   return getRequest(httpClient).then((request){
        return getResponse(request).then((response){
         return loadData(response);
      });
    });
  }
}
