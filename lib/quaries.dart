import 'package:mongo_dart/mongo_dart.dart';

void main() async {
  var db = Db('mongodb://admin:TempPassword@51.79.173.45:27017/FLUTTER?authSource=admin&readPreference=primary&appname=MongoDB%20Compass&directConnection=true&ssl=false');
  ObjectId id;
  DbCollection coll;

  //db open
  await db.open();
  print('connection open');

  //create collection
  coll = db.collection('simple_data');

  //delete data in collection if already created
  await coll.remove({});
  print('Packing data to insert into collection by Bson...');

  //create new data
  for (var n = 0; n < 1000; n++)
  {
    await coll.insert({'my_field': n, 'str_field': 'str_$n'});
  }
  print('Done. Now sending it to MongoDb...');

  //find/read all data from 996-1000(filter)
  await coll
      .find(where.gt('my_field', 995).sortBy('my_field'))
      .forEach((v) => print(v));

  //find/read all data from one document
  var val = await coll.findOne(where.eq('my_field', 17));
  print('Filtered by my_field=17 $val');

  //get id value from my_field:17 and find data based on id
  if (val == null)
  {
    print('No document found');
  }
  else
  {
    id = val['_id'] as ObjectId;
    print('Document fetched: $id');

    //find/read data using my_field
    val = await coll
        .findOne(where.eq('my_field', 17)
        .fields(['str_field']));
    print("findOne with fields clause 'str_field' $val");

    //find/read data using id
    val = await coll.findOne(where.id(id));
    print('Filtered by _id=$id: $val');

    //delete data
    print('Removing doc with _id=$id');
    await coll.remove(where.id(id));

    //find/read data that have been deleted
    val = await coll.findOne(where.id(id));
    print('Filtered by _id=$id: $val. There more no such a doc');
  }
  //find/read with filter greater than/or/and
  await coll
      .find(where
      .gt('my_field', 995)
      .or(where.lt('my_field', 10))
      .and(where.match('str_field', '99')))
      .forEach((v) => print(v));
  print("Filtered by (my_field gt 995 or my_field lt 10) and str_field like '99' ");

  //find/read with in range 700-703 = 701,702 , with sort
  await coll
      .find(where
      .inRange('my_field', 700, 703, minInclude: false)
      .sortBy('my_field'))
      .forEach((v) => print(v));
  print('Filtered by my_field gt 700, lte 703');

  //find/read with in range with sort
  await coll
      .find(where
      .inRange('my_field', 700, 703, minInclude: false)
      .sortBy('my_field'))
      .forEach((v) => print(v));
  print("Filtered by str_field match '^str_(5|7|8)17\$'");

  await coll
      .find(where
      .match('str_field', 'str_(5|7|8)17\$')
      .sortBy('str_field', descending: true)
      .sortBy('my_field'))
      .forEach((v) => print(v));
  var explanation = await coll.findOne(where
      .match('str_field', 'str_(5|7|8)17\$')
      .sortBy('str_field', descending: true)
      .sortBy('my_field')
      .explain());
  print('Query explained: $explanation');
  print('Now where clause with jscript code: where("this.my_field % 100 == 35")');

  await coll
      .find(where.jsQuery('this.my_field % 100 == 35'))
      .forEach((v) => print(v));
  var count = coll.count(where.gt('my_field', 995));
  print('Count of records with my_field > 995: $count');

  var databases = await db.listDatabases();
  print('List of databases: $databases');

  var collections = await db.getCollectionNames();
  print('List of collections : $collections');

  var collectionInfos = await db.getCollectionInfos();
  print('List of collection\'s infos: $collectionInfos');

  await db.close();
}