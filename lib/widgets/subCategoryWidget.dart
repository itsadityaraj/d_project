import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:d_project/utils/Screen_size_reducer.dart';
import 'package:d_project/modals/subCategoryModal.dart';
import 'package:d_project/screens/subCategoryScreen.dart';

class subCategoriesWidget extends StatelessWidget {
  subCategoriesWidget({Key key, this.color, this.icon, this.name, this.sub});

  final Color color;
  final String icon;
  final String name;
  final subCategory sub;


  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      color: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () =>Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryScreen(sub: sub),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SvgPicture.asset(icon,width: screenWidth(context, dividedBy: 8.0),height: screenWidth(context, dividedBy: 9.0),),
            Padding(
                padding : EdgeInsets.all(2.0),child: Text(name,overflow : TextOverflow.ellipsis,maxLines : 2,textAlign: TextAlign.center, style: TextStyle( fontWeight: FontWeight.w600,fontSize: 16.0, color:color == Colors.white ? Colors.black :  Colors.white,),)),
          ],
        ),
      ),
    );
  }
}
