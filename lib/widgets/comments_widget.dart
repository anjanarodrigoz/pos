import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pos/repositories/comment_template_repository.dart';

import 'pos_text_form_field.dart';

class CommentsDialog extends StatefulWidget {
  String oldComment;
  Function(String) onPressed;
  CommentsDialog({super.key, this.oldComment = '', required this.onPressed});

  @override
  State<CommentsDialog> createState() => _CommentsDialogState();
}

class _CommentsDialogState extends State<CommentsDialog> {
  final CommentTemplateRepository _templateRepo = Get.find<CommentTemplateRepository>();
  late String oldComment;
  late Function(String) onPressed;
  TextEditingController commentController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    oldComment = widget.oldComment;
    onPressed = widget.onPressed;
  }

  @override
  Widget build(BuildContext context) {
    commentController.text = oldComment;
    return SizedBox(
      width: 500.0,
      height: 600.0,
      child: AlertDialog(
        title: const Text('Add Comments'),
        content: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        PosTextFormField(
                          onChanged: (query) {
                            setState(() {
                              searchQuery = query;
                            });
                          },
                          hintText: 'Search Comments',
                          prefixIcon: const Icon(
                            Icons.search,
                          ),
                        ),
                        IconButton(
                            splashRadius: 25.0,
                            onPressed: () {
                              showAddCommentsDialog();
                            },
                            iconSize: 28.0,
                            icon: const Icon(Icons.add)),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: 400.0,
                      height: 430.0,
                      child: StreamBuilder(
                        stream: _templateRepo.watchAllTemplates(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(child: Text('No saved comments'));
                          }

                          final templates = snapshot.data!;

                          // Filter by search query
                          final filteredTemplates = searchQuery.isEmpty
                              ? templates
                              : templates
                                  .where((t) =>
                                      t.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                                      t.comment.toLowerCase().contains(searchQuery.toLowerCase()))
                                  .toList();

                          return ListView.separated(
                            itemCount: filteredTemplates.length,
                            itemBuilder: (context, index) {
                              final template = filteredTemplates[index];
                              String name = template.name;
                              String comment = template.comment;

                              return ListTile(
                                trailing: IconButton(
                                    splashRadius: 20.0,
                                    onPressed: () async {
                                      await _templateRepo.deleteTemplate(template.id);
                                    },
                                    icon: const Icon(Icons.delete)),
                                title: Text(name),
                                subtitle: Text(
                                  comment,
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                ),
                                onTap: () {
                                  String newComment =
                                      commentController.text.toString();
                                  newComment += comment;
                                  oldComment = newComment;
                                  setState(() {});
                                },
                              );
                            },
                            separatorBuilder: (BuildContext context, int index) {
                              return const Divider();
                            },
                          );
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: PosTextFormField(
                width: 400.0,
                height: 550.0,
                maxLines: 30,
                keyboardType: TextInputType.multiline,
                labelText: 'Comment',
                controller: commentController,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              String comment = commentController.text;
              onPressed(comment);
              Navigator.of(context).pop();
            },
            child: const Text('Add to Invoice'),
          ),
        ],
      ),
    );
  }

  void showAddCommentsDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController commentController = TextEditingController();

    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Add New Comment'),
              content: SizedBox(
                height: 400.0,
                child: Column(children: [
                  PosTextFormField(
                    controller: nameController,
                    labelText: 'Comment name',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  PosTextFormField(
                    maxLines: 10,
                    height: 300.0,
                    controller: commentController,
                    labelText: 'Comment',
                  )
                ]),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      String name = nameController.text.toString();
                      String comment = commentController.text.toString();

                      if (name.isNotEmpty && comment.isNotEmpty) {
                        await _templateRepo.createTemplate(
                          name: name,
                          comment: comment,
                        );
                      }
                      Navigator.of(context).pop();
                    },
                    child: const Text('Save'))
              ],
            ));
  }
}
