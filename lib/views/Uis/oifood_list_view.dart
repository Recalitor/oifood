import 'package:flutter/material.dart';
import 'package:oifood/services/cloud/cloud_note.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef ApofasiCallback = void Function(CloudNote oifood);

class OifoodListView extends StatelessWidget {
  final Iterable<CloudNote> apofaseis;
  final ApofasiCallback onDeleteApofasi;
  final ApofasiCallback onTap;

  const OifoodListView({
    super.key,
    required this.apofaseis,
    required this.onDeleteApofasi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apofaseis.length,
      itemBuilder: (context, index) {
        final apofasi = apofaseis.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(apofasi);
          },
          title: Text(apofasi.toString()),
          trailing: IconButton(
            onPressed: () async {
              final shouldDelete = await showDeleteDialog(context);
              if (shouldDelete) {
                onDeleteApofasi(apofasi);
              }
            },
            icon: const Icon(Icons.delete),
          ),
          //title: Text(apofasi.text,
          //maxLines:1,
          //softWrap:true,
          //overflow: TextOverflow.ellipsis,),
        );
      },
    );
  }
}
