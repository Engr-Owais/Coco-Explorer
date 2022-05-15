import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../networking/constants/constant_data.dart';
import '../bloc/explorer_bloc.dart';
import '../delegates/coco_search_delegate.dart';
import '../providers/search_tags_provider.dart';
import '../widgets/search_result_list.dart';
import '../widgets/selected_search_tags_view.dart';

class CocoExplorerPage extends StatelessWidget {
  const CocoExplorerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("COCO Explorer"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openSearchDelegate(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.blue,
                            ),
                          ),
                          alignment: Alignment.centerLeft,
                          child: const Text('Search...'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () => _performCocoSearch(context),
                      child: const Text('Done'),
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        primary: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SelectedSearchTagsView(),
            const SizedBox(height: 15),
            Expanded(
              child: SearchResultList(performCocoSearch: _performCocoSearch),
            ),
          ],
        ),
      ),
    );
  }

  void _performCocoSearch(BuildContext context, {int page = 1}) {
    FocusScope.of(context).unfocus();

    final tags =
        Provider.of<SearchTagsProvider>(context, listen: false).searchTags;

    late List<int> tagsIds;

    if (tags.isNotEmpty) {
      tagsIds = categoryToId.entries
          .where((element) => tags.contains(element.key))
          .map((e) => e.value)
          .toList();
    } else {
      tagsIds = [-1];
    }

    dev.log(tagsIds.toString());

    debugPrint('Fetching page num: $page');

    BlocProvider.of<ExplorerBloc>(context).add(
      SearchCocoDatasetEvent(categoryIds: tagsIds, page: page),
    );
  }

  void _openSearchDelegate(context) async {
    final tag = await showSearch(
      context: context,
      delegate: COCOSearchDelegate(),
    );

    if (tag != null && tag is String) {
      Provider.of<SearchTagsProvider>(context, listen: false)
          .addNewSearchTag(tag);
    }
  }
}
