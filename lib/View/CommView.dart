import 'package:flutter/material.dart';
import 'package:douban_app/Bean/MainViewModel.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CommView{

  static Widget subjectView(Subjects sub, {GestureTapCallback onTap}){
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
        onTap: onTap,
      );
    }

  static Widget _noRating(Subjects subject){
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


  static Widget _ratingBar(Subjects subject){

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