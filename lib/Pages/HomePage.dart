import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late var _formKey = GlobalKey<FormState>();

  final TextEditingController realBrasileiroController =
      TextEditingController();
  final TextEditingController dolarUSAController = TextEditingController();
  final TextEditingController euroController = TextEditingController();
  final TextEditingController pesoChilenoController = TextEditingController();
  final TextEditingController JPYController = TextEditingController();

  double dolar = 0;
  double euro = 0;
  double clp = 0;
  double jpy = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Map>(
        future: getApi(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return const Center(
                child: Text(
                  "Aguardando",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                  ),
                  textAlign: TextAlign.center,
                ),
              );

            default:
              if (snapshot.hasError) {
                return const Center(
                  child: Text(
                    "Erro ao carregar dados",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              } else {
                clp = double.tryParse(snapshot.data!["CLPBRL"]["bid"]) ?? 0.0;
                dolar = double.tryParse(snapshot.data!["USDBRL"]["bid"]) ?? 0.0;
                euro = double.tryParse(snapshot.data!["EURBRL"]["bid"]) ?? 0.0;
                jpy = double.tryParse(snapshot.data!["JPYBRL"]["bid"]) ?? 0.0;
                //print(priceCoin.toStringAsPrecision(2));
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: buildTextForm(
                                      "Real Brasileiro",
                                      "BRL ",
                                      realBrasileiroController,
                                      false,
                                      realChange),
                                ),
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: buildTextForm("Dolár USD", "\$ ",
                                      dolarUSAController, false, dolarChange),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: buildTextForm("Euro", "€ ",
                                      euroController, true, euroChange),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: buildTextForm(
                                      "Peso Chileno",
                                      "CLP ",
                                      pesoChilenoController,
                                      false,
                                      pesoChilenoChange),
                                )
                              ],
                            ),
                            const Divider(
                              color: Colors.black,
                              height: 30,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: buildTextForm("Iene Japonês", "¥ ",
                                      JPYController, false, jpyChange),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
          }
        },
      ),
    ));
  }

  void realChange(String text) {
    if(text.isEmpty){
      zerarCampos();
    }
    String textConvert = text.replaceAll(",", ".");
    double real = double.tryParse(textConvert) ?? 0.0;
    dolarUSAController.text = (real / dolar).toStringAsPrecision(2);
    euroController.text = (real / euro).toStringAsPrecision(2);
    pesoChilenoController.text = (real / clp).toStringAsFixed(2);
    JPYController.text = (real / jpy).toStringAsFixed(2);
  }

  void dolarChange(String text) {
    if(text.isEmpty){
      zerarCampos();
    }
    String textConvert = text.replaceAll(",", ".");
    double dolar = double.tryParse(textConvert) ?? 0.0;
    realBrasileiroController.text = (this.dolar * dolar).toStringAsFixed(2);
    euroController.text = (this.dolar * dolar / euro).toStringAsPrecision(2);
    pesoChilenoController.text = (this.dolar * dolar / clp).toStringAsFixed(2);
    JPYController.text = (this.dolar * dolar / jpy).toStringAsFixed(2);
  }

  void euroChange(String text) {
    if(text.isEmpty){
      zerarCampos();
    }
    String textConvert = text.replaceAll(",", ".");
    double euro = double.tryParse(textConvert) ?? 0.0;
    dolarUSAController.text = (this.euro * euro / dolar).toStringAsPrecision(2);
    realBrasileiroController.text = (this.euro * euro).toStringAsFixed(2);
    pesoChilenoController.text = (this.euro * euro / clp).toStringAsFixed(2);
    JPYController.text = (this.euro * euro / jpy).toStringAsFixed(2);
  }

  void pesoChilenoChange(String text) {
    if(text.isEmpty){
      zerarCampos();
    }
    String textConvert = text.replaceAll(",", ".");
    double clp = double.tryParse(textConvert) ?? 0.0;
    euroController.text = (this.clp * clp / euro).toStringAsPrecision(2);
    dolarUSAController.text = (this.clp * clp / dolar).toStringAsPrecision(2);
    realBrasileiroController.text = (this.clp * clp).toStringAsFixed(2);
    JPYController.text = (this.clp * clp / jpy).toStringAsFixed(2);
  }

  void jpyChange(String text) {
    if(text.isEmpty){
      zerarCampos();
    }
    String textConvert = text.replaceAll(",", ".");
    double jpy = double.tryParse(textConvert) ?? 0.0;
    euroController.text = (this.jpy * jpy / euro).toStringAsPrecision(2);
    dolarUSAController.text = (this.jpy * jpy / dolar).toStringAsPrecision(2);
    realBrasileiroController.text = (this.jpy * jpy).toStringAsFixed(2);
    pesoChilenoController.text = (this.euro * euro / clp).toStringAsFixed(2);
  }

  Future<Map> getApi() async {
    String apiConvert =
        "https://economia.awesomeapi.com.br/json/last/USD-BRL,CLP-BRL,EUR-BRL,JPY-BRL";
    http.Response response = await http.get(Uri.parse(apiConvert));
    return json.decode(response.body);
  }
  void zerarCampos(){
    euroController.text = "0.0";
    dolarUSAController.text = "0.0";
    realBrasileiroController.text = "0.0";
    pesoChilenoController.text = "0.0";
    JPYController.text = "0.0";
  }

  Widget buildTextForm(String label, String prefix,
      TextEditingController controller, bool readonly, Function onchange) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        prefixText: prefix,
        prefixStyle: const TextStyle(color: Colors.white),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      readOnly: readonly,
      style: const TextStyle(color: Colors.white),
      onChanged: (value) {
        onchange(value);
      },

    );
  }
}
