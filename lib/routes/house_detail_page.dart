import 'dart:convert';

import 'package:app/routes/search_page.dart';
import 'package:app/utils/storage.dart';
import 'package:app/widgets/carousel.dart';
import 'package:app/widgets/house_list_nearby.dart';
import 'package:bruno/bruno.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';
import '../utils/result.dart';
import 'map_navigation_page.dart';

class HouseDetail {
  final String title;
  final int pricePerMonth;
  final double squares;
  final String direction;
  final int shiNumber;
  final int tingNumber;
  final int weiNumber;
  final String image;
  final bool isStatic;
  final String community;
  final String district;
  final String longitude;
  final String latitude;
  final String location;
  final String hid;
  final String layout;
  final String compressedImage;
  final String onlineUrl;

  HouseDetail({
    required this.title,
    required this.pricePerMonth,
    required this.squares,
    required this.shiNumber,
    this.direction = '*',
    this.tingNumber = 0,
    this.weiNumber = 0,
    this.image = "",
    this.isStatic = false,
    this.compressedImage = "",
    required this.community,
    required this.district,
    required this.longitude,
    required this.latitude,
    required this.location,
    required this.hid,
    required this.layout,
    required this.onlineUrl,
  });
}

class HouseDetailPage extends StatefulWidget {
  final HouseDetail houseDetail;

  const HouseDetailPage({
    Key? key,
    required this.houseDetail,
  }) : super(key: key);

