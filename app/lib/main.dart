import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:presenter/presenter.dart';
import 'package:usecase/usecase.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLoC Clean Architecture',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (context) => TextBloc(updateTextUseCase: UpdateTextUseCaseImpl()),
        child: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  StreamSubscription? _sideEffectSubscription;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _sideEffectSubscription = context.read<TextBloc>().sideEffectStream.listen((effect) {
      if (effect is ShowLoading) {
        setState(() {
          _isLoading = true;
        });
      } else if (effect is HideLoading) {
        setState(() {
          _isLoading = false;
        });
      } else if (effect is ShowError) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(effect.message)));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLoC Side Effect')),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                BlocBuilder<TextBloc, TextState>(
                  builder: (context, state) {
                    if (state.textEntity != null) {
                      return Text(state.textEntity!.text, style: Theme.of(context).textTheme.headlineMedium);
                    } else {
                      return const Text('Enter text and press save');
                    }
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(border: OutlineInputBorder(), labelText: 'Enter Text'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    context.read<TextBloc>().add(SaveButtonPressed(_controller.text));
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _sideEffectSubscription?.cancel();
    super.dispose();
  }
}
