import 'package:flutter/material.dart';
import 'package:workmanager/workmanager.dart';

import '../utils/app_pages.dart';
import 'update_task.dart';

///Add Todos BottomSheet UI
class AddTask extends StatelessWidget {
  AddTask({super.key});

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 50, 25, 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0.9, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  cancelButton(context),
                  GestureDetector(
                    key: AppStrings.addTodoKey,
                    onTap: () {
                      bool isFieldValid =
                          AppStrings.addTaskFormKey.currentState!.validate();
                      if (isFieldValid) {
                        final todo = Todo(
                            id: DateTime.now().toString(),
                            title: titleController.text,
                            description: descriptionController.text,
                            createdDT: DateTime.now(),
                            updatedDT: DateTime.now(),
                            isCompleted: false,
                            isSynced: false);
                        BlocProvider.of<TodoBloc>(context).add(AddTodo(todo));
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      locale.add,
                      style: GoogleFonts.getFont(AppStrings.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          height: 1.4,
                          color: AppColors.blackTextColor),
                    ),
                  ),
                ],
              ),
            ),
            Form(
              key: AppStrings.addTaskFormKey,
              child: Column(
                children: [
                  CustomTextField(
                      textKey: AppStrings.addTitleKey,
                      controller: titleController,
                      title: locale.title,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return value?.trim().isValidTitle(context);
                      },
                      hintText: locale.titleHintText),
                  CustomTextField(
                      textKey: AppStrings.addDescKey,
                      controller: descriptionController,
                      textInputAction: TextInputAction.done,
                      title: locale.description,
                      onDone: (value) {
                        bool isFieldValid =
                            AppStrings.addTaskFormKey.currentState!.validate();

                        if (isFieldValid) {
                          final todo = Todo(
                              id: DateTime.now().toString(),
                              title: titleController.text,
                              description: descriptionController.text,
                              createdDT: DateTime.now(),
                              updatedDT: DateTime.now(),
                              isCompleted: false,
                              isSynced: false);
                          BlocProvider.of<TodoBloc>(context).add(AddTodo(todo));
                          Navigator.pop(context);
                        }
                        return null;
                      },
                      validator: (value) {
                        return value?.trim().isValidDesc(context);
                      },
                      hintText: locale.descriptionHintText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///Sync Now BottomSheet UI
class SyncNow extends StatefulWidget {
  const SyncNow({
    super.key,
    required this.taskStoSync,
    required this.selectedFrequency,
  });

  final List<Todo> taskStoSync;
  final String selectedFrequency;

  @override
  State<SyncNow> createState() => _SyncNowState();
}

class _SyncNowState extends State<SyncNow> {
  String selectedFrequency = '6';
  late Box<String> box;
  @override
  void initState() {
    super.initState();
    openHiveBox();
  }

  openHiveBox() async {
    selectedFrequency = widget.selectedFrequency;
    await Hive.openBox<String>(AppStrings.frequencyBox);
    box = Hive.box<String>(AppStrings.frequencyBox);
  }

  @override
  Widget build(BuildContext context) {
    selectedFrequency = widget.selectedFrequency;
    var locale = AppLocalizations.of(context)!;
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(25, 30, 25, 31),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<TodoBloc>(context)
                    .add(SyncTodo(widget.taskStoSync));
                Navigator.pop(context);
              },
              child: Text(
                locale.sync,
                style: GoogleFonts.getFont(AppStrings.fontName,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                    height: 1.4,
                    color: AppColors.blackTextColor),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  flex: 4,
                  child: Text(
                    locale.syncMsg,
                    style: GoogleFonts.getFont(AppStrings.fontName,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        height: 1.4,
                        color: AppColors.blackTextColor),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Flexible(
                  flex: 2,
                  child: DropdownButton(
                    value: selectedFrequency,
                    items: const [
                      DropdownMenuItem(
                        value: "4",
                        child: Text("4 hrs"),
                      ),
                      DropdownMenuItem(
                        value: "6",
                        child: Text("6 hrs"),
                      ),
                      DropdownMenuItem(
                        value: "12",
                        child: Text("12 hrs"),
                      ),
                      DropdownMenuItem(
                        value: "16",
                        child: Text("16 hrs"),
                      ),
                    ],
                    onChanged: (String? value) async {
                      selectedFrequency = value!;
                      box.put(AppStrings.frequencyBox, selectedFrequency);
                      Workmanager().cancelAll();
                      var uniqueIdentifier = DateTime.now().second.toString();
                      await Workmanager()
                          .registerPeriodicTask(
                        uniqueIdentifier,
                        AppStrings.taskName,
                        frequency:
                            Duration(hours: int.parse(selectedFrequency)),
                        constraints: Constraints(
                          networkType: NetworkType.connected,
                        ),
                      )
                          .then((onValue) {
                        Navigator.pop(context);
                        String frequencyStr = box.get(AppStrings.frequencyBox,
                                defaultValue: '6') ??
                            '6';
                        appSnackBar(
                            data:
                                "${locale.updateFrequencyMessage} $frequencyStr hours",
                            context: context);
                      });
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
                width: 150.w,
                child: ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<TodoBloc>(context)
                          .add(SyncTodo(widget.taskStoSync));
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blackTextColor,
                      fixedSize: Size(360.w, 50.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      locale.syncNow,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        color: AppColors.whiteColor,
                      ),
                    ))),
            SizedBox(
              height: 20.h,
            ),
            cancelButton(context)
          ],
        ),
      ),
    );
  }
}

