import 'package:men/shared/cubit/cubit.dart';
import 'package:flutter/material.dart';
import '../shared/cubit/states.dart';


void initDataCubit(BuildContext context, DataCubit dataCubit) {
  dataCubit = DataCubit.get(context);
  dataCubit.sendWidgetContext(context);
}


void statesListener(BuildContext context, DataStates state) {
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


AppBar buildSelectionAppBar()=>
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


Widget headline() {
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


Widget itemsMenu(DataCubit dataCubit) {
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
      value: dataCubit.selectedItem,
      dropdownColor: Colors.grey[800],
      borderRadius: BorderRadius.circular(10),
      items: dataCubit.heirsMap.keys.map((String key) {
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
          dataCubit.checkKey(key);
        }
      },
    ),
  );
}


Widget _buildGridItem(DataCubit dataCubit, dynamic e) {
  return GestureDetector(
    onTap: () => dataCubit.handleItemTap(e),
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
                onPressed: () => dataCubit.removeItem(e),
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


Widget selectedItems(DataCubit dataCubit) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: GridView.count(
        physics: const BouncingScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
        children: dataCubit.multiList
            .expand((list) => list)
            .map((e) => _buildGridItem(dataCubit, e))
            .toList(),
      ),
    ),
  );
}


Widget calculateButton(DataCubit dataCubit, DataStates state) {
  return Container(
    width: double.infinity,
    color: dataCubit.color ? Colors.amber : Colors.grey[600],
    child: MaterialButton(
      onPressed: dataCubit.buttonLuck ? dataCubit.shareDistribution : null,
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