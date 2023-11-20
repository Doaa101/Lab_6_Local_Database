import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'Databaseclassv2.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    routes: {'/home': (context) => MyApp()},
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Databasev2 mydb = Databasev2();
  List<Map> mylist = [];

  Future<Database?> ReadingData() async {
    List<Map> RESPONSE = await mydb.reading('''SELECT * FROM 'FILE1' ''');
    mylist = [];
    mylist.addAll(RESPONSE);
  }

  @override
  void initState() {
    ReadingData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text("My First Application"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await mydb.write('''INSERT INTO 'FILE1' ('NAME1','NAME2') VALUES
          ('AIN SHAMS UNIVERSITY', 'FACULTY OF ENGINEERING') ''');
          ReadingData();
          setState(() {});
        },
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
          itemCount: mylist.length,
          itemBuilder: (context, index) {
            return ListTile(
              trailing: IconButton(
                  onPressed: () async {
                    await mydb.update('''UPDATE  FILE1 SET 
                    'NAME1' = 'FACULTY OF ENGINEERING',
                    'NAME2' = 'AIN SHAMS UNOVERSITY' WHERE ID = ${mylist[index]['ID']} ''');
                    ReadingData();
                    setState(() {});
                  },
                  icon: Icon(Icons.edit)),
              leading: IconButton(
                  onPressed: () async {
                    await mydb.delete(
                        '''DELETE FROM file1 WHERE ID = ${mylist[index]['ID']} ''');
                    mylist.removeWhere(
                        (element) => element['ID'] == mylist[index]['ID']);
                    setState(() {});
                  },
                  icon: Icon(Icons.delete)),
              title: Text(mylist[index]['NAME1']),
              subtitle: Text(mylist[index]['NAME2']),
            );
          }),
    );
  }
}