///CustomText Field with box decorations
class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.title,
      required this.validator,
      required this.hintText,
      this.readOnly,
      required this.textKey,
      this.focusEnabled,
      this.focusNode,
      this.textInputAction,
      this.onDone});

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final String? Function(String? value)? validator;
  final String? Function(String? value)? onDone;
  final bool? readOnly;
  final ValueKey textKey;
  final bool? focusEnabled;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.fromLTRB(0.4, 0, 0.4, 5),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                title,
                style: GoogleFonts.getFont(AppStrings.fontName,
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    height: 1.4,
                    color: AppColors.blackTextColor),
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            onTapOutside: (eve) {
              if (focusNode != null) {
                focusNode!.unfocus();
              }
            },
            key: textKey,
            validator: validator,
            readOnly: readOnly ?? false,
            maxLines: title == locale.description ? 3 : 1,
            style: GoogleFonts.getFont(
              AppStrings.fontName,
              fontWeight: FontWeight.w400,
              fontSize: 13,
              color: AppColors.textColorLight,
            ),
            onFieldSubmitted: onDone,
            textInputAction: textInputAction,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 5,
                vertical: 5,
              ),
              errorStyle: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w400,
                fontSize: 12,
                height: 1.9,
                color: AppColors.salmonColor,
              ),
              hintText: hintText,
              hintStyle: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w400,
                fontSize: 13,
                color: AppColors.textColorLight,
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.borderColor),
              ),
            ),
          )
        ],
      ),
    );
  }
}

///CustomList Tile for Todos info
class CustomTile extends StatelessWidget {
  const CustomTile(
      {super.key,
      required this.task,
      required this.checkBox,
      required this.context,
      required this.isDone});

  final Todo task;
  final Widget checkBox;
  final BuildContext context;

