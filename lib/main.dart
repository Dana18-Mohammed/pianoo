import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_midi/flutter_midi.dart';
import 'package:piano/piano.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MusicPiano(),
    );
  }
}

class MusicPiano extends StatefulWidget {
  @override
  State<MusicPiano> createState() => MusicPianoState();
}

class MusicPianoState extends State<MusicPiano> {
  final FlutterMidi flutterMidi = FlutterMidi();
  String path = 'Email';
  String musicPath = "assets/guitars.sf2";

  @override
  void initState() {
    load(musicPath);
    super.initState();
  }

  void load(String asset) async {
    flutterMidi.unmute();
    ByteData byteData = await rootBundle.load(asset);
    flutterMidi.prepare(sf2: byteData, name: path.replaceAll('assets/', ''));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton(
            value: musicPath,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            items: [
              DropdownMenuItem(
                value: 'assets/guitars.sf2',
                child: Row(
                  children: const [
                    Text('guitars'),
                    Icon(
                      Icons.music_note_outlined,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'assets/flute.sf2',
                child: Row(
                  children: const [
                    Text('flute'),
                    Icon(
                      Icons.music_note_rounded,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
              DropdownMenuItem(
                value: 'assets/piano.sf2',
                child: Row(
                  children: const [
                    Text('Piano'),
                    Icon(
                      Icons.music_note_sharp,
                      color: Colors.black54,
                    )
                  ],
                ),
              ),
            ],
            onChanged: (String? value) {
              setState(() {
                musicPath = value!;
                load(value);
              });
            },
          )
        ],
        leadingWidth: 300,
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: const Text('Music'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Center(
            child: SizedBox(
              width: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.width
                  : MediaQuery.of(context).size.height,
              height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height
                  : MediaQuery.of(context).size.width,
              child: InteractivePiano(
                highlightedNotes: [NotePosition(note: Note.C, octave: 3)],
                naturalColor: Colors.white,
                accidentalColor: Colors.black,
                keyWidth: 60,
                noteRange: NoteRange.forClefs(
                  [
                    Clef.Treble,
                  ],
                ),
                onNotePositionTapped: (position) {
                  // print(position.pitch);
                  flutterMidi.playMidiNote(midi: position.pitch);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
