import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CommonFilterScreen<T> extends StatefulWidget {
  final String title;
  final List<T> categories;
  final Map<T, List<String>> subTypeMap;
  final List<String> initialSubTypes;
  final Function(List<String>) onApply;

  const CommonFilterScreen({
    super.key,
    required this.title,
    required this.categories,
    required this.subTypeMap,
    required this.onApply,
    this.initialSubTypes = const [],
  });

  @override
  State<CommonFilterScreen<T>> createState() =>
      _CommonFilterScreenState<T>();
}

class _CommonFilterScreenState<T>
    extends State<CommonFilterScreen<T>> {
  late T selectedCategory;
  late List<String> selectedSubTypes;

  @override
  void initState() {
    super.initState();
    selectedCategory = widget.categories.first;
    selectedSubTypes = List.from(widget.initialSubTypes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF1E293B),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,),
        ),
        iconTheme: IconThemeData(
          color: Colors.white, // Back button color
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                selectedSubTypes.clear();
              });
            },
            child: const Text(
              "Clear",
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          /// LEFT CATEGORY PANEL
          Container(
            width: 140,
            decoration: const BoxDecoration(
              color: Color(0xFF1E293B),
            ),
            child: ListView(
              children: widget.categories.map((category) {
                final isSelected =
                    category == selectedCategory;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(
                      vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF334155)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    title: Text(
                      category
                          .toString()
                          .split('.')
                          .last
                          .toUpperCase(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.w400
                            : FontWeight.w300,
                        color: isSelected
                            ? Colors.white
                            : Colors.grey.shade400,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          /// RIGHT SUBTYPE PANEL
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: widget
                        .subTypeMap[selectedCategory]!
                        .map(
                          (subType) => Container(
                            margin:
                                const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E293B),
                              borderRadius:
                                  BorderRadius.circular(12),
                            ),
                            child: CheckboxListTile(
                              activeColor:
                                  Colors.blueAccent,
                              checkColor: Colors.white,
                              value: selectedSubTypes
                                  .contains(subType),
                              title: Text(
                                subType,
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontWeight:
                                      FontWeight.w500,
                                      fontSize: 15.sp
                                ),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  val!
                                      ? selectedSubTypes
                                          .add(subType)
                                      : selectedSubTypes
                                          .remove(subType);
                                });
                              },
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),

                /// BOTTOM APPLY BAR
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF1E293B),
                    border: Border(
                      top: BorderSide(
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${selectedSubTypes.length} Selected",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.blueAccent,
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14),
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          widget.onApply(
                              selectedSubTypes);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Apply Filters",
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}