  final bool isDone;
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Dismissible(
      onDismissed: (direction) {
        //
        messageAlertDelete(
            locale.deleteTodo, locale.deleteMsg, task, context, false);
      },
      key:UniqueKey(),/// use unique key for release version for integration testing use "Key(task.id)",
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (!task.isCompleted) {
                  messageAlertComplete(
                      locale.updateTitle, locale.updateMsg, task, context);
                }
              },
              child: Opacity(
                opacity: 0.8,
                child: SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: checkBox,
                ),
              ),
            ),
          ),
          Flexible(
            flex: 6,
            child: ListTile(
              title: Opacity(
                opacity: isDone ? 0.5 : 0.8,
                child: Wrap(
                  children: [
                    Text(
                      task.title,
                      style: GoogleFonts.getFont(AppStrings.fontName,
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          height: 1.3,
                          decoration:
                              isDone ? TextDecoration.lineThrough : null,
                          color: AppColors.blackTextColor),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    task.isSynced
                        ? Assets.png.cloudSyncDone
                            .image(height: 24.h, width: 24.w)
                        : Assets.png.cloud.image(height: 24.h, width: 24.w)
                  ],
                ),
              ),
              subtitle: Opacity(
                opacity: 0.5,
                child: Text(
                  '${DateFormat.yMMMEd().format(task.createdDT)} ${DateFormat('hh:mm a').format(task.createdDT)}',
                  style: GoogleFonts.getFont(AppStrings.fontName,
                      fontWeight: FontWeight.w400,
                      decoration: isDone ? TextDecoration.lineThrough : null,
                      fontSize: 14,
                      height: 1.4,
                      color: AppColors.blackTextColor),
                ),
              ),
              onTap: () {
                if (!task.isCompleted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => UpdateTask(
                                todo: task,
                              )));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

///cancel text button
Widget cancelButton(BuildContext context) {
  var locale = AppLocalizations.of(context)!;
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 11, 0),
      child: Opacity(
        opacity: 0.5,
        child: Text(
          locale.cancel,
          style: GoogleFonts.getFont(AppStrings.fontName,
              fontWeight: FontWeight.w600,
              fontSize: 16,
              height: 1.4,
              color: AppColors.blackTextColor),
        ),
      ),
    ),
  );
}

///message alert for delete Todos
messageAlertDelete(
    String ttl, String msg, Todo todo, BuildContext context, bool isNavigate) {
  var locale = AppLocalizations.of(context)!;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), //this right here
          child: Container(
            width: 310.w,
            height: 220.h,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ttl,
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      height: 1.5,
                      letterSpacing: 0.2,
                      color: AppColors.blackTextColor),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.3,
                      letterSpacing: 0.1,
                      color: AppColors.blackTextColor),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.blackTextColor,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.whiteColor,
                            ),
                            child: Center(
                              child: Text(
                                locale.cancel,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.9,
                                  letterSpacing: 0.1,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            BlocProvider.of<TodoBloc>(context)
                                .add(DeleteTodo(todo));
                            isNavigate
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => const HomePage()),
                                    (Route<dynamic> route) => false)
                                : Navigator.pop(context);
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.blackTextColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.boxShadowColor,
                                  offset: Offset(4, 8),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                locale.delete,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.9,
                                  letterSpacing: 0.1,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

///message alert for complete Todos
messageAlertComplete(String ttl, String msg, Todo todo, BuildContext context) {
  var locale = AppLocalizations.of(context)!;
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0)), //this right here
          child: Container(
            width: 310.w,
            height: 220.h,
            padding: const EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  ttl,
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 17,
                      height: 1.5,
                      letterSpacing: 0.2,
                      color: AppColors.blackTextColor),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.getFont('Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      height: 1.3,
                      letterSpacing: 0.1,
                      color: AppColors.blackTextColor),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.blackTextColor,
                              ),
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.whiteColor,
                            ),
                            child: Center(
                              child: Text(
                                locale.cancel,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.9,
                                  letterSpacing: 0.1,
                                  color: AppColors.blackTextColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            final todoUpdate = Todo(
                                id: todo.id,
                                title: todo.title,
                                description: todo.description,
                                createdDT: todo.createdDT,
                                updatedDT: DateTime.now(),
                                isCompleted: true,
                                isSynced: false);
                            BlocProvider.of<TodoBloc>(context)
                                .add(UpdateTodo(todoUpdate));
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 50.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: AppColors.blackTextColor,
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.boxShadowColor,
                                  offset: Offset(4, 8),
                                  blurRadius: 12,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                locale.update,
                                style: GoogleFonts.getFont(
                                  'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  height: 1.9,
                                  letterSpacing: 0.1,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      });
}

///common app snackBar
void appSnackBar(
    {required String data,
    Color? color,
    Duration? duration,
    required BuildContext context}) {
  if (data[data.length - 1] != ".") {
    data = "$data.";
  }
  final snackBar = SnackBar(
    duration: duration ?? const Duration(milliseconds: 4000),
    content: Text(
      data,
      style: const TextStyle(color: Colors.white),
    ),
    backgroundColor: color ?? AppColors.blackTextColor,
    showCloseIcon: true,
    closeIconColor: color != null ? AppColors.whiteColor : Colors.black,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
