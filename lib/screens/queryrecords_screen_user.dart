import 'package:flutter/material.dart';
import 'package:leadoneattendance/models/models.dart';
import 'package:leadoneattendance/themes/app_themes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:leadoneattendance/screens/screens.dart';
import '../themes/app_themes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<QueryRecord> fetchQueryRecord() async {
  //Los siguientes, son los parámetros utilizados para cargar un registro.
  var UserID = 1;
  var RecordTypeID = 1;
  var RecordDate = "2022-04-29";
  var s = UserID.toString() + "/" + RecordDate + "/" + RecordTypeID.toString();
  // var s = UserID.toString() + RecordDate + RecordTypeID.toString();

//http request GET
  final response = await http.get(Uri.parse('https://3a51-45-65-152-57.ngrok.io/get/record/$s'));
  if (response.statusCode == 200) {
    return QueryRecord.fromJson(jsonDecode(response.body)[0]);
    //El [0], es para ignorar que el json no tiene una cabecera tipo RECORD.
  } else {
    throw Exception('Failed to load record.');
  }
}

class QueryRecordsScreenUser extends StatefulWidget {
  const QueryRecordsScreenUser({Key? key}) : super(key: key);

  @override
  State<QueryRecordsScreenUser> createState() => _QueryRecordsScreenUserState();
}

class _QueryRecordsScreenUserState extends State<QueryRecordsScreenUser> {
  late Future<QueryRecord> futureQueryRecord;
  DateTime valueRegistro = DateTime.parse('0000-00-00');
  DateTime selectedDate = DateTime.now();
  final firstDate = DateTime(2022, 2); //A partir de que fecha funciona el calendario
  final lastDate = DateTime.now(); //Hasta que fecha funciona el calendario

  @override
  void initState() {
    super.initState();
    futureQueryRecord = fetchQueryRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('queryrecords.title').tr(),
          centerTitle: true,
          actions: const []),
      body: Column(
        children: [
          CalendarDatePicker(
            initialDate: selectedDate, //Fecha por default, será la actual.
            firstDate: firstDate, //Desde que fecha funciona el calendario.
            lastDate: lastDate, //Hasta que fecha funciona el calendario.
            onDateChanged: (DateTime valueRegistro) {
              setState(() {
              
              });
            }, // Si la fecha cambia.
          ),
          //BOTON DE GUARDAR CAMBIOS
            TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 15, 49, 114),
                    primary: Colors.white, //TEXT COLOR
                    minimumSize: const Size(120, 50) //TAMANO - WH
                    ),
                onPressed: () {
                  setState(() {});
                  var newRecordDate = DateFormat('yyyy-MM-dd').format(valueRegistro);

                  
                },
                child: const Text('Save and Print')),
          Row(
            children: [
              const Text('queryrecords.recentRecords',
                      style: TextStyle(fontSize: 20))
                  .tr()
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),

          const SizedBox(
            height: 10,
          ),

//NOTE Esta sección, es el listtile que carga el registro seleccionado.
          FutureBuilder<QueryRecord>(
            future: futureQueryRecord,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      //ListTile que muestra la fecha y texto Record Date del registro consultado.
                      ListTile(
                          title: Text((convertirFecha(
                              snapshot.data!.recordDate))), //fecha del registro
                          trailing: Wrap(
                            spacing: 12, // space between two icons
                            children: <Widget>[
                              const Icon(
                                Icons.arrow_upward_outlined,
                                color: AppTheme.green,
                              ), // icon-1
                              Text(
                                ((convertirHora(snapshot.data!.entryTime))),
                                style: const TextStyle(
                                    fontSize: 18), //hora de entrada
                              ),
                              const Icon(
                                Icons.arrow_downward_outlined,
                                color: AppTheme.red,
                              ), // icon-2
                              Text(
                                ((convertirHora(snapshot.data!.exitTime))),
                                style: const TextStyle(
                                    fontSize: 18), //hora de salida
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    const DisplayRecordScreenUser()));
                          })
                    ],
                  ),
                );
              } else {
                //NOTE En lo que carga o detecta el registro, aparecerá este Circular Progress Indicator.
                return const CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }

//ANCHOR METODOS Y OTRAS COSAS
  //NOTE: Método para convertir 17:30:00 a 17:30
  String convertirHora(String hora) {
    final tiempo = hora.split(':');
    String tiempoFinal = "${tiempo[0]}:${tiempo[1]}";
    //debugPrint(tiempoFinal); Imprime en consola las horas obtenidas.
    //resultado= 17:30
    return tiempoFinal;
  }

//NOTE: Método para convertir 2022-04-08T05:00:00.000Z a Abril 8, 2022
  String convertirFecha(String fecha) {
    String date = fecha;
    String? mes;
    String? fechaFinal;
    final parsearFecha = DateTime.parse(date);
    //final formatoFecha = DateFormat('MMMM dd, yyyy').format(parsearFecha);
    switch (parsearFecha.month) {
      case 01:
        mes = 'Jan';
        break;
      case 02:
        mes = 'Feb';
        break;
      case 03:
        mes = 'Mar';
        break;
      case 04:
        mes = 'Apr';
        break;
      case 05:
        mes = 'May';
        break;
      case 06:
        mes = 'Jun';
        break;
      case 07:
        mes = 'Jul';
        break;
      case 08:
        mes = 'Aug';
        break;
      case 09:
        mes = 'Sep';
        break;
      case 10:
        mes = 'Oct';
        break;
      case 11:
        mes = 'Nov';
        break;
      case 12:
        mes = 'Dec';
        break;
      default:
    }

    fechaFinal = "$mes ${parsearFecha.day}, ${parsearFecha.year}";
    // debugPrint(fechaFinal);  Imprime en consola las fechas obtenidas.
    //resultado: Abril 8, 2022
    return fechaFinal;
  }

  Future<void> loadrecord(DateTime valueRegistro) async{
    try{

      var RecordDate = valueRegistro.toString();
      var url = 'serverurl';
      var response = await http.post(Uri.parse(url), 
      body:
        {
          'UserID' : 1,
          'RecordDate': RecordDate
        }).timeout(const Duration(seconds: 30));

        var datos = jsonDecode(response.body);
        debugPrint(datos);
        if(response.body != '0'){
              fetchQueryRecord();
              debugPrint('Datos enviados exitosamente.');
        } else{
          //Cuadro de diálogo que indica que los datos son incorrectos.
          debugPrint('Hubo un problema.');
          
        }
    }  on Error {
      debugPrint('Http error.');
    }
  }
}