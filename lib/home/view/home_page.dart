import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as ui;

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watermark/model/local_photo.dart';
import 'package:watermark/permission.dart';
import 'package:watermark/photo/view/photo_detail_page.dart';
import 'package:watermark/photo/view/photo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? imageFile;

  List<AssetEntity> originalImageList = [];

  List<LocalPhoto> watermarkedImageList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Watermark',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => pickImage(),
            child: const Text(
              '앨범',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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
          itemCount: watermarkedImageList.length,
          itemBuilder: (context, index) {
            final LocalPhoto entity = watermarkedImageList[index];
    
            return InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => PhotoDetailPage(file: entity.image))),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      image: FileImage(entity.image),
                      width: 80,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black26,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text(
                          entity.name,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    );
  }

  Future<void> pickImage() async {
    try {
      final bool isGranted = await AppPermission.requestAlbum();

      if (isGranted == false) return;

      await getPhotoList().then((List<AssetEntity> photoList) async {
        final List<AssetEntity> result = await Navigator.of(context).push(MaterialPageRoute(builder: (_) => PhotoPage(photoList: photoList)));

        setState(() => originalImageList = result);

        final List<LocalPhoto> watermarkedList = await getLocalPhotoList(result);

        setState(() => watermarkedImageList = watermarkedList);

      });

    } catch (e) {
      debugPrint('[pickImage] err: $e');
    }
  }

  Future<List<AssetEntity>> getPhotoList() async {
    final List<AssetEntity> result = await PhotoManager.getAssetListPaged(
      page: 0,
      pageCount: 80,
      type: RequestType.image,
      filterOption: FilterOptionGroup(
        imageOption: const FilterOption(
          needTitle: true,
          sizeConstraint: SizeConstraint(ignoreSize: true),
        )
      ),
    );

    // 생성 날짜 정렬
    result.sort((a, b) => b.createDateTime.compareTo(a.createDateTime));

    return result;
  }

  Future<List<LocalPhoto>> getLocalPhotoList(List<AssetEntity> photoList) async {
    List<LocalPhoto> result = [];

    for (AssetEntity entity in photoList) {
      File? file = await entity.file;

      if (file == null) continue;

      file = await putWatermark(file: file, createdAt: entity.createDateTime);
      
      result.add(LocalPhoto(
        id: entity.id,
        name: entity.title ?? '',
        createdAt: entity.createDateTime,
        image: file,
      ));
    }

    return result;
  }

  Future<File> putWatermark({required File file, required DateTime createdAt}) async {
    ui.Image? image = ui.decodeImage(file.readAsBytesSync());

    final fontData = await rootBundle.load('assets/SpoqaHanSansNeo-Bold.ttf.zip');

    ui.BitmapFont font =  ui.BitmapFont.fromZip(fontData.buffer.asUint8List());

    ui.drawString(image!, '$createdAt', font: font, x: 20, y: 56);

    return File(file.path).writeAsBytes(ui.encodeJpg(image));
  }
}