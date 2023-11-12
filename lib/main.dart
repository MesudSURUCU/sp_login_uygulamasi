import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sp_login_uygulamasi/Anasayfa.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  Future<bool> oturumKontrol() async {
    var sp = await SharedPreferences.getInstance();

      String spKullaniciAdi = sp.getString('kullaniciAdi') ?? 'kullanıcı adı yok';
      String spSifre = sp.getString('sifre') ?? 'şifre yok';

      if(spKullaniciAdi == 'admin' && spSifre == '12345') {
        return true;
      }else {
        return false;
      }

  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  FutureBuilder<bool>(
        future: oturumKontrol(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            bool gecisIzni = snapshot.hasData;
            return gecisIzni ? LoginEkrani()  : Anasayfa();
          }else{
            return Container();
          }
        },
      ),
    );
  }
}

class LoginEkrani extends StatefulWidget {

  @override
  State<LoginEkrani> createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {

  var tfKullaniciAdi = TextEditingController();
  var tfSifre = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();

  Future<void> girisKontrol() async {
    var ka = tfKullaniciAdi.text;
    var s = tfSifre.text;

    if (ka == 'admin' && s == '12345') {
      var sp = await SharedPreferences.getInstance();

      sp.setString('kullaniciAdi', ka);
      sp.setString('sifre', s);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Anasayfa()));

    }else{



      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Giriş Hatalı'),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text('Login Ekranı'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            TextField(
               controller: tfKullaniciAdi,
               decoration: InputDecoration(hintText: 'Kullanıcı Adı',),),
              TextField(
                obscureText: true,
                controller: tfSifre,
                decoration: InputDecoration(hintText: 'Şifre',),),
              ElevatedButton(
                  onPressed: () {
                    girisKontrol();
              },
                  child: Text('Giriş Yap')),
            ],
          ),
        ),
      ),
    );
  }
}
