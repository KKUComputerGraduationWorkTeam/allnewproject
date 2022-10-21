import 'package:flutter/material.dart';

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 50),
      width: 150,
      height: 350,
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey[300],
            backgroundImage: AssetImage('image/img.png'),
          ),
          SizedBox(
            height: 10,
          ),
          OutlinedButton.icon(
            onPressed: (){},
            icon: Icon(Icons.image, color: Colors.grey,),
            label: Text("프로필 사진 추가하기", style: TextStyle(color: Colors.black)),
          ),
          SizedBox(
            height: 80,
          ),
          TextButton.icon(
              onPressed: (){
                Navigator.pop(context);
              },
              icon: Icon(Icons.close,color: Colors.redAccent,),
              label: Text("Close", style: TextStyle(color: Colors.redAccent),))
        ],
      ),
    );
  }
}
