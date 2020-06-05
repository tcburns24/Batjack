import 'package:blacktom/models/casino_slide.dart';
import 'package:blacktom/shared/palettes.dart';
import 'package:flutter/material.dart';

List<Map<String, dynamic>> casinos = [
  {
    'location': 'Gotham City PD',
    'locationImage': 'assets/casino_slides/gcpd.png',
    'dealerImage': 'assets/dealers/commissioner_gordon.jpg',
    'dealer': 'Commissioner Gordon',
    'villainColor': Colors.blue[900],
    'tableMin': 15,
    'tableMax': 200,
    'bgGradient': LinearGradient(colors: [Colors.blue[100], Colors.blueGrey[600]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 0,
    'wallpaper': 'assets/wallpapers/commissioner_gordon.jpg',
    'openCasino': 'gcpd',
    'welcomeMessage':
        '\"Batman, thank goodness you\’re here. Gotham is riddled with villainry. The city\’s most villainous villains, each more villainous than the last, are running rampant through the streets. The slack-jawed yokels of the GCPD are much too incompetent to catch these wily crooks; we\’ll need your eagle-eyed detective skills to track them down and defeat them. Remember, if you run out of chips you can exchange your batpoints for more. Now…let\’s play blackjack.\"'
  },
  {
    'location': 'Blackgate Penitentiary',
    'locationImage': 'assets/casino_slides/blackgate.jpg',
    'dealer': 'Bane',
    'dealerImage': 'assets/dealers/bane.jpg',
    'villainColor': Colors.brown[700],
    'tableMin': 25,
    'tableMax': 350,
    'bgGradient': LinearGradient(colors: [Colors.brown[400], Colors.brown[100]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 200,
    'wallpaper': 'assets/wallpapers/bane.jpg',
    'openCasino': 'blackgate',
    'welcomeMessage':
        '“Ah, Mr. Wayne. You come to Blackgate Penitentiary in search of riches, I see. You have betrayed the League of Shadows. For this I will break your spirit and deal you a 6 after you’ve doubled down on a 10. Then I will torture your soul when I get 21 after you\’ve stood on 20. Then Ras Al Ghul’s destiny will be complete. \n\nThen I will break you.”',
  },
  {
    'location': 'Arkham Asylum',
    'locationImage': 'assets/casino_slides/arkham_asylum.jpg',
    'dealerImage': 'assets/dealers/scarecrow.jpg',
    'dealer': 'Scarecrow',
    'villainColor': Color(0xffab621d),
    'tableMin': 35,
    'tableMax': 500,
    'bgGradient': LinearGradient(colors: [Colors.brown[300], Colors.grey[500]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 300,
    'wallpaper': 'assets/wallpapers/scarecrow.jpg',
    'openCasino': 'arkham',
    'welcomeMessage':
        '“Look who\’s here—the Batman. I\’m afraid this is where the road ends for you, oh brave one. Beneath your stoic exterior you tremble with the fear that your immeasurable wealth will run dry at the blackjack table. Just as your confidence runs high at the sight of being dealt an ace, I will terrorize you with a 4! Then I will strike fear deep into the hearts of Gothamites everywhere as they watch their savior, the Batman, crumble in horror at the sight of hitting on 16. HahahahahahahahahahahahahahahahaHAHAHAHAHAHAHAHAHA!”',
  },
  {
    'location': 'Iceberg Lounge',
    'locationImage': 'assets/casino_slides/iceberg_lounge.jpg',
    'dealerImage': 'assets/dealers/penguin.png',
    'dealer': 'Penguin',
    'villainColor': Colors.lightBlue[400],
    'tableMin': 50,
    'tableMax': 750,
    'bgGradient': LinearGradient(colors: [Colors.lightBlue[400], Colors.lightBlue[100]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 400,
    'wallpaper': 'assets/wallpapers/penguin.jpg',
    'openCasino': 'iceberg',
    'welcomeMessage':
        '“Hi Fatman! Welcome to Iceberg Lounge. Unfortunately you do-gooders aren\’t too welcome here. But before you make like a penguin and skeedaddle, why don\’t I ring you dry of your precious chips at the blackjack table. I know your pal Bruce Wayne funds all your operations—did he buy you those tights too? Let\’s see if that Wayne money stands up to my skills at the blackjack table.”',
  },
  {
    'location': 'Gotham Courthouse',
    'locationImage': 'assets/wallpapers/twoface_courthouse.png',
    'dealerImage': 'assets/dealers/twoface.png',
    'dealer': 'Twoface',
    'villainColor': Color(0xff9e1313),
    'tableMin': 60,
    'tableMax': 800,
    'bgGradient': LinearGradient(colors: [Colors.lightBlue[400], Colors.lightBlue[100]], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 500,
    'wallpaper': 'assets/wallpapers/twoface_wallpaper.jpg',
    'openCasino': 'courthouse',
    'welcomeMessage':
        '“Hello Bruce. You\’ve always been a loyal friend. Do you recall that day, here at Gotham Courthouse when a vile of acid scalded the left half of my face? Or perhaps when the left half of my body was doused in gasoline then set ablaze in a fire if you prefer Christopher Nolan\’s take? Whichever storyline you prefer the point is I\’m one of the better batman villains in that we\’re mirror images of each other. We each possess dual personalities, but you are able to control yours and channel them for good. Where as I expect compensation for my losses and channel my anger toward retribution against those who\’ve wronged me. We\’re not too different, Bruce. We\’re opposites yet the same, we\’re Yin and … fuck it, wanna play blackjack?”',
  },
  {
    'location': 'Ace Chemicals',
    'locationImage': 'assets/casino_slides/ace_chemicals.jpg',
    'dealer': 'Joker',
    'dealerImage': 'assets/dealers/joker.jpg',
    'villainColor': BatmanColors.jokerGreen,
    'tableMin': 75,
    'tableMax': 1000,
    'bgGradient': LinearGradient(colors: [BatmanColors.jokerPurple, BatmanColors.jokerGreen], begin: Alignment.topLeft, end: Alignment.bottomRight),
    'unlockAt': 600,
    'wallpaper': 'assets/wallpapers/joker.jpg',
    'openCasino': 'ace',
    'welcomeMessage': 'xyz',
  },
  {
    'location': 'Gotham Cemetary',
    'locationImage': 'assets/casino_slides/gotham_cemetary.jpg',
    'dealer': 'Mystery Villain',
    'dealerImage': 'assets/dealers/phantasm.jpg',
    'villainColor': Color(0xff1f1f1f),
    'tableMin': 100,
    'tableMax': 1000,
    'bgGradient': LinearGradient(colors: [Colors.black45, Colors.black87], begin: Alignment.topCenter, end: Alignment.bottomCenter),
    'unlockAt': 750,
    'wallpaper': 'assets/wallpapers/phantasm.jpg',
    'openCasino': 'cemetary',
    'welcomeMessage': 'xyz',
  }
];

List<Widget> allCasinos() {
  List<CasinoSlide> allCasinos = [];
  for (var i = 0; i < casinos.length; i++) {
    allCasinos.add(CasinoSlide(
      location: casinos[i]['location'],
      locationImage: casinos[i]['locationImage'],
      dealer: casinos[i]['dealer'],
      dealerImage: casinos[i]['dealerImage'],
      villainColor: casinos[i]['villainColor'],
      tableMin: casinos[i]['tableMin'],
      tableMax: casinos[i]['tableMax'],
      bgGradient: casinos[i]['bgGradient'],
      unlockAt: casinos[i]['unlockAt'],
      wallpaper: casinos[i]['wallpaper'],
      openCasino: casinos[i]['openCasino'],
      welcomeMssg: casinos[i]['welcomeMessage'],
    ));
  }
  return allCasinos;
}
