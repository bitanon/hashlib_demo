import 'package:flutter/material.dart';
import 'package:hashlib_demo/src/utils/algorithms.dart';

final _nonAlphaNum = RegExp(r'[^a-z0-9]');

String _cleanName(String name) {
  return name.toLowerCase().replaceAll(_nonAlphaNum, '');
}

class AlgorithmList extends StatefulWidget {
  final Iterable<Algorithm> algorithms;
  final ValueChanged<Algorithm>? onSelect;

  const AlgorithmList({
    super.key,
    this.onSelect,
    required this.algorithms,
  });

  @override
  State<StatefulWidget> createState() => _AlgorithmListState();
}

class _AlgorithmListState extends State<AlgorithmList> {
  String filter = '';
  final controller = TextEditingController();

  Iterable<Algorithm> get filteredAlgorithms {
    if (filter.isEmpty) return widget.algorithms;
    return widget.algorithms.where((e) => _cleanName(e.name).contains(filter));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSearchBar(),
        const SizedBox(height: 10),
        Expanded(child: buildList()),
      ],
    );
  }

  Widget buildSearchBar() {
    return Material(
      elevation: 5,
      child: TextField(
        controller: controller,
        onChanged: (value) => setState(() {
          filter = _cleanName(value);
        }),
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          suffixIcon: buildCleanButton(),
          hintText: 'Filter algorithms',
          //border: InputBorder.none,
        ),
      ),
    );
  }

  Widget? buildCleanButton() {
    if (filter.isEmpty) {
      return null;
    }
    return IconButton(
      iconSize: 18,
      icon: const Icon(Icons.clear),
      onPressed: () => setState(() {
        filter = '';
        controller.clear();
      }),
    );
  }

  Widget buildList() {
    if (filteredAlgorithms.isNotEmpty) {
      return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          ...filteredAlgorithms.map(buildItem).toList(),
          const SizedBox(height: 30),
        ],
      );
    }
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.list_alt,
            size: 48,
            color: Colors.white54,
          ),
          SizedBox(height: 10),
          Text(
            'Empty list',
            style: TextStyle(
              fontSize: 12,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(Algorithm item) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text(
          item.info,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right),
        titleTextStyle: Theme.of(context).textTheme.titleMedium,
        subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
        onTap: widget.onSelect == null ? null : () => widget.onSelect!(item),
      ),
    );
  }
}
