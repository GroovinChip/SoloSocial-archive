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
                'Welcome to',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  //fontSize: 40,
                ),
              ),
              bodyWidget: Text(
                'SoloSocial',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              footer: Text(
                'Your private timeline',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'If you\'ve ever hesitated to post on social media',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  //fontSize: 30,
                ),
              ),
              bodyWidget: Text(
                'but still want to express those thoughts',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              footer: Text(
                'SoloSocial is the answer',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'SoloSocial looks like a social media app - but it\'s totally private! Only you can see your posts.',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  //fontSize: 30,
                ),
              ),
              bodyWidget: Text(
                'You can share them to real social media if you want',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              footer: Text(
                'Or simply keep them for yourself',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'You own your data on SoloSocial.',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  //fontSize: 30,
                ),
              ),
              bodyWidget: Text(
                'Download a copy of all your posts',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              footer: Text(
                'When you delete posts, they\'re gone for good - we don\'t keep hang on to them.',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            PageViewModel(
              image: Placeholder(),
              titleWidget: Text(
                'Ready to get started?',
                style: TextStyle(
                  //fontWeight: FontWeight.bold,
                  color: Colors.white,
                  //fontSize: 30,
                ),
              ),
              bodyWidget: SignInButton(
                Buttons.Google,
                onPressed: () {
                  //todo: implement google auth
                  Navigator.of(context).pushNamedAndRemoveUntil('/PostFeed', (route) => false);
                },
              ),
            ),
          ],
          curve: Curves.easeInCubic,
          animationDuration: 600,
          onDone: () {},
          done: Container(),
          showNextButton: true,
          showSkipButton: true,
          skip: Text('Skip'),
          onSkip: () {},
          next: Text('Next'),
          dotsDecorator: DotsDecorator(
            activeColor: Theme.of(context).accentColor,
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
            ),
            size: const Size.square(10.0),
            activeSize: const Size(20.0, 10.0),
          ),
        ),
      ),
    );
  }
}
