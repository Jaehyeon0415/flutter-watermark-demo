import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoPage extends StatefulWidget {
  const PhotoPage({
    super.key,
    required this.photoList,
  });

  final List<AssetEntity> photoList;

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  List<AssetEntity> selectedPhotoList = [];

  void updateSelectedPhotoList(AssetEntity entity) {
    if (selectedPhotoList.any((e) => e.id == entity.id)) {

      selectedPhotoList.removeWhere((element) => element.id == entity.id);

    } else {

      selectedPhotoList.add(entity);

    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text(
            '앨범',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () => Navigator.pop(context, selectedPhotoList),
              icon: const Icon(Icons.close_rounded, color: Colors.black),
            ),
            const SizedBox(width: 16),
          ],
        ),
        body: GridView.builder(
          padding: const EdgeInsets.fromLTRB(8, 24, 8, 24),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: widget.photoList.length,
          itemBuilder: (context, index) {
            final AssetEntity entity = widget.photoList[index];
            final bool isSelected = selectedPhotoList.any((e) => e.id == entity.id);
    
            return InkWell(
              onTap: () => updateSelectedPhotoList(entity),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  clipBehavior: Clip.none,
                  children: [
                    Image(
                      image: AssetEntityImageProvider(entity, isOriginal: false),
                      width: 80,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: SizedBox(
                        width: 35,
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? Colors.blue : Colors.white.withOpacity(0.6),
                              border: isSelected ? null : Border.all(color: Colors.grey.shade300, width: 2),
                            ),
                            child: isSelected
                              ? Align(
                                child: Text(
                                    '${selectedPhotoList.indexWhere((e) => e.id == entity.id) + 1}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                              )
                              : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}