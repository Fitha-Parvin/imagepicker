import 'package:firebasestorage/sqf1.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MaterialApp(
    home: sqmain(),
  ));
}

class sqmain extends StatefulWidget {
  @override
  State<sqmain> createState() => _sqmainState();
}

class _sqmainState extends State<sqmain> {
  bool isLoading =true;
  List<Map<String,dynamic>>note_from_db=[];

  void inistate(){
    refreshData();
    super.initState();
  }
  void refreshData() async{
    final datas=await SQLHelper.readNotes();
    setState(() {
      note_from_db=datas;
      isLoading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("my notes"),
      ),
      body: isLoading ?const Center(child: CircularProgressIndicator(),):
      ListView.builder(
          itemCount: note_from_db.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text("${note_from_db[index]['title']} "),
                subtitle: Text(note_from_db[index]['note']),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            showForm(note_from_db[index]['id']);
                          },
                          icon: Icon(Icons.edit)),
                      IconButton(
                          onPressed: () {
                            deleteNote(note_from_db[index]['id']);
                          },
                          icon: Icon(Icons.delete))
                    ],
                  ),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showForm(null),
        child: const Icon(Icons.add),
      ),
    );
  }

  final title=TextEditingController();
  final note=TextEditingController();

  void showForm(int? id) async {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => Container(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              // bottom: MediaQuery.of(context).viewInsets.bottom+120
            ),
            child:
            Column(mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: title,
                    decoration: InputDecoration(hintText: "Title",border: OutlineInputBorder()),
                  ),
                  TextField(
                    controller: note,
                    decoration: InputDecoration(hintText: " enter note",border: OutlineInputBorder()),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(onPressed: () async{
                    if(id==null){
                      await addNote();
                    }
                    if(id!=null){
                      await updateNote(id);
                    }
                    title.text='';
                    note.text='';
                    Navigator.of(context).pop();

                  }, child: Text(id==null ? 'ADD N0TE' :'UPDATE'),
                  )
                ]
            ),
          ),
        )
    );
  }

  Future addNote() async{
    await SQLHelper.createNote(title.text, note.text);
    refreshData();

  }
  Future updateNote(int id) async{
    await SQLHelper.updateNote( id,title.text, note.text);
    refreshData();

  }

  void deleteNote(int id) async {
    await SQLHelper.deleteNote(id);
    ScaffoldMessenger.of(context).showSnackBar( const SnackBar(
      content: Text("Note Deleted"),
    ));
    refreshData();
  }


}