  @override
  State<HouseDetailPage> createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> {
  var isFavored = false;

  @override
  void initState() {
    _checkFavor(widget.houseDetail.hid).then((value) => {
          setState(() {
            isFavored = value;
          })
        });
    super.initState();
  }

  /*
  * ???????????????????????????????????????????????????
  * */
  Widget _renderWrappedText(String title, String text) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(text),
      ],
    );
  }

  Future<bool> _checkFavor(String hid) async {
    var url =
        Uri.parse('${Constants.backend}/user/checkFavorite?house_id=$hid');
    print(url);
    http.Response response;
    var responseJson;
    Result<String> res2;
    final res = await StorageUtil.getStringItem('token');
    response = await http.post(url, headers: {'Authorization': 'Bearer $res'});
    if (response.statusCode != 200) {
      return false;
    }
    responseJson = json.decode(utf8.decode(response.bodyBytes));
    //print(responseJson);
    res2 = Result.fromJson(responseJson);
    return (res2.code == 200);
  }

  Future<void> _favor(String hid) async {
    var url = Uri.parse('${Constants.backend}/user/favor?house_id=$hid');
    http.Response response;
    var responseJson;
    Result<String> res2;
    StorageUtil.getStringItem('token').then((res) async => {
          if (res == null || res == "")
            {
              Fluttertoast.showToast(
                  msg: "Please login first", gravity: ToastGravity.TOP),
            }
          else
            {
              print('token' + res),
              response = await http
                  .post(url, headers: {'Authorization': 'Bearer $res'}),
              if (response.statusCode != 200)
                {
                  Fluttertoast.showToast(
                    msg: "Login expired! Please login again",
                    backgroundColor: Colors.red,
                    gravity: ToastGravity.TOP,
                  ),
                }
              else
                {
                  responseJson = json.decode(utf8.decode(response.bodyBytes)),
                  res2 = Result.fromJson(responseJson),
                  if (res2.detail != null)
                    {
                      StorageUtil.setStringItem('token', res2.detail ?? ''),
                      // update token
                      setState(() {
                        isFavored = true;
                      })
                    }
                }
            }
        });
  }

  Future<void> _unFavor(String hid) async {
    var url = Uri.parse('${Constants.backend}/user/unFavor?house_id=$hid');
    http.Response response;
    var responseJson;
    Result<String> res2;
    StorageUtil.getStringItem('token').then((res) async => {
          if (res == null || res == "")
            {
              Fluttertoast.showToast(
                  msg: "Please login first", gravity: ToastGravity.TOP),
            }
          else
            {
              response = await http
                  .post(url, headers: {'Authorization': 'Bearer $res'}),
              responseJson = json.decode(utf8.decode(response.bodyBytes)),
              res2 = Result.fromJson(responseJson),
              if (res2.detail != null)
                {
                  StorageUtil.setStringItem('token', res2.detail ?? ''),
                  // update token
                  setState(() {
                    isFavored = false;
                  })
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: "Login expired! Please login again"),
                }
            }
        });
  }

  /*
  * ??????AppBar???????????????????????????????????????????????????
  * ??????https://bruno.ke.com/page/widgets/brn-app-bar ??????8
  * */
  Widget _renderAppBar(BuildContext context) {
    return BrnAppBar(
      automaticallyImplyLeading: true,
      //???icon
      actions: [
        BrnIconAction(
          key: const ValueKey('detail_favorite_button'),
          iconPressed: () {
            if (isFavored) {
              _unFavor(widget.houseDetail.hid);
            } else {
              _favor(widget.houseDetail.hid);
            }
          },
          child: Icon(
            Icons.star_border_outlined,
            color: isFavored ? Colors.amberAccent : Colors.black,
          ),
        ),
        BrnIconAction(
          key: const ValueKey('detail_search_button'),
          iconPressed: () {
            showSearch(
              context: context,
              delegate: SearchBarViewDelegate(),
            );
          },
          child: const Icon(
            Icons.search,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  /*
  * ?????????????????????
  * */

  Widget _renderDetailTexts(HouseDetail houseDetail) {
    return Column(
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: houseDetail.title,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ),
        RichText(
          text: TextSpan(
            text: houseDetail.pricePerMonth.toString(),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 20,
            ),
            children: const [
              TextSpan(
                text: '???/???',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: _renderWrappedText(
                // "${houseDetail.shiNumber}???"
                //     "${houseDetail.tingNumber}???"
                //     "${houseDetail.weiNumber}???",
                houseDetail.layout,
                "??????",
              ),
            ),
            Expanded(
              child: _renderWrappedText(
                "${houseDetail.squares}???",
                "??????",
              ),
            ),
            Expanded(
              child: _renderWrappedText(
                houseDetail.community,
                "??????",
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ??????????????????
  Widget _renderNavigationIcon(BuildContext context) {
    return BrnBottomButtonPanel(
      key: const ValueKey('detail_bottom_buttons'),
      mainButtonName: '?????????',
      mainButtonOnTap: () {},
      secondaryButtonName: '?????????',
      secondaryButtonOnTap: () {
        launchUrl(
          Uri.parse(
            widget.houseDetail.onlineUrl,
          ),
        );
      },
      iconButtonList: [
        //??????Icon??????
        BrnVerticalIconButton(
          key: const ValueKey("detail_navigation_icon"),
          name: '??????',
          iconWidget: const Icon(
            Icons.navigation_outlined,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                settings: const RouteSettings(name: "navigation"),
                builder: (context) => MapNavigationPage(
                  oriLat: '',
                  oriLng: '',
                  desLat: widget.houseDetail.latitude,
                  desLng: widget.houseDetail.longitude,
                  oriText: '????????????',
                  desText: widget.houseDetail.community != ""
                      ? widget.houseDetail.community
                      : widget.houseDetail.location,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _renderAppBar(context),
          renderCarousel(
            List<HouseImage>.generate(
              1,
              (index) => HouseImage(
                  image: widget.houseDetail.image,
                  title: '1',
                  isStatic: widget.houseDetail.isStatic),
            ),
          ),
          _renderDetailTexts(widget.houseDetail),
          Flexible(
            flex: 4,
            child: HouseListNearby(
              lat: widget.houseDetail.latitude,
              lng: widget.houseDetail.longitude,
            ),
          ),
          _renderNavigationIcon(context),
        ],
      ),
    );
  }
}
