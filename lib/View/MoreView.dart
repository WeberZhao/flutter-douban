import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:douban_app/Bean/MainViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:douban_app/View/ContentView.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MoreView extends StatefulWidget{

  final String url;
  final String title;
  final List subjects;
  final bool hasSubject;
  final bool requestMore;

  MoreView(this.title, this.url, {this.subjects, this.hasSubject = false, this.requestMore = true});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MoreViewState();
  }
}

class _MoreViewState extends State<MoreView>{

  List datas = List();


  bool error = false;

  int errorCount = 0;

  int start = 0;
  int count = 20;
  int total = 0;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    viewappear = true;
//    print('简况界面出现了');

    datas.addAll(widget.subjects);
    start = widget.subjects.length;

    if(start == 0 && widget.requestMore) //不请求更多
      _requestFromServer();

//      _readFromLocal();

  }



  _readFromLocal() async{
    error = false;
    try {
      final String str = await DefaultAssetBundle.of(context).loadString(
          'data/data.json');

      Map jsonMap = json.decode(str);

      var bean = _jsonToBean(jsonMap);

      setState(() {
        this.datas = bean;
      });

      print('数组长度为：${bean.length}' + bean.toString());
    }catch(e){
      print(e);

      if(datas.length == 0){
        setState(() {
          error = true;
        });
      }

      Fluttertoast.showToast(
        msg: e.toString(),
        timeInSecForIos: 3,
      );
    }
  }


  _requestFromServer() async{
    //https://douban.uieee.com/v2/movie/in_theaters?start=0&count=20

    if(total != 0 && this.start >= total){
      print('没有更多数据了');
      return;
    }

    try {
      Dio dio = Dio();
      Response response = await dio.get(
          '${widget.url}?start=${start}&count=${20}');

//      'https://douban.uieee.com/v2/movie/in_theaters?start=${start}&count=${20}'

      print(response.data.toString());

      var bean = widget.hasSubject ? _jsonToBean2(response.data) : _jsonToBean(response.data);

      this.total = (response.data['total'] as num).toInt();
      this.start += bean.length;

      setState(() {
        this.datas.addAll(bean);
      });

      print('总长度为：${this.datas.length} 数组长度为：${bean.length}' + bean.toString());
    } catch (e){
      print(e);

      if(datas.length == 0){
        errorCount++;
        setState(() {
          error = true;
        });
      }

      Fluttertoast.showToast(
        msg: e.toString(),
        timeInSecForIos: 3,
      );
    }
  }

  List _jsonToBean(Map jsonObj){

    List datas = [];
    for(Map m in jsonObj['subjects']){
      Subjects sub = Subjects.fromJson(m);
      datas.add(sub);
    }

    return datas;
  }

  List _jsonToBean2(Map jsonObj){

    List datas = [];
    for(Map m in jsonObj['subjects']){
      Subjects sub = Subjects.fromJson(m['subject']);
      datas.add(sub);
    }

    return datas;
  }



  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: datas.length == 0 ?  Center(
          child: this.error ? _flatButton() : CircularProgressIndicator(),
        ) : _gridView()
    );
  }

  Widget _flatButton(){
    return FlatButton(
        onPressed: () {
          if (this.errorCount >= 3) {
            _readFromLocal();
          } else {
            _requestFromServer();
          }
          setState(() {

          });
        },

        child: Text('获取失败，点击重试',
          style: TextStyle(color: Colors.blue),)
    );
  }

  Widget _gridView(){
    return GridView.builder(
        itemCount: datas.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.7
        ),
        itemBuilder: (context, index){
          if( index >= datas.length-1){

            if(!(total != 0 && this.start >= total) && widget.requestMore) {
              print('到底了，去请求');
              _requestFromServer();

              //加载时显示loading
              return Container(
                padding: const EdgeInsets.all(16.0),
                alignment: Alignment.center,
                child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(strokeWidth: 2.0)
                ),
              );
            }

          }
          return _buildCell(context, index);
        }
    );
  }


  Widget _buildCell(BuildContext context, int index){

    Subjects sub = this.datas[index];

    return InkWell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[

          ///没有占位图的带圆角图片
//          Container(
//            width: 80,
//            height: 114,
//            decoration: BoxDecoration(
//              borderRadius: BorderRadius.circular(4),
//              image: DecorationImage(
//                image: NetworkImage(sub.images['small']),
//                fit: BoxFit.fill,
//              ),
//            ),
////            child:Image.network(sub.images['small'], width: 80, height: 114, fit: BoxFit.fill,),
//          ),

          ///带占位图的带圆角图片
          ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/zhanweitu.png',
                image: sub.images['small'],
                width: 80, height: 114, fit: BoxFit.fill,)
          ),

//          ///带占位图的带圆角图片
//          ClipRRect(
//              borderRadius: BorderRadius.circular(4),
//              child: CachedNetworkImage(
//                imageUrl: sub.images['small'],
//                placeholder: (context, url) => Image.asset('images/zhanweitu.png', width: 80, height: 114,),
//                errorWidget: (context, url, error) => new Icon(Icons.error),
//                width: 80, height: 114, fit: BoxFit.fill,
//              ),
//          ),



          SizedBox(height: 2.0,),

          ///title

          Padding(padding: EdgeInsets.symmetric(horizontal: 6), child:
          Text(sub.title, style: TextStyle(fontSize: 12.0), maxLines: 1, overflow: TextOverflow.ellipsis,),),

          ///sub title
          sub.rating.average == 0 ? _noRating(sub) : _ratingBar(sub),
        ],
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
          return ContentView(sub);
        }));
      },
    );
  }

  Widget _noRating(Subjects subject){
    DateTime now =  DateTime.now();
    now.year;
    now.month;
    now.day;

    List pub = subject.mainland_pubdate.split('-');

    bool before = false;
    if(pub.length == 3){
      before = int.tryParse(pub[0]) >= now.year;
      before = before && (int.tryParse(pub[1]) >= now.month);
      before = before && (int.tryParse(pub[2]) > now.day);
    }

//    print('${now}, ${pub.toString()}');


    return Text(before ? '尚未上映' : '暂无评分', style: TextStyle(color: Colors.grey[600], fontSize: 12.0));
  }


  Widget _ratingBar(Subjects subject){

    final double rating = subject.rating.average / subject.rating.max.toDouble() * 5.0;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FlutterRatingBarIndicator(
          itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
          rating: rating,
          itemCount: 5,
          itemSize: 12.0,
          emptyColor: Colors.grey.withAlpha(50),
        ),

        SizedBox(width: 2.0,),

        Text('${subject.rating.average}', style: TextStyle(color: Colors.grey[600], fontSize: 12.0)),
      ],
    );

  }


}