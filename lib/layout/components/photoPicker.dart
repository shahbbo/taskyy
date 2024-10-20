import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskyy/layout/AddTask/cubit/add_task_cubit.dart';

void showSelectPhotoOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(25.0),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.28,
        maxChildSize: 0.4,
        minChildSize: 0.28,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: SelectPhotoOptionsScreen(
              onTap: AddTaskCubit.get(context).getPostImage,
            ),
          );
        }),
  );
}

class SelectPhotoOptionsScreen extends StatelessWidget {
  final Function(ImageSource source) onTap;
  const SelectPhotoOptionsScreen({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.grey.shade300,
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -35,
            child: Container(
              width: 50,
              height: 6,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Column(children: [
            SelectPhoto(
              onTap: () => onTap(ImageSource.gallery),
              icon: Icons.image,
              textLabel: 'Browse Gallery',
            ),
            const SizedBox(
              height: 10,
            ),
            const Center(
              child: Text(
                'OR',
                style: TextStyle(fontSize: 18, color: Color(0xFF5F33E1)),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SelectPhoto(
              onTap: () => onTap(ImageSource.camera),
              icon: Icons.camera_alt_outlined,
              textLabel: 'Use a Camera',
            ),
          ])
        ],
      ),
    );
  }
}

class SelectPhoto extends StatelessWidget {
  final String textLabel;
  final IconData icon;

  final void Function()? onTap;

  const SelectPhoto({
    super.key,
    required this.textLabel,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        elevation: 10, backgroundColor: Colors.grey.shade200,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 6,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              icon,
              color: const Color(0xFF5F33E1),
            ),
            const SizedBox(
              width: 14,
            ),
            Text(
              textLabel,
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFF5F33E1),
              ),
            )
          ],
        ),
      ),
    );
  }
}