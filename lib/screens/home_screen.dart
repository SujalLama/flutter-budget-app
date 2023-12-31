import 'package:expense_tracker/data/data.dart';
import 'package:expense_tracker/helpers/color_helper.dart';
import 'package:expense_tracker/models/category_model.dart';
import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/screens/category_screen.dart';
import 'package:flutter/material.dart';

import '../widgets/bar_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  _buildCategory(Category category, double totalAmountSpent) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CategoryScreen(category: category),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 10.0,
        ),
        padding: const EdgeInsets.all(20.0),
        height: 100.0,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '\$${(category.maxAmount - totalAmountSpent).toStringAsFixed(2)}/\$${totalAmountSpent.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              final double maxBarWith = constraints.maxWidth;
              final double percent =
                  (category.maxAmount - totalAmountSpent) / category.maxAmount;

              double barWidth = percent * maxBarWith;

              if (barWidth < 0) {
                barWidth = 0;
              }

              return Stack(
                children: [
                  Container(
                    height: 20.0,
                    decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(15.0)),
                  ),
                  Container(
                    width: barWidth,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: getColor(context, percent),
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 100.0,
            forceElevated: true,
            // floating: true,
            pinned: true,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.settings,
                size: 30.0,
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                'Simple Budget App',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.add),
                iconSize: 30.0,
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    child: BarChart(
                      expenses: weeklySpending,
                    ),
                  );
                } else {
                  final Category category = categories[index - 1];
                  double totalAmountSpent = 0;
                  category.expenses.forEach((Expense expense) {
                    totalAmountSpent += expense.cost;
                  });

                  return _buildCategory(category, totalAmountSpent);
                }
              },
              childCount: 1 + categories.length,
            ),
          )
        ],
      ),
    );
  }
}
