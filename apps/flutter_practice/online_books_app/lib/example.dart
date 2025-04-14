import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppLinks _appLinks = AppLinks();

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  // Lắng nghe deep link khi ứng dụng được mở
  Future<void> _initDeepLinks() async {
    // Kiểm tra khi ứng dụng được mở từ deep link
    _appLinks.getInitialLink().then((link) {
      if (link != null) {
        setState(() {});
        _handleLinkAction(link);
      }
    });

    // Lắng nghe deep link khi ứng dụng đang chạy
    _appLinks.uriLinkStream.listen((uri) {
      setState(() {});
      _handleLinkAction(uri);
    });
  }

  // Xử lý hành động khi click vào deep link
  void _handleLinkAction(Uri link) {
    if (link.pathSegments.isNotEmpty && link.pathSegments.first == 'detail') {
      String itemId = link.queryParameters['id'] ?? 'Không có ID';
      // Điều hướng đến trang Detail với ID
      Get.to(() => DetailPage(itemId: itemId));
    }
  }

  // Chia sẻ liên kết
  void _shareLink(int id) {
    String url = 'https://online-books-app.web.app/share?id=$id';
    Share.share('Check out this item at $url');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Item ${index + 1}'),
            onTap: () =>
                Get.to(() => DetailPage(itemId: (index + 1).toString())),
            trailing: IconButton(
              icon: Icon(Icons.share),
              onPressed: () => _shareLink(index + 1),
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final String itemId;
  const DetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detail Page')),
      body: Center(
        child: Text('Detail for item $itemId'),
      ),
    );
  }
}
