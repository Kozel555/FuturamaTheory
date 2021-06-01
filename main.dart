import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Character.dart';
import 'dart:math';
import 'package:flutter_phoenix/flutter_phoenix.dart';
void main() {
  runApp(
    Phoenix(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController myController1 = TextEditingController(); //текст в первом окошке
  TextEditingController myController2 = TextEditingController(); //текст во втором окошке

  //
  List<Character> characters = []; //персонажи
  List<Widget> containers = []; // карточки с персонажами при их создании
  List<String> input2 = []; // ввод с клавиатуры, который впоследствии становится списком ниже
  List<int> all_swaps = []; //список персонажей совершивших обмен
  List<int> swapers = []; //те кто совершают обмен
  List<int> swapsTarget = []; // те кто являются целью обмена
  List<int> actuallySwapped = []; // список людей чьи mind нужно вернуть в их bodies

  // Разделение на два круга
  List<int> circleBig = [];
  List<int> circleMini = [];

  //
  int n = 0; // кол-во персонажей
  int m; // minds печатается в карточке персонажа
  int b; // body печатается в карточке персонажа
  int temp; // перменная для swap
  int funny; // если вы введёте персонажа за пределами существующих
  int flag = 0;
  void addCharacter(int n) { //добавляет персонажей
    for (int i = 1; i <= n; i++) {
      characters.add(Character(i));
    }
  }

  void addContainer(int n) { //добавляет карточек персонажей
    for (int i = 1; i <= n; i++) {
      b = characters[i-1].body;
      m = characters[i-1].mind;
      containers.add(Container(width:300, height:50, color:Colors.indigo, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
        Container(
          child: Row(
            children: [
              Icon(Icons.accessibility),
              Text('$b', style: TextStyle(fontSize: 30))
            ],
          )
        ),
          Container(
            child: Row(
             children: [
               Text('$m', style: TextStyle(fontSize: 30)),
               Icon(Icons.person),
          ]
    ),
          ),
        ]
      )
      )
      );
      containers.add(SizedBox(height: 20,));
    }
  }
  void addContainerHelper(n) { //добавляет карточек персонажей
    for (int i = 1, j = 2; i <= 2; i++, j--) {
        b = n + i;
        m = n + i;
      containers.add(Container(width:300, height:50, color:Colors.orangeAccent, child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                child: Row(
                  children: [
                    Icon(Icons.accessibility),
                    Text('$b', style: TextStyle(fontSize: 30))
                  ],
                )
            ),
            Container(
              child: Row(
                  children: [
                    Text('$m', style: TextStyle(fontSize: 30)),
                    Icon(Icons.person),
                  ]
              ),
            ),
          ]
      )
      )
      );
      containers.add(SizedBox(height: 20,));
    }
  }

 void separate() { //делим всех участников совершивших обмен на два списка хотя можно было так не делать
   for (int i = 0; i <= all_swaps.length - 1; i++) {
     if (i.isEven) {
       swapers.add(all_swaps[i]);
     }
     if (i.isOdd) {
       swapsTarget.add(all_swaps[i]);
     }
   }
  }

 String findSolution() { //решение
   String changes = '';
   int number1;
   int number2;
   List<int> circleBigN = [];
   List<int> circleMiniN = [];
   circleBig = [];
   circleMini = [];
   temp = 0;
   actuallySwapped = [];


   for (int i = 0; i <= n - 1; i++) {
     if (characters[i].body != characters[i].mind) {
       circleBig.add(i); //добавляем всех людей у которых не всё хорошо с головой
       
     }
   }
   actuallySwapped = circleBig;
   print(actuallySwapped);
   if (circleBig.length == 0) { //если у всех с головой всё в порядке, то ничего менять не надо
     changes = 'ничего менять не надо';
     print('ничего менять не надо');
     return changes;
   }
   else { //мы ищем людей, чьи тела и разум взаимно обратны, то есть пары (1, 2) (2, 1) и добавляем в circleMini. удаляем такую пару из circleBig.
     for (int i = 0; i <= actuallySwapped.length - 1; i++) {
       if (circleMiniN.contains(i)) {print('contunue'); continue;}
       for (int j = 0; j <= actuallySwapped.length - 1; j++) {
         print('шаг $j, шаг $i');
         print(characters[actuallySwapped[j]].body);
         print(characters[actuallySwapped[i]].mind);
         print(characters[actuallySwapped[j]].body);
         print(characters[actuallySwapped[i]].mind);
         if (characters[actuallySwapped[j]].body == characters[actuallySwapped[i]].mind
             &&
             characters[actuallySwapped[j]].mind == characters[actuallySwapped[i]].body) {
           circleMini.add(actuallySwapped[i]);
           circleMini.add(actuallySwapped[j]);
           circleMiniN.add(j);
           print('circleMiniN=');
           print(circleMiniN);
           print('добавил персонажа');
         }
       }
     }
     print(circleMini);
     for (int i = 0; i <= circleMini.length - 1; i++) {
       circleBig.remove(circleMini[i]); //удалили
     }
     temp = 0;
     for (int j = 0; j <= circleBig.length - 1; j++) {
       //сортируем большой круг, то есть людей чьи тела и разум не взаимнообратны, так, чтобы тело и разум людей которые надо поменять шли по очереди
       for (int i = 0; i <= circleBig.length - 1; i++) {
         if (characters[circleBig[temp]].mind == characters[circleBig[i]].body) {
           circleBigN.add(circleBig[temp]);
           print('вошел в цикл со значениями J: $j , I: $i');
           print(circleBig[temp]);
           print(circleBigN);
           temp = i;
           break;
         }
       }
     }
     
     circleBig = circleBigN;
     print(circleMini);
     print(circleBig);
     characters.add(Character(n + 1));

     for (int i = 0; i <= circleBig.length - 1; i++) {

       if (i == circleBig.length - 1) {
         //на последней итерации должны провести такой манёвр
         characters.add(Character(n + 2));

         number1 = characters.last.mind;
         number2 = characters[circleBig[i]].mind;
         characters.last.mind = number2;
         characters[circleBig[i]].mind = number1;
         number1 = characters.last.body;
         number2 = characters[circleBig[i]].body;
         changes += '($number1, $number2), ';

         number1 = characters[characters.length - 2].mind;
         number2 = characters[circleBig[i]].mind;
         characters[characters.length - 2].mind = number2;
         characters[circleBig[i]].mind = number1;
         number1 = characters[characters.length - 2].body;
         number2 = characters[circleBig[i]].body;
         changes += '($number1, $number2), ';

         number1 = characters.last.mind;
         number2 = characters[circleBig[0]].mind;
         characters.last.mind = number2;
         characters[circleBig[0]].mind = number1;
         number1 = characters.last.body;
         number2 = characters[circleBig[0]].body;
         changes += '($number1, $number2), ';

         break;
       }
       number1 = characters.last.mind;
       number2 = characters[circleBig[i]].mind;
       characters.last.mind = number2;
       characters[circleBig[i]].mind = number1;
       number1 = characters.last.body;
       number2 = characters[circleBig[i]].body;
       changes += '($number1, $number2), ';
       print(changes);
     }
      if (circleBig.isEmpty) {
        print('он пуст ? значит второго персонажа нет');
        characters.add(Character(n + 2));
      }
     for (int i = 0; i <= circleMini.length - 1; i+=2) {
       print('вошел в условие с малым кругом');
       print('$i');
       number1 = characters.last.mind;
       number2 = characters[circleMini[i]].mind;
       characters.last.mind = number2;
       characters[circleMini[i]].mind = number1;
       number1 = characters.last.body;
       number2 = characters[circleMini[i]].body;
       changes += '($number1, $number2), ';

       number1 = characters[characters.length - 2].mind;
       number2 = characters[circleMini[i + 1]].mind;
       characters[characters.length - 2].mind = number2;
       characters[circleMini[i + 1]].mind = number1;
       number1 = characters[characters.length - 2].body;
       number2 = characters[circleMini[i + 1]].body;
       changes += '($number1, $number2), ';

       number1 = characters.last.mind;
       number2 = characters[circleMini[i + 1]].mind;
       characters.last.mind = number2;
       characters[circleMini[i + 1]].mind = number1;
       number1 = characters.last.body;
       number2 = characters[circleMini[i + 1]].body;
       changes += '($number1, $number2), ';

       number1 = characters[characters.length - 2].mind;
       number2 = characters[circleMini[i]].mind;
       characters[characters.length - 2].mind = number2;
       characters[circleMini[i]].mind = number1;
       number1 = characters[characters.length - 2].body;
       number2 = characters[circleMini[i]].body;
       changes += '($number1, $number2), ';
     }
     print(characters.last.mind);
     print(characters.last.body);
     if (characters.last.mind != characters.last.body) {
       print('вошел');
       number1 = characters[characters.length - 2].mind;
       number2 = characters.last.mind;
       characters[characters.length - 2].mind = number2;
       characters.last.mind = number1;
       number1 = characters[characters.length - 2].body;
       number2 = characters.last.body;
       changes += '($number1, $number2), ';
     }
     return changes;
   }
 }

  @override
    Widget build(BuildContext context) {
      double width = MediaQuery
          .of(context)
          .size
          .width;
      double height = MediaQuery
          .of(context)
          .size
          .height;
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child:
        SafeArea(
            child: Container(
                child: Column(
                  children: [
                    SizedBox(height:30),
                    Center(
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                // Retrieve the text the that user has entered by using the
                                // TextEditingController.
                                content: SelectableText(findSolution())
                              );
                            },
                          );
                          containers.clear();
                          });
                          },

                        child: Container(
                          width: 200,
                          height: 50,
                        child: Text('Futurama',style: TextStyle(fontSize: 30),  textAlign: TextAlign.center,)
                        ),
                      ),
                    ),
                    Column(
                        children: [
                              TextField(
                                keyboardType: TextInputType.number,
                                obscureText: false,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Number of characters',
                                ),
                                controller: myController1,
                              ),
                          SizedBox(height: 15),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  characters = [];
                                  containers = [];
                                  all_swaps = [];
                                  swapers = [];
                                  swapsTarget = [];
                                  n = int.parse(myController1.text); //преобразуем текст с клавиатуры в int
                                  addCharacter(n);
                                  addContainer(n);
                                  addContainerHelper(n);
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        // Retrieve the text the that user has entered by using the
                                        // TextEditingController.
                                        content: Text("вы создали $n персонажей, теперь выберите пары, которые хотите поменять местами"),
                                      );
                                    },
                                  );
                                });
                              },
                              child: Icon(Icons.check, size: 50)),
                          SizedBox(height: 30),
                          TextField(
                            obscureText: false,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Pairs you want to switch: (10, 6), (13, 8)'
                            ),
                            controller: myController2,
                          ),
                          SizedBox(height: 30),
                          FlatButton(
                              onPressed: () {
                                setState(() {
                                  all_swaps = [];
                                  swapers = [];
                                  swapsTarget = [];
                                  input2 = [];
                                  containers = [
                                  ]; //обнуляем переменные на случай повторного ввода
                                  input2 = myController2.text.replaceAll(
                                    RegExp(r"[^,0-9]+"), '',).split(
                                      ','); //берём только цифры и запятые, потом сплит в список с разделителем ,
                                  all_swaps = input2.map((e) => int.parse(e))
                                      .toList(); //переводим string в список int
                                  separate();
                                  funny = all_swaps.reduce(max);
                                  if (funny - 2 > n) {
                                    print(funny);
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          // Retrieve the text the that user has entered by using the
                                          // TextEditingController.
                                          content: Text(
                                              "Похоже несколько персонажей сбежали, по крайней мере $funny-ого, нигде найти не можем, возможно он ушел пить кофе"),
                                        );
                                      },
                                    );
                                  }
                                  else if (funny > n) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          // Retrieve the text the that user has entered by using the
                                          // TextEditingController.
                                          content: Text(
                                              "Осторожно, злая собака !"),
                                        );
                                      },
                                    );
                                  }
                                  else
                                  if (swapers.length != swapsTarget.length) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          // Retrieve the text the that user has entered by using the
                                          // TextEditingController.
                                          content: Text(
                                              "Кажется у нас лишний стул. ну или персонажа для кого-то не хватило"),
                                        );
                                      },
                                    );
                                  }
                                  else if (all_swaps.contains(0)) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          // Retrieve the text the that user has entered by using the
                                          // TextEditingController.
                                          content: Text(
                                              "Мы не вешали на персонажей табличку с надписью 0"),
                                        );
                                      },
                                    );
                                  }
                                  else {
                                    for (int i = 0; i <=
                                        swapsTarget.length - 1; i++) {
                                      temp = characters[swapers[i] - 1].mind;
                                      characters[swapers[i] - 1].mind =
                                          characters[swapsTarget[i] - 1].mind;
                                      characters[swapsTarget[i] - 1].mind =
                                          temp;
                                    }
                                  }

                                  addContainer(n);
                                  addContainerHelper(n);

                                }
                                );
                              },
                              child: Icon(Icons.sync, size: 50)),
                        ],
                      ),
                    SizedBox(height: 50),

                    Column(
                        children: containers)
                  ],
                )
            )
        ),
        ),
    );
    }
  }
