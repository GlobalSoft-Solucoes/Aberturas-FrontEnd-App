import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';

class CarouselImages extends StatefulWidget {
  CarouselImages({Key key}) : super(key: key);

  // final String title;
  @override
  _CarouselImagesState createState() => new _CarouselImagesState();
}

final List<String> imgList = [
  'https://imagens-revista.vivadecora.com.br/uploads/2019/03/Modelos-de-portas-de-vidro-de-correr-para-otimizar-o-espa%C3%A7o.jpg',
  'https://imagens-revista.vivadecora.com.br/uploads/2019/03/Os-modelos-de-portas-de-correr-n%C3%A3o-atrapalham-a-circula%C3%A7%C3%A3o-no-ambiente-.jpg',
  'https://imagens-revista.vivadecora.com.br/uploads/2019/03/Os-modelos-de-portas-de-aluminio-s%C3%A3o-leves-e-resistentes-.jpg',
  'https://imagens-revista.vivadecora.com.br/uploads/2019/03/Os-modelos-de-portas-de-abrir-podem-duas-ou-mais-folhas-.jpg',
  'https://imagens-revista.vivadecora.com.br/uploads/2019/03/Os-modelos-de-portas-de-madeira-natural-combinam-com-os-elementos-arquitetonicos-do-im%C3%B3vel-.jpg'
];

class DemoItem extends StatelessWidget {
  final String title;
  final String route;
  DemoItem(this.title, this.route);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pushNamed(context, route);
      },
    );
  }
}

class _CarouselImagesState extends State<CarouselImages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carousel demo'),
      ),
      body: ListView(
        children: <Widget>[
          DemoItem('More complicated image slider', '/complicated'),
        ],
      ),
    );
  }
}

final List<Widget> imageSliders = imgList
    .map((item) => Container(
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                child: Stack(
                  children: <Widget>[
                    Image.network(item, fit: BoxFit.cover, width: 1000.0),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      right: 0.0,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color.fromARGB(200, 0, 0, 0),
                              Color.fromARGB(0, 0, 0, 0)
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 20.0),
                      ),
                    ),
                  ],
                )),
          ),
        ))
    .toList();

class RoloImages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('Complicated image slider demo')),
      body: Container(
          child: Column(
        children: <Widget>[
          CarouselSlider(
            options: CarouselOptions(
              autoPlay: true,
              aspectRatio: 2.0,
              enlargeCenterPage: true,
            ),
            items: imageSliders,
          ),
        ],
      )),
    );
  }
}
