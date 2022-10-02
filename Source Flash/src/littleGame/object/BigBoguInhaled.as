package littleGame.object
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.media.SoundChannel;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import littleGame.LittleGameManager;
   import littleGame.data.LittleObjectType;
   import littleGame.interfaces.ILittleObject;
   import littleGame.view.PriceShape;
   import littleGame.view.ScoreShape;
   
   public class BigBoguInhaled extends NormalBoguInhaled
   {
       
      
      private var _clickSoundChannel:SoundChannel;
      
      private var _soundPlaying:Boolean = false;
      
      private var _scoreShape:ScoreShape;
      
      private var _soundPlayVer:int;
      
      private var _scoreTween:Boolean = false;
      
      public function BigBoguInhaled()
      {
         super();
      }
      
      override public function get type() : String
      {
         return LittleObjectType.BigBoguInhaled;
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         if(this._clickSoundChannel)
         {
            this._clickSoundChannel.removeEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
         }
      }
      
      override protected function drawInhaleAsset() : void
      {
         _inhaleAsset = ClassUtils.CreatInstance("asset.littleGame.BigInhale");
         _inhaleAsset.x = 526;
         _inhaleAsset.y = 324;
         addChild(_inhaleAsset);
         _inhaleAsset.mouseEnabled = false;
         _inhaleAsset.mouseChildren = false;
         _inhaleAsset.addEventListener(Event.ENTER_FRAME,this.__inhaleOnFrame);
         _inhaleAsset.gotoAndPlay("born");
         SoundManager.instance.play("163");
      }
      
      private function __inhaleOnFrame(event:Event) : void
      {
         var movie:MovieClip = event.currentTarget as MovieClip;
         if(movie.currentFrameLabel == "bornEnd")
         {
            this.start();
         }
         else if(movie.currentFrame >= movie.totalFrames)
         {
            ObjectUtils.disposeObject(movie);
            this.complete();
         }
      }
      
      override protected function drawBackground() : void
      {
         var g:Graphics = graphics;
         g.beginFill(0,0.8);
         g.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         g.endFill();
      }
      
      override public function execute() : void
      {
         var key:* = null;
         var obj:ILittleObject = null;
         this.drawBackground();
         drawMark();
         lockLivings();
         _scene.selfInhaled = true;
         ChatManager.Instance.focusFuncEnabled = false;
         var objects:Dictionary = _scene.littleObjects;
         for(key in objects)
         {
            obj = objects[key];
            if(obj.type == LittleObjectType.BoguGiveup)
            {
               _scene.removeObject(obj);
            }
         }
         LittleGameManager.Instance.mainStage.addChild(this);
         _timer = new Timer(1000,_time);
         _timer.addEventListener(TimerEvent.TIMER,__mark);
         _timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         _timer.start();
      }
      
      private function scoreTweenComplete() : void
      {
         this._scoreTween = false;
      }
      
      private function priceTweenIn(shape:DisplayObject) : void
      {
         TweenLite.to(shape,0.2,{
            "delay":2,
            "alpha":1,
            "y":shape.y - shape.height * 2,
            "ease":Bounce.easeOut,
            "onComplete":ObjectUtils.disposeObject,
            "onCompleteParams":[shape]
         });
      }
      
      private function __soundComplete(event:Event) : void
      {
         this._soundPlaying = false;
         event.currentTarget.removeEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
         if(this._soundPlayVer < _clickCount && _running)
         {
            this._clickSoundChannel = SoundManager.instance.play("164");
            if(this._clickSoundChannel)
            {
               this._clickSoundChannel.addEventListener(Event.SOUND_COMPLETE,this.__soundComplete);
            }
            this._soundPlaying = true;
            this._soundPlayVer = _clickCount;
         }
      }
	  
	  private var now:Date = new Date();
	  private var _startTime:Number = now.time;
      override protected function __click(event:MouseEvent) : void
      {
		  var _now:Date = new Date();
		  var _CheckTime:Number = _now.time;
		  var milis:Number = _CheckTime - this._startTime;
		  if (milis < 60)
		  {
			  _now = new Date();
			  this._startTime = _now.time;
		  }
		  else {
			 _now = new Date();
			 this._startTime = _now.time;
		
	         var priceShape:PriceShape = null;
	         ++_clickCount;
	         if(_inhaleAsset)
	         {
	            _inhaleAsset["admit"]["water"].gotoAndStop(int(_inhaleAsset["admit"]["water"].totalFrames * _clickCount / _totalClick));
	            _inhaleAsset["admit"].play();
	         }
	         _score = _totalScore * _clickCount / _totalClick;
	         var price:int = 0;
	         if(this._scoreShape)
	         {
	            this._scoreShape.setScore(_score);
	         }
	         else
	         {
	            this._scoreShape = new ScoreShape(1);
	            this._scoreShape.y = StageReferance.stageHeight - this._scoreShape.height >> 1;
	            this._scoreShape.setScore(_score);
	            addChild(this._scoreShape);
	         }
	         if(!this._scoreTween)
	         {
	            this._scoreShape.alpha = 0;
	            this._scoreShape.x = 200;
	            this._scoreTween = true;
	            TweenLite.to(this._scoreShape,0.3,{
	               "alpha":1,
	               "x":300,
	               "ease":Bounce.easeOut,
	               "onComplete":this.scoreTweenComplete
	            });
	            SoundManager.instance.stop("164");
	            SoundManager.instance.play("164");
	         }
	         if(_clickCount >= _totalClick)
	         {
	            removeEventListener(MouseEvent.CLICK,this.__click);
	            price = _totalScore * 0.2;
	            priceShape = new PriceShape(price);
	            priceShape.alpha = 0;
	            priceShape.x = 300;
	            priceShape.y = this._scoreShape.y;
	            addChild(priceShape);
	            TweenLite.to(priceShape,0.2,{
	               "delay":0.2,
	               "alpha":1,
	               "y":priceShape.y - priceShape.height - 20,
	               "onComplete":this.priceTweenIn,
	               "onCompleteParams":[priceShape]
	            });
	            _target.dieing = true;
	         }
	         _score += price;
		  }
		  _now = new Date();
		  this._startTime = _now.time;
		  //baolt end check click
      }
      
      override protected function complete() : void
      {
         LittleGameManager.Instance.sendScore(_score,_target.id);
         if(_inhaleAsset)
         {
            _inhaleAsset.removeEventListener(Event.ENTER_FRAME,this.__inhaleOnFrame);
         }
         _running = false;
         this.dispose();
      }
      
      private function start() : void
      {
         _inhaleAsset.gotoAndPlay("stand");
         if(_timer)
         {
            _timer.start();
         }
         addEvent();
      }
      
      override protected function __markComplete(event:TimerEvent) : void
      {
         var timer:Timer = event.currentTarget as Timer;
         timer.removeEventListener(TimerEvent.TIMER,__mark);
         timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         removeEventListener(MouseEvent.CLICK,this.__click);
         _inhaleAsset.gotoAndPlay("out");
      }
      
      override public function dispose() : void
      {
         _removed = true;
         if(_running)
         {
            return;
         }
         if(_self)
         {
            _self.doAction("stand");
            _self.MotionState = 2;
            _self.inhaled = false;
         }
         releaseLivings();
         super.dispose();
      }
   }
}
