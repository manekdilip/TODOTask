import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/app_pages.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Todo> notSyncedTodos = [];
  List<Todo?> allTodos = [];
  late Box<String> box;
  late Box<bool> boxWorkManager;

  @override
  void initState() {
    super.initState();
    openHiveBox();
    setBackgroundProcess();
    BlocProvider.of<TodoBloc>(context).add(LoadTodos());
  }

  ///setting up the selected frequency for already selected one if not defaults to 6 hrs
  openHiveBox() async {
    await Hive.openBox<String>(AppStrings.frequencyBox);
    box = Hive.box<String>(AppStrings.frequencyBox);
  }

  ///starting up background process with 6 hrs frequency by default
  setBackgroundProcess() async {
    await Hive.openBox<bool>(AppStrings.isWorkMangerStarted);
    boxWorkManager = Hive.box<bool>(AppStrings.isWorkMangerStarted);
    var isStarted = boxWorkManager.get(AppStrings.isWorkMangerStarted);
    if (isStarted == null) {
      Workmanager().cancelAll();
      var uniqueIdentifier = DateTime.now().second.toString();
      await Workmanager()
          .registerPeriodicTask(
        uniqueIdentifier,
        AppStrings.taskName,
        frequency: const Duration(hours: 6),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      )
          .then((onValue) {
        boxWorkManager.put(AppStrings.isWorkMangerStarted, true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    var selectedLocale = Localizations.localeOf(context).toString();
    final TodoBloc todoBloc = BlocProvider.of<TodoBloc>(context);
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Align(
            alignment: Alignment.topLeft,
            child: Opacity(
              opacity: 0.5,
              child: Text(
                locale.appTitle,
                style: GoogleFonts.getFont(
                  AppStrings.fontName,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                  height: 1.9,
                  letterSpacing: 0.2,
                  color: AppColors.blackTextColor,
                ),
              ),
            ),
          ),
          actions: [
            Consumer<LocaleModel>(
              builder: (context, localeModel, child) => DropdownButton(
                value: selectedLocale,
                items: [
                  DropdownMenuItem(
                    value: "en",
                    child: Text(
                      "English",
                      style: GoogleFonts.getFont(AppStrings.fontName,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 2.1,
                          letterSpacing: 0.2,
                          color: AppColors.blackTextColor),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "ar",
                    child: Text(
                      "عربي",
                      style: GoogleFonts.getFont(AppStrings.fontName,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 2.1,
                          letterSpacing: 0.2,
                          color: AppColors.blackTextColor),
                    ),
                  ),
                ],
                onChanged: (String? value) {
                  if (value != null) {
                    localeModel.set(Locale(value));
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  // SharedPreferences pref =
                  //     await SharedPreferences.getInstance();
                  // String str = todosToJson(notSyncedTodos);
                  // pref.setString(AppStrings.prefStringsNotSyncedTodos, str);
                  box.put(
                      AppStrings.frequencyBox,
                      box.get(AppStrings.frequencyBox, defaultValue: '6') ??
                          '6');
                  String frequencyStr =
                      box.get(AppStrings.frequencyBox, defaultValue: '6') ??
                          '6';
                  if (notSyncedTodos.isNotEmpty) {
                    // BlocProvider.of<TodoBloc>(context).add(LoadFbTodos());
                    ///To Open Sync Now BottomSheet
                    showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (builder) {
                        return Padding(
                          padding: MediaQuery.of(context).viewInsets,
                          child: SizedBox(
                              height: 310.h,
                              child: SyncNow(
                                taskStoSync: notSyncedTodos,
                                selectedFrequency: frequencyStr,
                              )),
                        );
                      },
                    );
                  } else {
                    appSnackBar(
                        data: allTodos.isEmpty
                            ? locale.todosMsgNo
                            : locale.todosMsg,
                        context: context);
                  }
                },
                icon: const Icon(
                  Icons.sync,
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
        body: BlocBuilder<TodoBloc, TodoState>(
          builder: (context, state) {
            if (state is TodoLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TodoLoaded) {
              allTodos = state.allTodos;
              List<Todo> onGoingTodos = [];
              List<Todo> completedTodos = [];
              notSyncedTodos.clear();
              for (var todo in allTodos) {
                todo!.isCompleted
                    ? completedTodos.add(todo)
                    : onGoingTodos.add(todo);
                if (!todo.isSynced) {
                  notSyncedTodos.add(todo);
                }
              }
              return Container(
                padding: const EdgeInsets.fromLTRB(16, 10, 24, 40),
                child: ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Text(
                        '${locale.ongoing} (${onGoingTodos.length})',
                        style: GoogleFonts.getFont(AppStrings.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 2.1,
                            letterSpacing: 0.2,
                            color: AppColors.blackTextColor),
                      ),
                    ),
                    onGoingTodos.isEmpty
                        ? Center(
                            child: Text(
                              locale.noOngoingTask,
                              style: GoogleFonts.getFont(AppStrings.fontName,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  height: 2.1,
                                  letterSpacing: 0.2,
                                  color: AppColors.blackTextColor),
                            ),
                          )
                        :

                        ///To List the OnGoing Todos
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(0.0),
                            itemCount: onGoingTodos.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final todo = onGoingTodos[index];
                              return CustomTile(
                                  task: todo,
                                  checkBox: Assets.png.check.image(),
                                  context: context,
                                  isDone: false);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: AppColors.dividerColor,
                              );
                            },
                          ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                      child: Text(
                        '${locale.completed}  (${completedTodos.length})',
                        style: GoogleFonts.getFont(AppStrings.fontName,
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            height: 2.1,
                            letterSpacing: 0.2,
                            color: AppColors.blackTextColor),
                      ),
                    ),
                    completedTodos.isEmpty
                        ? Center(
                            child: Text(
                              locale.noCompletedTask,
                              style: GoogleFonts.getFont(AppStrings.fontName,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 18,
                                  height: 2.1,
                                  letterSpacing: 0.2,
                                  color: AppColors.blackTextColor),
                            ),
                          )
                        :

                        ///To List the Completed Todos
                        ListView.separated(
                            itemCount: completedTodos.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              final todo = completedTodos[index];
                              return CustomTile(
                                  task: todo,
                                  checkBox: Assets.png.checkedIcon.image(),
                                  context: context,
                                  isDone: true);
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                color: AppColors.dividerColor,
                              );
                            },
                          ),
                  ],
                ),
              );
            } else if (state is TodoOperationSuccess) {
              todoBloc.add(LoadTodos()); // Reload todos
              return Container(); // Or display a success message
            } else if (state is TodoError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return Container();
            }
          },
        ),
        floatingActionButton: GestureDetector(
            key: AppStrings.addTodoFABKey,
            onTap: () {
              ///To Open Add Task BottomSheet
              showModalBottomSheet(
                enableDrag: false,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (builder) {
                  return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: SizedBox(height: 450.h, child: AddTask()));
                },
              );
            },
            child: Assets.svg.homepageFab.svg(height: 66.h, width: 66.w)));
  }
}
