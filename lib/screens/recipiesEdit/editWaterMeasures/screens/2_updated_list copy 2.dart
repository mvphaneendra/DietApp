import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dietapp_v002/screens/recipiesEdit/editWaterMeasures/functions/0a_fetch_food_from_fire.dart';
import 'package:dietapp_v002/screens/recipiesEdit/editWaterMeasures/screens/1_each_recipie_ing_view.dart';
import 'package:dietapp_v002/screens/recipiesEdit/editWaterMeasures/screens/2_doubt_list_and_no_water_list.dart';
import 'package:dietapp_v002/screens/recipiesEdit/editWaterMeasures/screens/eachres.dart';
import 'package:dietapp_v002/screens/recipiesEdit/nin_edit/new_edit.dart/search_edit.dart';
import 'package:dietapp_v002/screens/recipiesEdit/nin_edit/new_edit.dart/search_edit_for_updatr.dart';
import 'package:dietapp_v002/screens/recipiesEdit/nin_edit/nin_measures_edit_form.dart';
import 'package:dietapp_v002/screens/recipiesEdit/nin_edit/nin_updated1_measures_edit_form.dart';
import 'package:dietapp_v002/screens/recipiesEdit/nin_edit/nin_updated_list_reversed.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:paginate_firestore/paginate_firestore.dart';

class WaterSubmittedList extends StatelessWidget {
  const WaterSubmittedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Submitted list"), actions: [
        GFButton(
          onPressed: () {
            Get.to(WaterDoubtAndNoWaterList(), arguments: 3);
          },
          child: Text(
            "Zero List",
            textScaleFactor: 1.2,
          ),
        )
      ]),
      body: PaginateFirestore(
        query: FirebaseFirestore.instance
            .collection("FoodData")
            .where("waterWork", isEqualTo: 10)
            .orderBy("fID"),
        itemBuilderType: PaginateBuilderType.listView,
        itemBuilder: (index, context, snapshot) {
          final data = snapshot.data() as Map;
          var foodName = data['names']['Common_name'].toString();
          var imgURl = data['imgURL']['img150'].toString();
          var docID = data['fID'].toString();
          num grosWaterGms = data['recipieGms']['grossWaterGms'];
          num netWaterGms = data['recipieGms']['netWaterGms'];

          var uid = data["waterRemarks"].substring(0, 2);
          num waterPercent = (grosWaterGms - netWaterGms) * 100 / grosWaterGms;

          return ListTile(
            onTap: () async {
              Get.to(EachRecipieIngVie(),
                  arguments: await FetchFoodDocs().getFmapImap(docID));
            },
            leading: GFAvatar(
              //shape: GFAvatarShape.circle,

              child: CachedNetworkImage(
                fit: BoxFit.cover,
                placeholder: (context, url) => const GFLoader(
                  type: GFLoaderType.ios,
                ),
                imageUrl: imgURl,
                width: double.infinity,
                height: double.infinity,
                errorWidget: (context, url, error) {
                  return const GFLoader(
                    type: GFLoaderType.ios,
                  );
                },
              ),
            ),
            //titleText: foodName,
            title: SingleChildScrollView(
              child: Text(
                foodName,
                textScaleFactor: 1.4,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              scrollDirection: Axis.horizontal,
            ),
            subtitle: SingleChildScrollView(
              child: grosWaterGms == 0
                  ? Text("$docID : Water not used in this recipie")
                  : Text(
                      "$docID : ${waterPercent.toStringAsFixed(0)}% water reduced"),
              scrollDirection: Axis.horizontal,
            ),
            trailing: Text(uid),
          );
        },
        isLive: true,
        itemsPerPage: 10,
      ),
    );
  }
}
