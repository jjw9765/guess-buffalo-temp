//John Watson
//Programming Project

package code
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;


	public class FileLoader extends URLLoader
	{
		private var buffaloTemperaturesURL:String = "http://academic.udayton.edu/kissock/http/Weather/gsod95-current/NYBUFFAL.txt";

		//Array that has all of the data from the URL
		private var originalData:Array = new Array();

		//Arrays that store information into cateogries from the originalData Array
		private var buffaloDates:Array = new Array();
		private var buffaloTemperatures:Array = new Array();

		//Document variable that lets us talk to the Document class
		private var myDoc:Document;

		public function FileLoader(aDoc:Document)
		{
			this.myDoc = aDoc;
			var myURL:URLRequest = new URLRequest(buffaloTemperaturesURL);
			this.addEventListener(Event.COMPLETE, onComplete);
			this.load(myURL);
		}

		public function onComplete(e:Event):void
		{
			retrieveNums();
			setDates();
			setTemperatures();

			//Take the arrays created in the FileLoader class and
			//put them into arrays in the Document class
			for (var i:int = 0; i < 6209; i++)
			{
				this.myDoc.docBuffaloDates.push(this.buffaloDates[i]);
				this.myDoc.docBuffaloTemps.push(this.buffaloTemperatures[i]);
			}
		}


		//Function that retrieves all of the data from the external source. Seperates each number with a comma.
		public function retrieveNums():void
		{
			var s:String = this.data;
			var exp:RegExp = /\s/;
			var split:Array = s.split(exp);

			for each (var ss:String in split)
			{
				if (ss != "")
				{
					originalData.push(ss);
				}
			}
		}

		//Sets the data into an array so it makes sense
		//Loop created to set the dates into an array
		public function setDates():void
		{
			var month:String;
			var day:String;
			var year:String;
			var count:int = 0;
			
			//Dates stored from 1/1/1995 to 12/31/2011. The total number of days is 6209
			//between those two dates. 
			for(var i:int = 0; i < 6209; i++)
			{
				month = this.originalData[count];
				day = this.originalData[count + 1];
				year = this.originalData[count + 2];

				this.buffaloDates.push(month + "/" + day + "/" + year);

				//increment counter by four so it skips the temperature data, and keeps on adding the dates;
				count +=  4;
			}
		}

		//Sets the data into an array so it makes sense
		//Loop created to set the temperatures into an array
		public function setTemperatures():void
		{
			var count:Number = 3;

			//Total number of temperatures is the total number of dates (6209)
			for(var i:int = 0; i < 6209; i++)
			{
				this.buffaloTemperatures.push(this.originalData[count]);

				//increment counter by four so it skips the dates data, and keeps on adding the temperatures;
				count +=  4;
			}
		}
	}

}