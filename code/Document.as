//John Watson
//Programming Project

package code
{

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.TextFormat;

	public class Document extends MovieClip
	{
		public var docBuffaloDates:Array = new Array();
		public var docBuffaloTemps:Array = new Array();

		//Number variable that holds the number of the inputed date and the dates temperature
		private var currentNum:Number;

		//String variable that keeps the selected difficulty
		private var gameDifficulty:String;

		//Guessing variables for the Temperature Guess Frame
		private var guess:String;
		private var guessNumber:Number;
		private var currentTemp:Number;

		//Win Screen Results
		private var timesGuessed:int;
		private var timesHot:int = 0;
		private var timesCold:int = 0;
		private var timesWarm:int = 0;

		//Booleans for if its the first time the player starts the game or guesses a temperature
		private var firstStart:Boolean = true;
		private var firstGuess:Boolean = true;

		public function Document()
		{
			//Stops the game at frame 1 (Main Menu)
			this.stop();

			//Create a FileLoader object to load and put data into arrays
			var buffaloFileLoader:FileLoader = new FileLoader(this);

			btn_startGame.addEventListener(MouseEvent.CLICK, startGame);
			btn_howToPlay.addEventListener(MouseEvent.CLICK, showRules);
		}
		
		public function showRules(e:MouseEvent):void
		{
			this.gotoAndStop(5);
			
			btn_backToMain.addEventListener(MouseEvent.CLICK, backToMain);
		}
		
		public function backToMain(e:MouseEvent):void
		{
			//Remove the backtoMain event listener
			btn_backToMain.removeEventListener(MouseEvent.CLICK, backToMain);
			
			//Go back to main menu and remove event listeners, then readd them
			this.gotoAndStop(1);
			btn_startGame.removeEventListener(MouseEvent.CLICK, startGame);
			btn_howToPlay.removeEventListener(MouseEvent.CLICK, showRules);
			btn_startGame.addEventListener(MouseEvent.CLICK, startGame);
			btn_howToPlay.addEventListener(MouseEvent.CLICK, showRules);
		}

		public function startGame(e:MouseEvent):void
		{
			this.gotoAndStop(2);

			if (this.firstStart == true)
			{
				//Input Date Text Settings (Size, Font, and Color)
				var inputDateFormat:TextFormat = new TextFormat();
				inputDateFormat.font = "Rockwell";
				inputDateFormat.size = 85;
				inputDateFormat.color = 0xFF0000;
				inputDate.setStyle("textFormat", inputDateFormat);
			}

			//Adds all the buttons to the stage
			btn_submitDate.addEventListener(MouseEvent.CLICK, dateSubmit);
			btn_easy.addEventListener(MouseEvent.CLICK, easyGame);
			btn_medium.addEventListener(MouseEvent.CLICK, mediumGame);
			btn_hard.addEventListener(MouseEvent.CLICK, hardGame);



			//Hides difficulty buttons until a valid date is inputed into the game
			btn_easy.visible = false;
			btn_medium.visible = false;
			btn_hard.visible = false;
			continue_txt.text = "";
		}

		public function dateSubmit(e:MouseEvent):void
		{
			var date:String;
			var dateAccepted:Boolean = false;
			date = inputDate.text;
			trace(date);

			//Check if the entered date is in the array, and make that certain number
			//the variable currentNum
			for (var i:int = 0; i < 6209; i++)
			{
				var currentDate:String;

				currentDate = this.docBuffaloDates[i].toString();

				if (date == currentDate)
				{
					currentNum = i;
					dateAccepted = true;
					i = 6209;
				}
			}

			//If date is accepted, show all the buttons and show valid date text
			if (dateAccepted == true)
			{
				accepted_txt.text = "Date Accepted!";
				continue_txt.text = "Continue on Selected Difficulty:";
				invalid_txt.text = "";
				btn_easy.visible = true;
				btn_medium.visible = true;
				btn_hard.visible = true;
				dateAccepted = false;
			}
			//If date is invalid, hide all buttons and make currentNum equal to -1
			else
			{
				invalid_txt.text = "Invalid Date!";
				continue_txt.text = "";
				accepted_txt.text = "";
				btn_easy.visible = false;
				btn_medium.visible = false;
				btn_hard.visible = false;
				currentNum = -1;
			}

			trace(currentNum);
		}

		
		//Depending on which button clicked, set the this.gameDifficulty to it and go to
		//the tempGuessFrame() method.
		
		
		public function easyGame(e:MouseEvent):void
		{
			this.gameDifficulty = "easy";
			tempGuessFrame();
		}

		public function mediumGame(e:MouseEvent):void
		{
			this.gameDifficulty = "medium";
			tempGuessFrame();
		}

		public function hardGame(e:MouseEvent):void
		{
			this.gameDifficulty = "hard";
			tempGuessFrame();
		}

		public function tempGuessFrame():void
		{
			this.gotoAndStop(3);

			if (this.firstGuess == true)
			{
				//Input Temperature Text Settings (Size, Font, and Color)
				var inputTempFormat:TextFormat = new TextFormat();
				inputTempFormat.font = "Rockwell";
				inputTempFormat.size = 85;
				inputTempFormat.color = 0xFF0000;
				inputTemp.setStyle("textFormat", inputTempFormat);
			}

			btn_guessTemp.addEventListener(MouseEvent.CLICK, checkGuess);

			tempGuess_txt.text = "Guess the temperature of " + this.docBuffaloDates[currentNum];
		}

		public function checkGuess(e:MouseEvent):void
		{
			this.guess = inputTemp.text;

			//If the input is not a Number, display an error message
			if (isNaN(Number(this.guess)))
			{
				error_txt.text = "Error: Not a Number";
				hot_txt.text = "";
				cold_txt.text = "";
				warm_txt.text = "";
			}
			else
			{

				error_txt.text = "";

				this.guessNumber = Number(guess);

				//Incremenet times guessed
				this.timesGuessed++;

				//Put the temperature from the array into a global variable for other methods
				this.currentTemp = this.docBuffaloTemps[currentNum];

				//Display your last guess over the result of HOT, WARM, or COLD
				guess_txt.text = "Your Last Guess was " + this.guessNumber + " ° F";

				
				//DEPENDING ON DIFFICULTY: GO TO CORRECT METHOD
				
				
				if (this.gameDifficulty == "easy")
				{
					easyCheck();
				}

				if (this.gameDifficulty == "medium")
				{
					mediumCheck();
				}

				if (this.gameDifficulty == "hard")
				{
					hardCheck();
				}
			}
		}

		//TO WIN: Guess within 10 degrees F to get to the Win Game Frame
		public function easyCheck():void
		{
			//Go to Win Game Frame
			if (guessNumber > currentTemp - 10 && guessNumber < currentTemp + 10)
			{
				winGame();
			}

			//Display HOT text
			if (guessNumber > currentTemp + 10 && guessNumber < currentTemp + 20 ||
			   guessNumber > currentTemp - 20 && guessNumber < currentTemp - 10)
			{
				this.timesHot++;
				hot_txt.text = "HOT";
				cold_txt.text = "";
				warm_txt.text = "";
			}

			//Display WARM text
			if (guessNumber > currentTemp + 20 && guessNumber < currentTemp + 40 ||
			   guessNumber > currentTemp - 40 && guessNumber < currentTemp - 20)
			{
				this.timesWarm++;
				hot_txt.text = "";
				cold_txt.text = "";
				warm_txt.text = "WARM";
			}

			//Display COLD text
			if (guessNumber > currentTemp + 40 || guessNumber < currentTemp - 40)
			{
				this.timesCold++;
				hot_txt.text = "";
				cold_txt.text = "COLD";
				warm_txt.text = "";
			}
		}

		//TO WIN: Guess within 2.5 degrees F to get to the Win Game Frame
		public function mediumCheck():void
		{
			//Go to Win Game Frame
			if (guessNumber > currentTemp - 2.5 && guessNumber < currentTemp + 2.5)
			{
				hot_txt.text = "";
				cold_txt.text = "";
				warm_txt.text = "";
				winGame();
			}

			//Display HOT text
			if (guessNumber > currentTemp + 2.5 && guessNumber < currentTemp + 10 ||
			   guessNumber > currentTemp - 10 && guessNumber < currentTemp - 2.5)
			{
				this.timesHot++;
				hot_txt.text = "HOT";
				cold_txt.text = "";
				warm_txt.text = "";
			}

			//Display WARM text
			if (guessNumber > currentTemp + 10 && guessNumber < currentTemp + 30 ||
			   guessNumber > currentTemp - 30 && guessNumber < currentTemp - 10)
			{
				this.timesWarm++;
				hot_txt.text = "";
				cold_txt.text = "";
				warm_txt.text = "WARM";
			}

			//Display COLD text
			if (guessNumber > currentTemp + 30 || guessNumber < currentTemp - 30)
			{
				this.timesCold++;
				hot_txt.text = "";
				cold_txt.text = "COLD";
				warm_txt.text = "";
			}
		}

		//TO WIN: Guess within 0.5 degrees F to get to the Win Game Frame
		public function hardCheck():void
		{
			//Go to Win Game Frame
			if (guessNumber > currentTemp - 0.5 && guessNumber < currentTemp + 0.5)
			{
				winGame();
			}

			//Display HOT text
			if (guessNumber > currentTemp + 0.5 && guessNumber < currentTemp + 5 ||
			   guessNumber > currentTemp - 5 && guessNumber < currentTemp - 0.5)
			{
				this.timesHot++;
				hot_txt.text = "HOT";
				cold_txt.text = "";
				warm_txt.text = "";
			}

			//Display WARM text
			if (guessNumber > currentTemp + 5 && guessNumber < currentTemp + 15 ||
			   guessNumber > currentTemp - 15 && guessNumber < currentTemp - 5)
			{
				this.timesWarm++;
				hot_txt.text = "";
				cold_txt.text = "";
				warm_txt.text = "WARM";
			}

			//Display COLD text
			if (guessNumber > currentTemp + 15 || guessNumber < currentTemp - 15)
			{
				this.timesCold++;
				hot_txt.text = "";
				cold_txt.text = "COLD";
				warm_txt.text = "";
			}
		}

		public function winGame():void
		{
			this.gotoAndStop(4);
			
			//Display win results onto frame
			tempDate_txt.text = "The temperature on " + this.docBuffaloDates[currentNum] + " was:";
			tempWin_txt.text = this.currentTemp + " ° F";
			timesHot_txt.text = this.timesHot.toString();
			timesWarm_txt.text = this.timesWarm.toString();
			timesCold_txt.text = this.timesCold.toString();
			totalGuesses_txt.text = this.timesGuessed.toString();
			
			//Add the Play Again event listener
			btn_playAgain.addEventListener(MouseEvent.CLICK, restartGame);
		}

		public function restartGame(e:MouseEvent):void
		{
			//Reset everything back to its initial value
			this.currentNum = -1;
			this.currentTemp = 0;
			this.timesGuessed = 0;
			this.timesHot = 0;
			this.timesWarm = 0;
			this.timesCold = 0;
			this.guess = "";
			this.guessNumber = 0;
			this.gameDifficulty = "";

			//Remove all previously created event listeners, by going back to each frame
			//where they were created and removing them
			this.gotoAndStop(1);
			btn_startGame.removeEventListener(MouseEvent.CLICK, startGame);
			btn_howToPlay.removeEventListener(MouseEvent.CLICK, showRules);
			
			this.gotoAndStop(2);
			btn_submitDate.removeEventListener(MouseEvent.CLICK, dateSubmit);
			btn_easy.removeEventListener(MouseEvent.CLICK, easyGame);
			btn_medium.removeEventListener(MouseEvent.CLICK, mediumGame);
			btn_hard.removeEventListener(MouseEvent.CLICK, hardGame);
			
			this.gotoAndStop(3);
			btn_guessTemp.removeEventListener(MouseEvent.CLICK, checkGuess);
			
			this.gotoAndStop(4);
			btn_playAgain.removeEventListener(MouseEvent.CLICK, restartGame);

			//Go back to the main menu, and readd the event listeners
			this.gotoAndStop(1);
			btn_startGame.addEventListener(MouseEvent.CLICK, startGame);
			btn_howToPlay.addEventListener(MouseEvent.CLICK, showRules);
		}
	}

}