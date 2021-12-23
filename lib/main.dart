import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;

void main() async {
  var db = Db('mongodb://admin:TempPassword@51.79.173.45:27017/FLUTTER?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false');
  await db.open();
  var coll = db.collection('test');

  //CRUD OPERATION
  //create one
  await coll.insertOne({'name': 'Asif', 'email': 'john@doe.com', 'age':50});

  //create many
  await coll.insertAll([
    {'name': 'John', 'email': 'john@gmail.com', 'age': 20},
    {'name': 'Lucy', 'email': 'lucy@gmail.com', 'age': 20},
    {'name': 'mira', 'email': 'mira@gmail.com', 'age': 18}
  ]);

  //read one
  var res = await coll.findOne(where.eq('name', 'mira').gt('age', 10));
  if (res == null) {
    print('No document found');
  } else {
   // print('Document fetched: ${res['name']} - ${res['email']} - ${res['age']}');
    print('${res['email']}');
  }

  //read many
  // var res = await coll.find(where.eq('name', 'John').gt('age', 10)).toList();
  // var res = await coll.find({
  //   'name': 'John',
  //   'age': {r'$gt': 10}
  // }).toList();
  // print('First document fetched: ${res.first['name']} - ${res.first['email']}');

  //update one
  //coll.updateOne(where.eq('name', 'John'), modify.set('age', 31));

  //update many
  //coll.updateMany(where.eq('age', 20), modify.set('age', 10));

  //delete one
  //await coll.deleteOne({'name': 'John'});

  //delete many
  //await coll.deleteMany({'age': 20});
  //await coll.remove({'age': 10});

  await db.close();
}