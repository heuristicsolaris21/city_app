import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

List<String> words = ['arse', 'arsehead', 'arsehole', 'ass', 'asshole', 'bastard', 'bitch', 'bloody', 'bollocks', 'brotherfucker', 'bugger', 'bullshit', 'child-fucker', 'Christ on a bike', 'Christ on a cracker', 'cock', 'cocksucker', 'crap', 'cunt', 'cyka blyat', 'damn', 'damn it', 'dick', 'dickhead', 'dyke', 'fatherfucker', 'frigger', 'fuck', 'goddamn', 'godsdamn', 'hell', 'holy shit', 'horseshit', 'in shit', 'Jesus Christ', 'Jesus fuck', 'Jesus H. Christ', 'Jesus Harold Christ', 'Jesus, Mary and Joseph', 'Jesus wept', 'kike', 'motherfucker', 'nigga', 'nigra', 'pigfucker', 'piss', 'prick', 'pussy', 'shit', 'shit ass', 'shite', 'sisterfucker', 'slut', 'son of a whore', 'son of a bitch', 'spastic', 'sweet Jesus', 'turd', 'twat', 'wanker', 'otha', 'ommala', 'punda', 'mairu', 'koodhi', 'thevdiyapasanga', 'oombu'];

class NewMeassage extends StatefulWidget {
  const NewMeassage({super.key});

  @override
  State<NewMeassage> createState() => _NewMeassageState();
}

class _NewMeassageState extends State<NewMeassage> {
  final _messaageController = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    _messaageController.dispose();
    super.dispose();
  }

  void _submitmessage() async {
    final enteredMessaage = _messaageController.text;
    if (enteredMessaage.trim().isEmpty) {
      return;
    }
    for(var word in words){
      if(words.contains(word)){
        return;
      }
    }
    
    //sethu
    FocusScope.of(context).unfocus();
    _messaageController.clear();
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .once();

    final data = userData.snapshot.value as Map<dynamic, dynamic>;

    FirebaseDatabase.instance.reference().child('chat').push().set({
      'text': enteredMessaage,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': user.uid,
      'username': data['username'],
      'userImage': data['imageurl'],
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messaageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(labelText: 'Send a Message...'),
            ),
          ),
          IconButton(
            onPressed: _submitmessage,
            icon: const Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
          ),
        ],
      ),
    );
  }
}
