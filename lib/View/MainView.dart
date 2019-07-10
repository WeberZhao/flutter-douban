import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:douban_app/Bean/MainViewModel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:douban_app/View/ContentView.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:douban_app/View/CommView.dart';
import 'MoreView.dart';

class MainPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage>{

  List _in_theaters_list = List();
  List _coming_soon_list = [];
  List _new_movies_list = [];
  List _weekly_list = [];
  List _top250_list = [];
  List _us_box_list = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadData();


  }

  _loadData() async{
    _in_theaters_list = await _requestFromServer('https://douban.uieee.com/v2/movie/in_theaters?start=0&count=20');
    setState(() {});
    _coming_soon_list = await _requestFromServer('https://douban.uieee.com/v2/movie/coming_soon?start=0&count=20');
    setState(() {});
    _new_movies_list = await _requestFromServer('https://douban.uieee.com/v2/movie/new_movies?start=0&count=20');
    setState(() {});
    _weekly_list = await _requestFromServer('https://douban.uieee.com/v2/movie/weekly?start=0&count=20', hasSubject: true);
    setState(() {});
    _top250_list = await _requestFromServer('https://douban.uieee.com/v2/movie/top250?start=0&count=20');
    setState(() {});
    _us_box_list = await _requestFromServer('https://douban.uieee.com/v2/movie/us_box?start=0&count=20', hasSubject: true);
    setState(() {});


  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('电影'),
      ),
      body: _in_theaters_list.length == 0 ? _loading() : _body(),
    );
  }

  Widget _loading(){
    return Center(
      child:CircularProgressIndicator(),
    );
  }

  Widget _body(){
    return ListView(
      children: <Widget>[
        _in_theaters(),
        _coming_soon(),
        _new_movies(),
        _weekly(),
        _top250(),
        _us_box(),
      ],
    );
  }

  //正在热映
  Widget _in_theaters(){
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _titleBar('正在热映', url: 'https://douban.uieee.com/v2/movie/in_theaters', subjects: this._in_theaters_list),
          _rowListView(this._in_theaters_list),
        ],
      ),
    );
  }

  //即将上映
  Widget _coming_soon() {
    return Container(
        child: Column(
          children: <Widget>[
            _titleBar('即将上映', url: 'https://douban.uieee.com/v2/movie/coming_soon', subjects: this._coming_soon_list),
            _rowListView(_coming_soon_list),
          ],
        )
    );
  }

  //新片
  Widget _new_movies() {
    return Container(
        height: 210,
        child: Column(
          children: <Widget>[
            _titleBar('新片榜', url: 'https://douban.uieee.com/v2/movie/new_movies',
                subjects: this._new_movies_list, requestMore: false),
            _rowListView(_new_movies_list),
          ],
        )
    );
  }

  //口碑榜单
  Widget _weekly() {
    return Container(
        height: 210,
        child: Column(
          children: <Widget>[
            _titleBar('口碑榜', url: 'https://douban.uieee.com/v2/movie/weekly',
                hasSubject: true, subjects: this._weekly_list, requestMore: false),
            _rowListView(_weekly_list),
          ],
        )
    );
  }


  //top250
  Widget _top250() {
    return Container(
        height: 210,
        child: Column(
          children: <Widget>[
            _titleBar('Top250', url: 'https://douban.uieee.com/v2/movie/top250', subjects: this._top250_list),
            _rowListView(_top250_list),
          ],
        )
    );
  }


  //北美院线
  Widget _us_box() {
    return Container(
        height: 210,
        child: Column(
          children: <Widget>[
            _titleBar('北美院线', url: 'https://douban.uieee.com/v2/movie/us_box',
                hasSubject: true, subjects: this._us_box_list, requestMore: false),
            _rowListView(_us_box_list),
          ],
        )
    );
  }

  Widget _titleBar(String title, {String url, List subjects, bool hasSubject, bool requestMore}){
    return Padding(
      padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
          FlatButton(
            padding: EdgeInsets.all(0),
            disabledTextColor: Colors.grey,
            textColor: Colors.green,
            child: Row(
            children: <Widget>[
              Text('查看更多'),
              Icon(Icons.chevron_right,),
            ],),
            onPressed: url == null ? null : () {
//              _loadData();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) {
                    return MoreView(title, url, subjects: subjects, hasSubject: hasSubject, requestMore: requestMore,);
                  }));
            },
          ),
        ],
      ),
    );
  }

  Widget _rowListView(List items){
    return Container(
        height: 160,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemExtent: 100,
          itemBuilder: (context, index) =>
              _buildRow(context, items[index]),
    )
    );

  }

  Widget _buildRow(BuildContext context, Subjects sub){
    return CommView.subjectView(sub, onTap: (){
      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context){
        return ContentView(sub);
      }));
    });
  }




  Future<List> _requestFromServer(String url, {bool hasSubject = false}) async{
    //https://douban.uieee.com/v2/movie/in_theaters?start=0&count=20

    try {
      Dio dio = Dio();
      Response response = await dio.get(url);

      print(response.data.toString());

      var bean = hasSubject ? _jsonToBean2(response.data) : _jsonToBean(response.data);


//      setState(() {
//        this._in_theaters_list = bean;
//      });

      print('数组长度为：${bean.length}' + bean.toString());

      return bean;
    } catch (e){
      print(e);

      Fluttertoast.showToast(
        msg: e.toString(),
        timeInSecForIos: 3,
      );

      return null;
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

}