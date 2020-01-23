import 'package:flutter/material.dart';
import 'package:solo_social/library.dart';

class Introduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'SoloSocial',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              bodyWidget: Text(
                'Tagline',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              footer: Text(
                'Tagline2',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'SoloSocial2',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              bodyWidget: Text(
                'Tagline',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              footer: Text(
                'Tagline2',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'SoloSocial3',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 30,
                ),
              ),
              bodyWidget: Text(
                'Tagline',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              footer: Text(
                'Tagline2',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
          onDone: () {},
          done: Text('Finish'),
          showNextButton: true,
          showSkipButton: true,
          skip: Text('Skip'),
          next: Text('Next'),
        ),
      ),
    );
  }
}
