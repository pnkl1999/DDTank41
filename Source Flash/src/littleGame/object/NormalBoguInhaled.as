package littleGame.object
{
   import com.greensock.TweenLite;
   import com.greensock.easing.Bounce;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.ChatManager;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import littleGame.LittleGameManager;
   import littleGame.actions.LittleLivingDieAction;
   import littleGame.data.LittleObjectType;
   import littleGame.interfaces.ILittleObject;
   import littleGame.model.LittleLiving;
   import littleGame.model.LittleSelf;
   import littleGame.model.Scenario;
   import littleGame.view.GameLittleLiving;
   import littleGame.view.GameScene;
   import littleGame.view.MarkShape;
   import road7th.comm.PackageIn;
   
   public class NormalBoguInhaled extends Sprite implements ILittleObject
   {
      
      public static var NoteCount:int;
      
      private static const MaxNoteCount:int = 3;
      
      private static var littleObjectCount:int = 0;
       
      
      private var _id:int;
      
      protected var _giveup:MovieClip;
      
      protected var _giveupAni:MovieClip;
      
      protected var _scene:Scenario;
      
      protected var _target:LittleLiving;
      
      protected var _self:LittleSelf;
      
      protected var _totalClick:int = 20;
      
      protected var _totalScore:int = 1000;
      
      protected var _clickScore:int;
      
      protected var _clickCount:int = 0;
      
      protected var _time:int;
      
      protected var _score:int;
      
      protected var _timer:Timer;
      
      protected var _inhaleAsset:MovieClip;
      
      protected var _gameLivings:Dictionary;
      
      protected var _markBar:MarkShape;
      
      protected var _running:Boolean = true;
      
      protected var _removed:Boolean = false;
      
      private var _mouseNote:DisplayObject;
      
      public function NormalBoguInhaled()
      {
         super();
         this._id = littleObjectCount++;
         mouseChildren = false;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function get type() : String
      {
         return LittleObjectType.NormalBoguInhaled;
      }
      
      override public function toString() : String
      {
         return "[NormalBoguInhaled:(" + ")]";
      }
      
      public function initialize(scene:Scenario, pkg:PackageIn) : void
      {
         var livingID:int = 0;
         var gameLiving:GameLittleLiving = null;
         this._scene = scene;
         this._id = pkg.readInt();
         this._self = this._scene.findLiving(pkg.readInt()) as LittleSelf;
         this._target = this._scene.findLiving(pkg.readInt());
         this._totalClick = pkg.readInt();
         this._totalScore = pkg.readInt();
         this._clickScore = pkg.readInt();
         this._time = pkg.readInt();
         var livingCount:int = pkg.readInt();
         var gameScene:GameScene = LittleGameManager.Instance.gameScene;
         this._gameLivings = new Dictionary();
         this._gameLivings[this._target.id] = gameScene.findGameLiving(this._target.id);
         for(var i:int = 0; i < livingCount; i++)
         {
            livingID = pkg.readInt();
            gameLiving = gameScene.findGameLiving(livingID);
            if(gameLiving)
            {
               this._gameLivings[livingID] = gameLiving;
            }
         }
         this.drawInhaleAsset();
         this.execute();
      }
      
      protected function drawInhaleAsset() : void
      {
      }
      
      protected function lockLivings() : void
      {
         var sortList:Array = null;
         var gameLiving:GameLittleLiving = null;
         sortList = null;
         gameLiving = null;
         var key:* = null;
         var i:int = 0;
         var pos:Point = null;
         sortList = new Array();
         for(key in this._gameLivings)
         {
            gameLiving = this._gameLivings[key];
            if(gameLiving && gameLiving.parent && gameLiving.inGame)
            {
               gameLiving.lock = true;
               pos = gameLiving.parent.localToGlobal(new Point(gameLiving.living.dx * gameLiving.living.speed,gameLiving.living.dy * gameLiving.living.speed));
               pos = globalToLocal(pos);
               gameLiving.x = pos.x;
               gameLiving.y = pos.y;
               sortList.push(gameLiving);
            }
         }
         sortList.sortOn("y",Array.NUMERIC);
         for(i = sortList.length; i > 0; i--)
         {
            addChildAt(sortList[i - 1],0);
         }
      }
      
      protected function releaseLivings() : void
      {
         var sortList:Array = null;
         var gameLiving:GameLittleLiving = null;
         var key:* = null;
         var gameScene:GameScene = null;
         var i:int = 0;
         sortList = new Array();
         for(key in this._gameLivings)
         {
            gameLiving = this._gameLivings[key];
            if(gameLiving)
            {
               gameLiving.setInhaled(false);
            }
            if(gameLiving.inGame)
            {
               gameLiving.lock = false;
               gameLiving.living.stand();
               gameLiving.living.doAction("stand");
               gameLiving.x = gameLiving.living.pos.x * gameLiving.living.speed;
               gameLiving.y = gameLiving.living.pos.y * gameLiving.living.speed;
               sortList.push(gameLiving);
            }
         }
         sortList.sortOn("y",Array.NUMERIC);
         gameScene = LittleGameManager.Instance.gameScene;
         for(i = 0; i < sortList.length; i++)
         {
            gameScene.addToLayer(sortList[i] as DisplayObject,LittleGameManager.GameBackLayer);
         }
      }
      
      protected function drawBackground() : void
      {
         var g:Graphics = graphics;
         g.beginFill(0,0);
         g.drawRect(0,0,StageReferance.stageWidth,StageReferance.stageHeight);
         g.endFill();
      }
      
      protected function drawMark() : void
      {
         this._markBar = new MarkShape(this._time);
         this._markBar.y = 450;
         this._markBar.x = StageReferance.stageWidth;
         this._markBar.alpha = 0;
         TweenLite.to(this._markBar,0.3,{
            "alpha":1,
            "x":StageReferance.stageWidth - this._markBar.width - 20,
            "ease":Bounce.easeOut
         });
         addChild(this._markBar);
      }
      
      public function invoke(pkg:PackageIn) : void
      {
      }
      
      public function execute() : void
      {
         this.drawBackground();
         this._scene.selfInhaled = true;
         LittleGameManager.Instance.mainStage.addChild(this);
         ChatManager.Instance.focusFuncEnabled = false;
         this.addEvent();
         if(NoteCount < MaxNoteCount)
         {
            this._mouseNote = ComponentFactory.Instance.creat("LittleMouseNote");
            addChild(this._mouseNote);
            ++NoteCount;
         }
      }
      
      protected function __mark(event:TimerEvent) : void
      {
         if(this._markBar)
         {
            this._markBar.setTime(this._time - this._timer.currentCount);
         }
      }
      
      protected function __markComplete(event:TimerEvent) : void
      {
         var timer:Timer = event.currentTarget as Timer;
         timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
         removeEventListener(MouseEvent.CLICK,this.__click);
         this.complete();
      }
      
      protected function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
	  private var now:Date = new Date();
	  private var _startTime:Number = now.time;
	  
      protected function __click(event:MouseEvent) : void
      {
		  var _now:Date = new Date();
		  var _CheckTime:Number = _now.time;
		  var milis:Number = _CheckTime - this._startTime;
		  if (milis < 60)
		  {
			  _now = new Date();
			  this._startTime = _now.time;
		  }
		  else
		  {
			  _now = new Date();
			  this._startTime = _now.time;
	          ++this._clickCount;
	          if(this._clickCount >= this._totalClick)
	          {
	             removeEventListener(MouseEvent.CLICK,this.__click);
	             this._score = this._totalScore * this._clickCount / this._totalClick;
	             if(this._timer)
	             {
	                this._timer.stop();
	                this._timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.__markComplete);
	                this._timer.removeEventListener(TimerEvent.TIMER,this.__mark);
	             }
	             this.complete();
	          }
		  }
      }
      
      protected function complete() : void
      {
         LittleGameManager.Instance.sendScore(this._score,this._target.id);
         if(this._self)
         {
            this._self.doAction("stand");
            this._self.MotionState = 2;
            if(this._score > 0)
            {
               this._self.getScore(this._score);
            }
         }
         this._running = false;
         this._scene.removeObject(this);
      }
      
      protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__click);
      }
      
      public function dispose() : void
      {
         var key:* = null;
         this._removed = true;
         if(this._running)
         {
            return;
         }
         this.removeEvent();
         ChatManager.Instance.focusFuncEnabled = true;
         ObjectUtils.disposeObject(this._mouseNote);
         this._mouseNote = null;
         ObjectUtils.disposeObject(this._markBar);
         this._markBar = null;
         ObjectUtils.disposeObject(this._inhaleAsset);
         this._inhaleAsset = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         if(this._target)
         {
            this._target.act(new LittleLivingDieAction(this._scene,this._target));
         }
         this._target = this._self = null;
         for(key in this._gameLivings)
         {
            delete this._gameLivings[key];
         }
         this._gameLivings = null;
      }
   }
}
