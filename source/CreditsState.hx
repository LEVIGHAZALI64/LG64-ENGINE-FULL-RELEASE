package;

#if desktop
import Discord.DiscordClient;
#end
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;

using StringTools;

class CreditsState extends MusicBeatState
{
	var curSelected:Int = 1;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var iconArray:Array<AttachedSprite> = [];

	private static var creditsStuff:Array<Dynamic> = [ //Name - Icon name - Description - Link - BG Color
		['LEVI ENGINE Android Port'],
		['LG64',				'levi',			'Main Programmer of Levi Engine Android',			'https://youtube.com/c/LG64TUBE',	0xFFF73838],
		[''],
		['LEVI Engine Team'],
		['LEVI GHAZALI',		'levi',		'Main Programmer of Levi Engine',					'https://youtube.com/c/LG64TUBE',	0xFFFFDD33],
		['Haliza Putri Ghazali',			'haliza',		'Main Artist/Animator of Levi Engine',				'https://youtube.com/channel/UCLcYgsHrrPHTxZt_Uk19c5A',		0xFFC30085],
		[''],
		['Engine Contributors'],
		['Tristama',				'tristama',			'New Input System Programmer',						'https://twitter.com/Tristama_?s=20&t=_o2tcLeDzRnbEoSo9dvpNg',			0xFF4494E6],
		['Kimiri',		'kimiri',	'Animation Design',						'https://twitter.com/KimiriChan?s=20&t=_o2tcLeDzRnbEoSo9dvpNg',	0xFFE01F32],
		['Trake',			'trake',			'Chart Editor\'s Sound Waveform base',				'https://twitter.com/TrakeDaGamer?s=20&t=_o2tcLeDzRnbEoSo9dvpNg',			0xFFFF9300],
		['Knuxy03',				'knuxy',			'Give Motivation And My Best Friend',							'https://youtube.com/c/Knuxy03',			0xFFFFFFFF],
		['Nafri',			'nafri',		'Mascot\nMain Supporter of the Engine',		'https://youtube.com/c/Nafri4166',		0xFFD10616],
		['Radhila Alya',				'alya',		'Gacha Design"',	'https://youtube.com/channel/UCpUVd6eauHn9VnjUM89-jvA',	0xFF61536A],
		['Nichistuff',				'nichijou',		'Wanna See The BGM of Nichijou? well click here',	'https://youtube.com/user/NICHIstuffs',	'0xFF61536A'],
		['Anniki',			'anniki',		'Main Supporter of the Engine',		'https://twitter.com/rivergravidade?s=20&t=0bqZg6mzPiziwYFEcWanBQ',	'0xFFD10616'],
		['Brick ST',				'brick',		'Lead Animation Designer',	'https://twitter.com/Brick_ST_?s=20&t=0bqZg6mzPiziwYFEcWanBQ',	'0xFF61536A'],
		['Raiden alfares',				'raiden',		'Help Me For The Code Android Port',	'https://youtube.com/channel/UChE0s906J1YZRf1Ln9wP8Gg',	'0xFF61536A'],
		
		[''],
		["Funkin' Crew"],
		['ninjamuffin99',		'ninjamuffin99',	"Programmer of Friday Night Funkin'",				'https://twitter.com/ninja_muffin99',	0xFFF73838],
		['PhantomArcade',		'phantomarcade',	"Animator of Friday Night Funkin'",					'https://twitter.com/PhantomArcade3K',	0xFFFFBB1B],
		['evilsk8r',			'evilsk8r',			"Artist of Friday Night Funkin'",					'https://twitter.com/evilsk8r',			0xFF53E52C],
		['kawaisprite',			'kawaisprite',		"Composer of Friday Night Funkin'",					'https://twitter.com/kawaisprite',		0xFF6475F3]
	];

	var bg:FlxSprite;
	var descText:FlxText;
	var intendedColor:Int;
	var colorTween:FlxTween;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		add(bg);

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		for (i in 0...creditsStuff.length)
		{
			var isSelectable:Bool = !unselectableCheck(i);
			var optionText:Alphabet = new Alphabet(0, 70 * i, creditsStuff[i][0], !isSelectable, false);
			optionText.isMenuItem = true;
			optionText.screenCenter(X);
			if(isSelectable) {
				optionText.x -= 70;
			}
			optionText.forceX = optionText.x;
			//optionText.yMult = 90;
			optionText.targetY = i;
			grpOptions.add(optionText);

			if(isSelectable) {
				var icon:AttachedSprite = new AttachedSprite('credits/' + creditsStuff[i][1]);
				icon.xAdd = optionText.width + 10;
				icon.sprTracker = optionText;
	
				// using a FlxGroup is too much fuss!
				iconArray.push(icon);
				add(icon);
			}
		}

		descText = new FlxText(50, 600, 1180, "", 32);
		descText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		descText.scrollFactor.set();
		descText.borderSize = 2.4;
		add(descText);

		bg.color = creditsStuff[curSelected][4];
		intendedColor = bg.color;
		changeSelection();

		#if mobileC
		addVirtualPad(FULL, A_B);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.BACK)
		{
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}
		if(controls.ACCEPT) {
			CoolUtil.browserLoad(creditsStuff[curSelected][3]);
		}
		super.update(elapsed);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		do {
			curSelected += change;
			if (curSelected < 0)
				curSelected = creditsStuff.length - 1;
			if (curSelected >= creditsStuff.length)
				curSelected = 0;
		} while(unselectableCheck(curSelected));

		var newColor:Int = creditsStuff[curSelected][4];
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		var bullShit:Int = 0;

		for (item in grpOptions.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			if(!unselectableCheck(bullShit-1)) {
				item.alpha = 0.6;
				if (item.targetY == 0) {
					item.alpha = 1;
				}
			}
		}
		descText.text = creditsStuff[curSelected][2];
	}

	private function unselectableCheck(num:Int):Bool {
		return creditsStuff[num].length <= 1;
	}
}
