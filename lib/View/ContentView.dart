import 'package:flutter/material.dart';
import 'package:douban_app/Bean/MainViewModel.dart';

class ContentView extends StatelessWidget{

  final Subjects sub;

  ContentView(this.sub);


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(sub.title),
      ),
      body: _body1(),
    );
  }

//  Widget _body(){
//    return ConstrainedBox(
//      constraints: BoxConstraints(
//        maxHeight: 200
//      ),
//      child: Flex(
//        direction: Axis.horizontal,
//        children: <Widget>[
//          Expanded(
//            child: Container(color: Colors.red,),
//            flex: 2,
//          ),
//
//          Expanded(
//            child: Container(color: Colors.green,
//              child: Text('weber'*100),
//            ),
//            flex: 4,
//          ),
//        ],
//      ),
//    );
//  }

  Widget _body1(){
    return ListView(
      children: <Widget>[
        Container(
//          color: Colors.red,
          padding: EdgeInsets.all(13),
          child:Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _image(),
              SizedBox(width: 13.0,),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _title(),
                    _rawTitle(),
                    SizedBox(height: 6.0,),
                    _pubdates(),
                    SizedBox(height: 6.0,),
                    _info(),
                  ],
                ),
              ),
            ],
          ),
        ),

        Container(
//          color: Colors.green,
          height: 210,
          child: _directorsAndCasts(),
        )
      ],
    );
  }


  Widget _body(){
    return Column(
//      direction: Axis.vertical,
      children: <Widget>[
        Expanded(
          child: Container(
//            color: Colors.red,
            padding: EdgeInsets.all(13),
            child:Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _image(),
                SizedBox(width: 13.0,),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _title(),
                      _rawTitle(),
                      SizedBox(height: 6.0,),
                      _pubdates(),
                      SizedBox(height: 6.0,),
                      _info(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          flex: 4,
        ),

        Expanded(
          child: Container(
//            color: Colors.red,
            child: _directorsAndCasts() ,
          ),
          flex: 4,
        ),

        Spacer(flex: 3,),
      ],
    );
  }


  Widget _image(){
    return Container(
      width: 100,
      height: 142,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: NetworkImage(sub.images['small']),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _title(){
    return Text(
      sub.title+'(${sub.year})',
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//      textAlign: TextAlign.start,
      softWrap: true,
    );
  }

  Widget _rawTitle(){
    return Text(
      sub.original_title+'(${sub.year})',
      style: TextStyle(fontSize: 14, color: Colors.grey),
//      textAlign: TextAlign.start,
      softWrap: true,
    );
  }

  Widget _info(){

    String type = sub.genres?.join(' ');
    type += ' / ';
    type += '片长${sub.durations.length!=0 ? sub.durations.first : '--'}';

    return Text(
      type,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }

  Widget _pubdates(){
    String str = '${sub.pubdates.join('上映\n')}上映';

    return Text(
      str,
      style: TextStyle(fontSize: 12, color: Colors.grey),
    );
  }


  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  Widget _directorsAndCasts(){

    List<Casts> casts = sub.directors + sub.casts;

    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(children: <Widget>[SizedBox(width: 13,),Text('影人', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)],) ,
        SizedBox(height: 13,),
        Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: casts.length,
              itemExtent: 100,
              itemBuilder: (context, index) =>
                  _buildRow(context, index, casts[index]),
            )
        )
      ],
    );

  }



  Widget _buildRow(BuildContext context, int index, Casts cast){

    bool isDirector = false;
    if(index < sub.directors.length){
      isDirector = true;
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
      child:  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: FadeInImage.assetNetwork(
              placeholder: 'images/zhanweitu.png',
              image: cast.avatars['small'],
              width: 80, height: 114, fit: BoxFit.fill,)
        ),

        SizedBox(height: 13,),

        //名称
        Text(cast.name, style: TextStyle(fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis,),

        SizedBox(height: 6,),
        //职责
        Text(isDirector?'导演':'演员', style: TextStyle(fontSize: 12, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis,),
      ],
    ),
    );

  }




}