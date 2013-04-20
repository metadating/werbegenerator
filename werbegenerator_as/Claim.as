﻿package  {		import flash.events.*;	import flash.display.*;	import flash.media.*;	import flash.text.*;	import flash.system.*;	import flash.geom.*;	import Officina;	import com.greensock.*;	import com.greensock.events.TweenEvent;	// TIMER	import flash.utils.Timer;	import flash.events.TimerEvent;		import McTextfield;	import ClaimBkg;	import BtnReload;	import flash.net.URLRequest;		public class Claim extends MovieClip{					//--------------------------------------//  PRIVATE VARIABLES//--------------------------------------		private var claim:String;		private var myTimer:Timer;		private var claim_bkg:ClaimBkg;		private var mcTextfield:McTextfield;		private var claimContainer:MovieClip;		private var format:TextFormat;		private var myFont:Font;		private const STANDARD_CLAIM:String = "Hier kann dein Claim stehen";				// for loading images		private var myLoader:Loader;		private var fileRequest:URLRequest;		private var imagePath:String;				//--------------------------------------//  CONSTRUCTOR//--------------------------------------		public function Claim(theClaim:String = null) 		{			if(theClaim.length == 0)				claim = STANDARD_CLAIM;			else				claim = theClaim;							trace("Claim: the claim is: " + claim);			claim_bkg = new ClaimBkg()			mcTextfield = new McTextfield(); 			format = new TextFormat()			claimContainer = new MovieClip();			myFont = new Officina();		}		//--------------------------------------//  PUBLIC METHODS//--------------------------------------				public function init(theImagePath:String = ""):void		{			format.color = 0xFFFFFF;			format.size = 50;			format.align = TextFormatAlign.CENTER;			//format.font = myFont.fontName;						imagePath = theImagePath;			myLoader = new Loader();			fileRequest = new URLRequest(imagePath);			myLoader.load(fileRequest);		}		//--------------------------------------				public function startClaim():void		{			myTimer = new Timer(6000, 1);			myTimer.start();			myTimer.addEventListener(TimerEvent.TIMER, endClaim);			this.drawClaim();		}		//--------------------------------------				public function set setClaim(theClaim:String)		{			if(theClaim.length == 0)				claim = STANDARD_CLAIM;			else				claim = theClaim;		}		//--------------------------------------				public function set setImage(thePath:String)		{			imagePath = thePath;		}		//--------------------------------------//--------------------------------------//  PRIVATE METHODS//--------------------------------------	private function drawClaim():void	{		//trace("Claim: draw claim");		mcTextfield.text_textfield.text = claim;		mcTextfield.text_textfield.height = 45;		mcTextfield.text_textfield.y = (Player.vid.height/2) + 45;		mcTextfield.text_textfield.setTextFormat(format);		mcTextfield.text_textfield.alpha = 0;								//claim_bkg.addChild(myLoader);		claim_bkg.addChild(mcTextfield);		claimContainer.addChild(claim_bkg);		MetaDating.STAGE.addChild(claimContainer);						claim_bkg.x = Player.vid.x;		claim_bkg.y = Player.vid.y;		claim_bkg.width = Player.vid.width;		claim_bkg.height = Player.vid.height;		claim_bkg.alpha = 1;				//Fade-In Animtation		TweenLite.to(mcTextfield.text_textfield, 1.5, {alpha:1.0});	}	//--------------------------------------	private function endClaim(e:TimerEvent):void	{		trace("Claim: timer stopped");		myTimer.stop();				// Fade Out animation		TweenLite.to(claimContainer, 1.5, {alpha:0.0, onComplete:removeClaim})				function removeClaim():void		{			MetaDating.STAGE.removeChild(claimContainer);			MetaDating.endOfVideo(); //show endscreen (repeat,social media and stuff)		}	}		//--------------------------------------		}}