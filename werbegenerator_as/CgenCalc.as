//remove doubles

//problem bei "preis"

// test

package  {
	
	import Utils;
	import CgenObject;
	
	public class CgenCalc {
		
		public function CgenCalc() {
			// constructor code
		}
		
//--------------------------------------
//  PRIVATE VARIABLES
//--------------------------------------

		private var randNum:int;
		private var tempList:Array;
		private var playList:Array;
		//private var mediaList:Object;
		private var metaList:Array;
		private var mediaObjects: Array;
		
		private var speechList:Array;
		private var musicList:Array;
		
		//Arrays
		private var video:Array;
		private var music:Array;
		private var speech:Array;
		private var finalVideoList:Array;
		private var finalSpeechList:Array;
		private var finalMusicList:Array;
		private var usedGroup:Array;
		
		//Options
		private var messageMain:String;
		private var messageSide1:String;
		private var messageSide2:String;
		private var moodMusic:String;
		private var accuracy:int;
		private var claim:String;
		
		
		private var claimImgPath:String;
		
		private const MAX_ACCURACY:int = 5;

		
//--------------------------------------
//  PUBLIC METHODS
//--------------------------------------
		
		public function calculateClips(xml:XMLList):void 
		{
			tempList = new Array();
			playList = new Array();
			metaList = new Array();
			usedGroup = new Array();
			mediaObjects = new Array();
			
			finalVideoList = new Array();
			finalSpeechList = new Array();
			finalMusicList = new Array();
			
			video = new Array();
			music = new Array();
			speech = new Array();
						
			//FILTERING
			for (var i:int = 0; i < xml.length(); i++)
			{
				mediaObjects[i] = new CgenObject (xml[i].clipname.text(),
												  xml[i]._beauty.text(),
												  xml[i]._price.text(),
												  xml[i]._pleasure.text(),
												  xml[i]._freshness.text(),
												  xml[i]._safety.text(),
												  xml[i]._joy.text(),
												  xml[i]._quality.text(),
												  xml[i]._freedom.text(),
												  xml[i]._innovation.text(),
												  xml[i]._luxury.text(),
												  xml[i]._beginning.text(),
												  xml[i]._middle.text(),
												  xml[i]._end.text(),
												  xml[i]._media.text(),
												  xml[i]._emotionality.text(),
												  xml[i]._motivating.text(),
												  xml[i]._size.text(),
												  xml[i]._sensual.text(),
												  xml[i]._happy.text(),
												  xml[i]._modern.text()				
												)
				
				// sort media appropriately
				if(mediaObjects[i].getMedia == "video") video.push(mediaObjects[i]);
				else if(mediaObjects[i].getMedia == "speech") speech.push(mediaObjects[i]);
				else if(mediaObjects[i].getMedia == "music") music.push(mediaObjects[i]);
			}
			
			
			
			//trace("CgenCalc: VIDEOS: " + video.length);
			//trace("CgenCalc: SPEECH: " + speech.length);
			//trace("CgenCalc: MUSIC: " + music.length);
			trace("CgenCalc: " + messageMain + " : " + messageSide1 + " : " + messageSide2 + " : " + moodMusic + " : " + accuracy + " : " + claim) ;
			
			//test
			var _x:int = 4;
			_x = 3 + _x,
			trace(_x);
						
			var pos:Array = new Array("beginning", "middle", "middle", "end");
			for(var i:int = 1; i <= 4; i++) // find 4 matching videos
			filterVideo(i, pos[i - 1]);

			filterSpeech(); // find 1 matching speech clip
			filterMusic(); // find 1 matching music clip
			filterClaimImage();


			
		}
		
//--------------------------------------

		private function filterVideo(theIndex:int, thePos:String)
		{
			
			var randNum:int;
			var filterHash:Object;
			var filteredObjects:Array = new Array();
			var it:int = 0;
			var _direction:int = 1;
			var bStopLoop:Boolean = false;
			var filterMessage:String;
			
			switch(theIndex) // the index determines which one of the 4 videos is needed
			{
				case 1: // video 1
					filterMessage = messageMain;
				break;
				case 2: // video 2
					filterMessage = messageSide1;
				break;
				case 3: // video 3
					filterMessage = messageSide2;
				break;
				case 4: // video 4
					filterMessage = messageMain;
				break;
			}
					
			//do // do this until objects are found
			//{
				for(var i:int = 0; i < video.length; i++)
				{
					filterHash = video[i].getAllAttributes();
					if(filterHash[filterMessage] >= accuracy + it && !Utils.isItInThere(video[i].getClipName, finalVideoList) && thePos == video[i].getPos()) // check if this clip is already in the finalVideoList so it won't play twice and if clip can be a this position
					{
						filteredObjects.push(video[i].getClipName);
					}
				}
				
				if(filteredObjects.length == 0)
				{
					for(var i:int = 0; i < video.length; i++)
					{
						filterHash = video[i].getAllAttributes();
						if(filterHash[filterMessage] >= accuracy + it && !Utils.isItInThere(video[i].getClipName, finalVideoList)) // check but ignore Position 
						{
							filteredObjects.push(video[i].getClipName);
						}
					}
				}
			// refine search parameters for the next round
			/*
			if(accuracy + it <= MAX_ACCURACY) // if it is 1,2,3,4 look 1 higher or lower depending on direction
			{
				if(accuracy + it == MAX_ACCURACY) //once it hits Max reverse direction and look lower
				{
					_direction = -1;
				}
				it = (it + 1) * (_direction);
				
				if(accuracy + it == 0) // once you hit 0 zero there is nothing to be found anymore
					bStopLoop = true;
			}
			} while(filteredObjects.length == 0 && bStopLoop == false);
			*/
			
			
			if(filteredObjects.length == 0)
				trace("ERROR: CgenCalc: There are no matching video Objects");
			else // push 1 object from this pool into the final list
			{
				filteredObjects = removeVersions(filteredObjects);
				randNum = Utils.randRound(filteredObjects.length);
				usedGroup.push(filteredObjects[randNum]); // for removing clips of the same Gruop if neccessary
				finalVideoList.push(filteredObjects[randNum]);
				trace("CgenCalc: num of filtered VideoList: " + filteredObjects.length);
			}			
		}
		
//--------------------------------------

		private function filterSpeech():void
		{
			var randNum:int;
			var filterHash:Object;
			var filteredObjects:Array = new Array();
			var it:int = 0;
			var _direction:int = 1;
			var bStopLoop:Boolean = false;
											
			//do // do this until objects are found
			//{
				for(var i:int = 0; i < speech.length; i++)
				{
					filterHash = speech[i].getAllAttributes();
					if(filterHash[messageMain] >= accuracy + it) // messageMain determines  
					{
						//trace("CgenCalc: speech: " + speech[i].getClipName);
						filteredObjects.push(speech[i].getClipName);
					}
				}
			
			/*if(speechOnOff == "speechOn"){ // turn on and off with dropdown
				
			}*/
			
			/*
			// refine search parameters for the next round
			if(accuracy + it <= MAX_ACCURACY) // if it is 1,2,3,4 look 1 higher or lower depending on direction
			{
				if(accuracy + it == MAX_ACCURACY) //once it hits Max reverse direction and look lower
				{
					_direction = -1;
				}
				it = (it + 1) * (_direction);
				
				if(accuracy + it == 0) // once you hit 0 zero there is nothing to be found anymore
					bStopLoop = true;
			}
		} while(filteredObjects.length == 0 && bStopLoop == false);
		*/
		
		
		if(filteredObjects.length == 0)
			trace("ERROR: CgenCalc: There are no matching speech Objects");
		else // push 1 object from this pool into the final list
		{
			randNum = Utils.randRound(filteredObjects.length);
			finalSpeechList.push(filteredObjects[randNum]);
			//trace("CgenCalc: num of filtered SpeechList: " + filteredObjects.length);
			trace("CgenCalc: num of filtered SpeechList: " + filteredObjects[randNum]);
		}			
	}
		
//--------------------------------------

	private function filterMusic():void
	{
		var randNum:int;
		var filterHash:Object;
		var filteredObjects:Array = new Array();
		var it:int = 0;
		var _direction:int = 1;
		var bStopLoop:Boolean = false;
		
		//do // do this until objects are found
		//{
			for(var i:int = 0; i < music.length; i++)
			{
				filterHash = music[i].getAllMoods();
				//trace("hash filter musik:----  " + filterHash[moodMusic] + " " + moodMusic);
				
				if(filterHash[moodMusic] >= accuracy + it)
				{
					//trace("CgenCalc: music: " + music[i].getClipName);
					filteredObjects.push(music[i].getClipName);
				}
			}
			
			/*
			// refine search parameters for the next round
			if(accuracy + it <= MAX_ACCURACY) // if it is 1,2,3,4 look 1 higher or lower depending on direction
			{
				if(accuracy + it == MAX_ACCURACY) //once it hits Max reverse direction and look lower
				{
					_direction = -1;
				}
				it = (it + 1) * (_direction);
				
				if(accuracy + it == 0) // once you hit 0 zero there is nothing to be found anymore
					bStopLoop = true;
			}
		} while(filteredObjects.length == 0 && bStopLoop == false);
		*/
		
		if(filteredObjects.length == 0)
			trace("ERROR: CgenCalc: There are no matching music Objects");
		else // push 1 object from this pool into the final list
		{
			randNum = Utils.randRound(filteredObjects.length);
			finalMusicList.push(filteredObjects[randNum]);
			//trace("CgenCalc: num of filtered MusicList: " + filteredObjects.length);
			trace("CgenCalc: filtered music: " + filteredObjects[randNum]);
		}
		
	}
	
//--------------------------------------
	
	private function filterClaimImage():void
	{
		claimImgPath = "media/cgen/2.jpg";
	}

		
//-------------------------------------- GETTERS
		
		public function get getVideoList():Array
		{
			//for(var i:int = 0; i < video.length; i++) finalVideoList.push(video[i].getClipName);
			//finalVideoList = new Array("V_29_01_01.mov", "V_29_01_01.mov", "V_29_01_01.mov", "V_29_01_01.mov");
			return finalVideoList;
		}
		
		public function get getSpeechList():Array
		{
			//for(var i:int = 0; i < speech.length; i++) finalSpeechList.push(speech[i].getClipName);
			return finalSpeechList;
		}
		
		public function get getMusicList():Array
		{
			//for(var i:int = 0; i < music.length; i++) finalMusicList.push(music[i].getClipName);
			return finalMusicList;
		}
		
		public function get getClaimImgPath():String
		{
			return claimImgPath;
		}
		
//-------------------------------------- SETTERS

		public function set setMessageMain(theMessageMain:String):void
		{
			if(theMessageMain == "random")
				messageMain = chooseRandomAttribute();
			else
				messageMain = theMessageMain;
		}
		
		public function set setMessageSide1(theMessageSide1:String):void
		{
			if(theMessageSide1 == "random")
				messageSide1 = chooseRandomAttribute();
			else if (theMessageSide1 == "none") // if none is selected the make the side Message the same as the main Message (important: messageMain has to be already assigned)
				messageSide1 = messageMain;
			else
				messageSide1 = theMessageSide1;
				
		}
		
		public function set setMessageSide2(theMessageSide2:String):void
		{
			if(theMessageSide2 == "random")
				messageSide2 = chooseRandomAttribute();
			else if (theMessageSide2 == "none") // if none is selected the make the side Message the same as the main Message (important: messageMain has to be already assigned)
				messageSide2 = messageMain;
			else
				messageSide2 = theMessageSide2;
		}
		
		public function set setMoodMusic(theMoodMusic:String):void
		{
			if(theMoodMusic == "random")
				moodMusic = chooseRandomMood();
			else
				moodMusic = theMoodMusic;
				//trace("------- "  + theMoodMusic);
		}
		
		public function set setAccuracy(theAccuracy:int):void
		{
			accuracy = theAccuracy;
		}
		
		public function set setClaim(theClaim:String):void
		{
			claim = theClaim;
		}
		/*
		public function set setSpeech(theSpeech:String):void
		{
			speechOnOff = theSpeech;
		}*/
		

		
//--------------------------------------

		private function chooseRandomAttribute():String
		{
			var possibilities:Array = new Array("price", "pleasure", "freshness", "safety", "joy", "quality", "freedom", "innovation", "luxury");
			var returnString = possibilities[Utils.randRound(possibilities.length)];
			return returnString;
		}
		
//--------------------------------------
		
		private function chooseRandomMood():String
		{
			var possibilities:Array = new Array("emotionality", "motivating", "size", "sensual", "modern");
			var returnString = possibilities[Utils.randRound(possibilities.length)];
			return returnString;
		}
		
//--------------------------------------

		////////////////////
		// REMOVE DOUBLES //
		////////////////////
		
		private function removeVersions(arr:Array):Array
		{
			var allVersions:Array = new Array();
			var allVersionsSorted:Array = new Array();
			var k:uint = 0;
			allVersionsSorted[k] = new Array();
			
			arr.sortOn("getClipName", Array.DESCENDING);
			usedGroup.sort(Array.DESCENDING);
			
			//look for clip that was used before and remove all others of this group			
			if(usedGroup.length > 0)
			{
				trace("-- used Group: " + usedGroup.length + " : " + usedGroup);
				for (var i:int = 0; i < arr.length; i++)
				{
					//trace("before: " + arr[i]); 
				}
				
				
				for(var i:int = 0; i < arr.length; i++)
				{
					for(var j:int = 0; j < usedGroup.length; j++)
					{	
						if(arr.length > 0 && i != -1)
						{
							//trace("i before = " + i);
							if(arr[i].substring(0,7) === usedGroup[j].substring(0,7))
							{
								trace("-- Doppelte Gefunden: " + arr[i]);
								arr.splice(i, 1);
								trace("-- entfernt");
								if(i >= 0)i--;
								//trace("i = " + i);
							}
						}
					}
				}
			}
			
			for (var i:int = 0; i < arr.length; i++)
			{
				//trace("after: " + arr[i]); 
			}
			
			return arr;  
		}
	}
}
