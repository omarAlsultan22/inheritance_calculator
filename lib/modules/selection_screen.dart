import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';
import '../shared/cubit/cubit.dart';

class SelectionScreen extends StatefulWidget {
  const SelectionScreen({super.key});

  @override
  State<SelectionScreen> createState() => _SelectionScreenState();
}

class _SelectionScreenState extends State<SelectionScreen> {
  late DataCubit _dataCubit;

  @override
  void initState() {
    super.initState();
  }

  void _initDataCubit(BuildContext context) {
    _dataCubit = DataCubit.get(context);
    _dataCubit.sendWidgetContext(context);
  }

  void _statesListener(BuildContext context, DataStates state) {
    if (state is DataErrorState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.error!),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  AppBar _buildAppBar()=>
      AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.grey[900],
        title: const Text(
          "مواريث",
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget _headline() {
    return const Text(
      "مات وترك ؟",
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _itemsMenu() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
      ),
      child: DropdownButton<String>(
        menuMaxHeight: 200,
        hint: const Text(
          'أختر',
          style: TextStyle(color: Colors.white),
        ),
        value: _dataCubit.selectedItem,
        dropdownColor: Colors.grey[800],
        borderRadius: BorderRadius.circular(10),
        items: _dataCubit.heirsMap.keys.map((String key) {
          return DropdownMenuItem<String>(
            value: key,
            child: Text(
              key,
              style: const TextStyle(color: Colors.white),
            ),
          );
        }).toList(),
        onChanged: (String? key) {
          if (key != null) {
            _dataCubit.checkKey(key);
          }
        },
      ),
    );
  }

  Widget _buildGridItem(dynamic e) {
    return GestureDetector(
      onTap: () => _dataCubit.handleItemTap(e),
      child: Card(
        color: Colors.grey[700],
        child: Stack(
          children: [
            // Remove button
            if (e.icon)
              Align(
                alignment: AlignmentDirectional.topStart,
                child: IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.highlight_remove_outlined,
                    color: Colors.white70,
                  ),
                  onPressed: () => _dataCubit.removeItem(e),
                ),
              ),

            // Main text
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  e.textValue,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: e.backgroundColor ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),

            // Sum badge
            if (!e.toggle)
              Positioned(
                bottom: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${e.sum}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _selectedItems() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: GridView.count(
          physics: const BouncingScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.9,
          children: _dataCubit.multiList
              .expand((list) => list)
              .map(_buildGridItem)
              .toList(),
        ),
      ),
    );
  }

  Widget _calculateButton(DataStates state) {
    return Container(
      width: double.infinity,
      color: _dataCubit.color ? Colors.amber : Colors.grey[600],
      child: MaterialButton(
        onPressed: _dataCubit.buttonLuck ? _dataCubit.shareDistribution : null,
        child: state is DataLoadingState
            ? const Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
            child: CircularProgressIndicator(color: Colors.black),
          ),
        )
            : const Text(
          'أحسب',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DataCubit, DataStates>(
      listener: _statesListener,
      builder: (context, state) {
        _initDataCubit(context);
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: Colors.grey[900],
            appBar: _buildAppBar(),
            body: Column(
              children: [
                const SizedBox(height: 50),
                _headline(),
                _itemsMenu(),
                _selectedItems(),
                _calculateButton(state),
              ],
            ),
          ),
        );
      },
    );
  }
}