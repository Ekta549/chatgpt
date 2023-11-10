import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _inputController = TextEditingController();
  final List<String> inputList = ['Hi'];
  final List<String> outputList = ['Hello! How can I help you?'];
  final List<String> inputList1 = ['What is chatgpt?'];
  final List<String> outputList1 = [
    'ChatGPT is an artificial intelligence (AI) chatbot that uses natural language processing to create humanlike conversational dialogue. The language model can respond to questions and compose various written content, including articles, social media posts, essays, code, and emails.'
  ];

  final Map<String, String> inputOutputMap = {
    'Hi': 'Hello! How can I help you?',
    'What is chatgpt?':
        'ChatGPT is an artificial intelligence (AI) chatbot that uses natural language processing to create humanlike conversational dialogue. The language model can respond to questions and compose various written content, including articles, social media posts, essays, code, and emails.'
  };

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }

  void _initializeAnimation() {
    _inputController.addListener(() {
      setState(() {}); // Trigger rebuild to update the animation
    });
  }

  void _submitInput() {
    final inputText = _inputController.text;
    String outputText;

    if (inputOutputMap.containsKey(inputText)) {
      outputText = inputOutputMap[inputText]!;
    } else {
      outputText = 'Output: $inputText';
      inputOutputMap[inputText] = outputText;
    }

    setState(() {
      inputList.add(inputText);
      outputList.add(outputText);
      _inputController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          DisplayList(
            inputList: inputList,
            outputList: outputList,
            
            inputList1: inputList1,
            outputList1: outputList1,
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _inputController,
                  decoration: const InputDecoration(
                    hintText: 'Send a message',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _submitInput,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DisplayList extends StatelessWidget {
  final List<String> inputList;
  final List<String> outputList;
  final List<String> inputList1;
  final List<String> outputList1;

  const DisplayList({
    required this.inputList,
    required this.outputList,
    required this.inputList1,
    required this.outputList1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: inputList.length + inputList1.length,
        itemBuilder: (context, index) {
          if (index < inputList.length) {
            return _buildRow('ES', inputList[index], outputList[index]);
          } else {
            final adjustedIndex = index - inputList.length;
            return _buildRow(
                'ES', inputList1[adjustedIndex], outputList1[adjustedIndex]);
          }
        },
      ),
    );
  }

  Widget _buildRow(String circleText, String inputText, String outputText) {
    return ListTile(
      title: Row(
        children: [
          Container(
            width: 24,
            height: 23,
            decoration: BoxDecoration(
              border: Border.all(
                color: const Color.fromARGB(255, 255, 239, 239),
              ),
              borderRadius: BorderRadius.circular(15.0),
              color: const Color.fromARGB(255, 93, 203, 97),
            ),
            child: Center(
              child: Text(
                circleText,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(inputText),
        ],
      ),
      subtitle: AnimatedOutputText(outputText),
    );
  }
}

class AnimatedOutputText extends StatefulWidget {
  final String text;

  const AnimatedOutputText(this.text, {Key? key}) : super(key: key);

  @override
  _AnimatedOutputTextState createState() => _AnimatedOutputTextState();
}

class _AnimatedOutputTextState extends State<AnimatedOutputText> {
  late TextEditingController _controller;
  late Completer<void> _animationCompleter;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.text);
    _animationCompleter = Completer<void>();
    _animateText();
  }

  Future<void> _animateText() async {
    await Future.delayed(const Duration(milliseconds: 500)); 
    _controller.text = ''; 
    await Future.delayed(const Duration(milliseconds: 100)); 
    for (var i = 0; i <= widget.text.length; i++) {
      _controller.text = widget.text.substring(0, i);
      await Future.delayed(const Duration(milliseconds: 50));
    }
    _animationCompleter.complete(); 
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _animationCompleter.future,
      builder: (context, snapshot) {
        return TextField(
          enabled: false,
          controller: _controller,
          decoration: const InputDecoration(
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}