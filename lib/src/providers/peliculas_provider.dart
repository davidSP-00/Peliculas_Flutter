import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:peliculas/src/models/pelicula_model.dart';

class PeliculasProvider{

String _apikey='c1e057a048ef03ae1eaba4b2ccb74121';
String _url='api.themoviedb.org';

String _languaje='es';

int _popularesPage=0;
bool _cargando=false;

List<Pelicula> _populares=new List();

final _popularesStreamController =StreamController<List<Pelicula>>.broadcast();


Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;


Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;



void disposeStreams(){
  _popularesStreamController?.close();
}


Future<List<Pelicula>> _procesarRespuesta(Uri url) async{


  final resp=await http.get(url);

  final decodecData=json.decode(resp.body);

  final peliculas=new Peliculas.fromJsonList(decodecData['results']);

  return peliculas.items;
}

Future<List<Pelicula>> getEnCines() async{
  
  final url=Uri.https(_url ,'3/movie/now_playing',{
'api_key': _apikey,
'languaje':_languaje,

  });
  return await _procesarRespuesta(url);
}
Future<List<Pelicula>> getPopulares() async{
if(_cargando)return[];

_cargando=true;
_popularesPage++;



  final url=Uri.https(_url, '3/movie/popular',{
    'api_key':_apikey,
    'languaje':_languaje,
    'page':_popularesPage.toString()
  });

  final resp= await _procesarRespuesta(url);
  

_populares.addAll(resp);
popularesSink(_populares);

_cargando=false;
return resp;

}


}