import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:test_bottom_navigation/sliding_up_panel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Stack(
          children: [
            Container(),
            SlidingUpPanelStateAnimator(
                minHeightFactor: 0.3,
                maxHeightFactor: 0.8,
                controller: PanelController(),
                builder: (panelScrollController) => NavigatorPage()),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => openSheet(context),
        //   tooltip: 'Increment',
        //   child: Icon(Icons.add),
        // ), // This trailing comma makes auto-formatting nicer for build methods.
      );
}

void openSheet(BuildContext context) async {
  showModalBottomSheet(
      context: (context),
      enableDrag: true,
      isDismissible: true,
      builder: (context) {
        return NavigatorPage();
      });
}

class NavigatorPage extends StatefulWidget {
  const NavigatorPage();

  @override
  _NavigatorPageState createState() => _NavigatorPageState();
}

class _NavigatorPageState extends State<NavigatorPage> {
  late TextEditingController _textEditingController;

  int _currentRoute = 0;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: List.generate(
            50,
            (index) => Card(
              child: ListTile(
                leading: const FlutterLogo(),
                title: Text('${index + 1} Item'),
                enabled: true,
                onTap: () {
                  if (_currentRoute != index) {
                    _textEditingController = TextEditingController();
                  }
                  _currentRoute = index;
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => DetailRoute(
                        textEditingController: _textEditingController,
                        index: index,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
}

class DetailRoute extends StatelessWidget {
  const DetailRoute({
    required this.textEditingController,
    required this.index,
  });

  final TextEditingController textEditingController;
  final int index;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: TextField(controller: textEditingController),
      );
}
