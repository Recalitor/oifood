import 'package:flutter/material.dart';
import 'package:oifood/services/auth/crud/oifood_service.dart';

import '../../utilities/dialogs/delete_dialog.dart';

typedef DeleteApofasiCallback = void Function(DatabaseOifood oifood);

class OifoodListView extends StatelessWidget {
  final List<DatabaseOifood> apofaseis;
  final DeleteApofasiCallback onDeleteApofasi;

  const OifoodListView({
    super.key,
    required this.apofaseis,
    required this.onDeleteApofasi,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: apofaseis.length,
      itemBuilder: (context, index) {
        final apofasi = apofaseis[index];
        return ListTile(
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
