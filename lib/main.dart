import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter/material.dart';
import 'package:test/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController textEditingController;
  late final OpenAI openAI;

  @override
  void initState() {
    textEditingController = TextEditingController();
    openAI = OpenAI.instance.build(
        token: OPENAI_API_KEY,
        baseOption: HttpSetup(receiveTimeout: 120000),
        isLogger: true);
    super.initState();
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  _sendMessage() async {
    final requet = CompleteText(
      prompt: textEditingController.value.text,
      model: kTranslateModelV3,
      maxTokens: 200,
      temperature: 0.9,
      topP: 1,
    );

    openAI
        .onCompleteStream(request: requet)
        .listen((event) => print(event))
        .onError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (context, index) {
                return Container();
              },
              separatorBuilder: (context, index) => const SizedBox(
                height: 12,
              ),
              itemCount: 1,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(hintText: 'Type in...'),
                  onFieldSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              ClipOval(
                child: Material(
                  color: Colors.blue, // Button color
                  child: InkWell(
                    onTap: _sendMessage,
                    child: const SizedBox(
                      width: 48,
                      height: 48,
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
