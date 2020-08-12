import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
 


class MovieHorizontal extends StatelessWidget {
  
  final List<Pelicula> peliculas;
  final Function siguientePagina;

  MovieHorizontal({@required this.peliculas,@required this.siguientePagina});

  final _pageController=new PageController(
    initialPage: 1,
          viewportFraction: 0.32,
  );

  @override
  Widget build(BuildContext context) {

    
    final _scrrenSize=MediaQuery.of(context).size;

    _pageController.addListener(() {
      if(_pageController.position.pixels>=_pageController.position.maxScrollExtent-200){
        siguientePagina();
      }
    });

    return Container(
      height: _scrrenSize.height*0.25,
      child: PageView.builder(
        controller:_pageController,
        pageSnapping: false,
        //children: _tarjetas(context),
        itemCount: peliculas.length,
        itemBuilder: (context,i){

          return _tarjeta(context,peliculas[i]);

        },
      ),

    );
  }

  Widget _tarjeta(BuildContext context,Pelicula pelicula){
    final tarjeta= Container(
        margin: EdgeInsets.only(),
        child: Column(
          children: [
            Hero(tag: pelicula.id,
                          child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                            child: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  fit: BoxFit.cover,
                  height: 160.0,
                ),
              ),
            ),
            SizedBox(height: 5,),
            Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style:Theme.of(context).textTheme.caption),
          ],
        ),
      );

      return GestureDetector(
        child: tarjeta,
        onTap: (){
          print('ID de la pelicula ${pelicula.id}');

          Navigator.pushNamed(context,'detalle',arguments:pelicula);
        }
      );

  }

  List<Widget> _tarjetas(BuildContext context){

    return peliculas.map((pelicula){

      return Container(
        margin: EdgeInsets.only(),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
                          child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5,),
            Text(pelicula.title,
            overflow: TextOverflow.ellipsis,
            style:Theme.of(context).textTheme.caption),
          ],
        ),
      );
    }).toList();

  }
}




