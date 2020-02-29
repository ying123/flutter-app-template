import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:canknow_flutter_ui/components/ApplicationAppBar.dart';
import 'package:canknow_flutter_ui/components/Spaces.dart';
import 'package:canknow_flutter_ui/components/TextButton.dart';
import 'package:canknow_flutter_ui/config/Scene.dart';
import 'package:canknow_flutter_ui/styles/variables.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show ImageByteFormat, Image;

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  /// 标记签名画板的Key，用于截图
  GlobalKey _globalKey;
  /// 已描绘的点
  List<Offset> _points = <Offset>[];

  /// 记录截图的本地保存路径
  String _imageLocalPath;

  @override
  void initState() {
    super.initState();
    _globalKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ApplicationAppBar(
        backgroundColor: Variables.appBarColor,
          brightness: Brightness.light,
          centerTitle: true,
          title: Text('Drawing Board')),
      body: Container(
        margin: EdgeInsets.all(Variables.contentPadding),
        child: Column(
          children: <Widget>[
            Container(
              height: 180.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Variables.borderColor, width: Variables.borderWidth),
              ),
              child: RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: [
                    GestureDetector(
                      onPanUpdate: (details) => _addPoint(details),
                      onPanEnd: (details) => _points.add(null),
                    ),
                    CustomPaint(painter: BoardPainter(_points)),
                  ],
                ),
              ),
            ),
            Spaces.vComponentSpan,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: TextButton(
                      text: "clear",
                      scene: Scene.primary,
                      onTap: () async {
                        setState(() {
                          _points?.clear();
                          _points = [];
                          _imageLocalPath = null;
                        });
                      }
                  ),
                ),
                Spaces.hComponentSpan,
                Expanded(
                  child: TextButton(
                      text: "shot",
                      scene: Scene.primary,
                      onTap: () async {
                        File toFile = await _saveImageToFile();
                        String toPath = await _capturePng(toFile);
                        print('Signature Image Path: $toPath');
                        setState(() {
                          _imageLocalPath = toPath;
                        });
                      }
                  ),
                )
              ],
            ),
            Spaces.vComponentSpan,
            Container(
              height: 180.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Variables.borderColor, width: Variables.borderWidth),
              ),
              child: Image.file(File(_imageLocalPath ?? '')),
            )
          ],
        ),
      ),
    );
  }

  /// 添加点，注意不要超过Widget范围
  _addPoint(DragUpdateDetails details) {
    RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    // 校验范围
    if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
    if (localPosition.dx > maxW || localPosition.dy > maxH) return;
    setState(() {
      _points = List.from(_points)..add(localPosition);
    });
  }

  /// 选取保存文件的路径
  Future<File> _saveImageToFile() async {
    Directory tempDir = await getTemporaryDirectory();
    int curT = DateTime.now().millisecondsSinceEpoch;
    String toFilePath = '${tempDir.path}/$curT.png';
    File toFile = File(toFilePath);
    bool exists = await toFile.exists();
    if (!exists) {
      await toFile.create(recursive: true);
    }
    return toFile;
  }

  /// 截图，并且返回图片的缓存地址
  Future<String> _capturePng(File toFile) async {
    // 1. 获取 RenderRepaintBoundary
    RenderRepaintBoundary boundary = _globalKey.currentContext.findRenderObject();
    // 2. 生成 Image
    ui.Image image = await boundary.toImage();
    // 3. 生成 Uint8List
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // 4. 本地存储Image
    toFile.writeAsBytes(pngBytes);
    return toFile.path;
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(BoardPainter other) => other.points != points;
}
