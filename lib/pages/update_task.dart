import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/app_pages.dart';
///update Task Screen
class UpdateTask extends StatefulWidget {
  const UpdateTask({super.key, required this.todo});

  final Todo todo;

  @override
  State<UpdateTask> createState() => _UpdateTaskState();
}

class _UpdateTaskState extends State<UpdateTask> {
  bool isEditing = false;
  TextEditingController? titleController;
  TextEditingController? descriptionController;

  @override
  void initState() {
    super.initState();
    setValues();
  }

  ///setting up values for existing Todos
  setValues() {
    titleController = TextEditingController(text: widget.todo.title);
    descriptionController =
        TextEditingController(text: widget.todo.description);
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          surfaceTintColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 18, left: 0, right: 0, bottom: 12),
              child: SizedBox(
                height: 24.h,
                width: 24.w,
                child: Assets.svg.backIcon.svg(),
              ),
            ),
          ),
          centerTitle: true,
          title: Opacity(
            opacity: 0.5,
            child: Text(
              widget.todo.title,
              style: GoogleFonts.getFont(
                AppStrings.fontName,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                height: 1.9,
                letterSpacing: 0.2,
                color: AppColors.blackTextColor,
              ),
            ),
          ),
          actions: [
            PopupMenuButton(
              key:AppStrings.popUpKey,
              color: AppColors.whiteColor,
              icon: SizedBox(
                height: 24.h,
                width: 24.w,
                child: Assets.svg.threeDot.svg(),
              ),
              itemBuilder: (BuildContext context) {
                return [
                  customPopupItem(() {
                    setState(() {
                      isEditing = true;
                    });
                    if (Navigator.canPop(context)) Navigator.of(context).pop();
                  }, Assets.svg.editIcon.svg(), locale.edit,AppStrings.editTodoKey),
                  customPopupItem(() {
                    messageAlertDelete(locale.deleteTodo, locale.deleteMsg,
                        widget.todo, context, true);
                  }, Assets.svg.deleteIcon.svg(), locale.delete,AppStrings.deleteTodoKey),
                  customPopupItem(
                      () {
                        Share.share('Todo ${widget.todo.title} is for ${widget.todo.description}');
                      }, Assets.svg.shareIcon.svg(), locale.share,AppStrings.shareTodoKey),
                ];
              },
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Form(
                  key: AppStrings.updateTaskFormKey,
                  child: Column(
                    children: [
                      if (isEditing)
                        CustomTextField(
                            controller: titleController,
                            title: locale.title,
                            textKey: AppStrings.updateTitleKey,
                            readOnly: !isEditing,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              return value?.trim().isValidTitle(context);
                            },
                            hintText: widget.todo.title),
                      CustomTextField(
                          textInputAction: TextInputAction.done,
                          onDone:(value){

                            final todo = Todo(
                                id: widget.todo.id,
                                title: isEditing
                                    ? titleController!.text
                                    : widget.todo.title,
                                description: isEditing
                                    ? descriptionController!.text
                                    : widget.todo.description,
                                createdDT: widget.todo.createdDT,
                                updatedDT: DateTime.now(),
                                isCompleted:
                                isEditing ? widget.todo.isCompleted : true,
                                isSynced: false);
                            BlocProvider.of<TodoBloc>(context)
                                .add(UpdateTodo(todo));
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const HomePage()),(Route<dynamic> route) => false);
                            return null;
                          },
                          textKey: AppStrings.updateDescKey,
                          controller: descriptionController,
                          title: locale.description,
                          readOnly: !isEditing,
                          validator: (value) {
                            return value?.trim().isValidDesc(context);
                          },
                          hintText: widget.todo.description),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 20),
                    child: ElevatedButton(
                      key: AppStrings.updateTodoKey,
                        onPressed: () {
                          final todo = Todo(
                              id: widget.todo.id,
                              title: isEditing
                                  ? titleController!.text
                                  : widget.todo.title,
                              description: isEditing
                                  ? descriptionController!.text
                                  : widget.todo.description,
                              createdDT: widget.todo.createdDT,
                              updatedDT: DateTime.now(),
                              isCompleted:
                                  isEditing ? widget.todo.isCompleted : true,
                              isSynced: false);
                          BlocProvider.of<TodoBloc>(context)
                              .add(UpdateTodo(todo));
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const HomePage()),(Route<dynamic> route) => false);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blackTextColor,
                          fixedSize: Size(360.w, 50.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          isEditing ? locale.update : locale.markAsComplete,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17.sp,
                            color: AppColors.whiteColor,
                          ),
                        ))),
              ],
            ),
          ),
        ));
  }
  ///custom popup menu item with icons
  PopupMenuItem customPopupItem(onPressed, Widget icon, String title,ValueKey key) {
    return PopupMenuItem(
      child: InkWell(
        onTap: onPressed,
        key: key,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
              width: 20.w,
              height: 20.h,
              child: icon,
            ),
            SizedBox(width: 10.w),
            Text(
              title,
              style: GoogleFonts.getFont(
                AppStrings.fontNameManRope,
                fontWeight: FontWeight.w600,
                fontSize: 16,
                height: 1.5,
                color: const Color(0xFF1C2A3A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
