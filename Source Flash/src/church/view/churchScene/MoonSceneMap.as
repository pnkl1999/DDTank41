package church.view.churchScene
{
   import baglocked.BaglockedManager;
   import church.model.ChurchRoomModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ClassUtils;
   import ddt.events.SceneCharacterEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.scenePathSearcher.SceneScene;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import road7th.data.DictionaryData;
   
   public class MoonSceneMap extends SceneMap
   {
      
      public static const GAME_WIDTH:int = 1000;
      
      public static const GAME_HEIGHT:int = 600;
      
      public static const YF_OFSET:int = 230;
      
      public static const FIRE_TEMPLETEID:int = 22001;
       
      
      private var _model:ChurchRoomModel;
      
      private var saluteContainer:Sprite;
      
      private var saluteMask:MovieClip;
      
      private var _isSaluteFiring:Boolean;
      
      private var saluteQueue:Array;
      
      private var timer:Timer;
      
      public function MoonSceneMap(param1:ChurchRoomModel, param2:SceneScene, param3:DictionaryData, param4:Sprite, param5:Sprite, param6:Sprite = null, param7:Sprite = null)
      {
         this._model = param1;
         super(this._model,param2,param3,param4,param5,param6,param7);
         SoundManager.instance.playMusic("3003");
         this.initSaulte();
      }
      
      private function get isSaluteFiring() : Boolean
      {
         return this._isSaluteFiring;
      }
      
      private function set isSaluteFiring(param1:Boolean) : void
      {
         if(this._isSaluteFiring == param1)
         {
            return;
         }
         this._isSaluteFiring = param1;
         if(this._isSaluteFiring)
         {
            this.playSaluteSound();
         }
         else
         {
            this.stopSaluteSound();
         }
      }
      
      override public function setCenter(param1:SceneCharacterEvent = null) : void
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         if(reference)
         {
            _loc2_ = -(reference.x - GAME_WIDTH / 2);
            _loc3_ = -(reference.y - GAME_HEIGHT / 2) + YF_OFSET;
         }
         else
         {
            _loc2_ = -(sceneMapVO.defaultPos.x - GAME_WIDTH / 2);
            _loc3_ = -(sceneMapVO.defaultPos.y - GAME_HEIGHT / 2) + YF_OFSET;
         }
         if(_loc2_ > 0)
         {
            _loc2_ = 0;
         }
         if(_loc2_ < GAME_WIDTH - sceneMapVO.mapW)
         {
            _loc2_ = GAME_WIDTH - sceneMapVO.mapW;
         }
         if(_loc3_ > 0)
         {
            _loc3_ = 0;
         }
         if(_loc3_ < GAME_HEIGHT - sceneMapVO.mapH)
         {
            _loc3_ = GAME_HEIGHT - sceneMapVO.mapH;
         }
         x = _loc2_;
         y = _loc3_;
      }
      
      private function initSaulte() : void
      {
         var _loc1_:int = this.getChildIndex(articleLayer);
         this.saluteContainer = new Sprite();
         addChildAt(this.saluteContainer,_loc1_);
         this.saluteMask = new (ClassUtils.uiSourceDomain.getDefinition("asset.church.room.FireMaskOfMoonSceneAsset") as Class)() as MovieClip;
         addChild(this.saluteMask);
         this.saluteContainer.mask = this.saluteMask;
         this.saluteQueue = [];
         nameVisible();
         chatBallVisible();
         fireVisible();
      }
      
      override public function setSalute(param1:int) : void
      {
         var _loc4_:Point = null;
         var _loc3_:MovieClip = null;
         _loc4_ = null;
         if(this.isSaluteFiring && param1 == PlayerManager.Instance.Self.ID)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("church.churchScene.scene.MoonSceneMap.lipao"));
            return;
         }
         if(param1 == PlayerManager.Instance.Self.ID)
         {
            if(PlayerManager.Instance.Self.bagLocked)
            {
               BaglockedManager.Instance.show();
               return;
            }
            SocketManager.Instance.out.sendGunSalute(param1,FIRE_TEMPLETEID);
         }
         var _loc2_:Class = ClassUtils.uiSourceDomain.getDefinition("tank.church.fireAcect.Salute") as Class;
         _loc3_ = new _loc2_();
         _loc4_ = ComponentFactory.Instance.creatCustomObject("church.MoonSceneMap.saluteFirePos");
         _loc3_.x = _loc4_.x;
         _loc3_.y = _loc4_.y;
         if(this.isSaluteFiring)
         {
            this.saluteQueue.push(_loc3_);
         }
         else
         {
            this.isSaluteFiring = true;
            _loc3_.addEventListener(Event.ENTER_FRAME,this.saluteFireFrameHandler);
            _loc3_.gotoAndPlay(1);
            this.saluteContainer.addChild(_loc3_);
         }
      }
      
      private function saluteFireFrameHandler(param1:Event) : void
      {
         var _loc3_:MovieClip = null;
         var _loc2_:MovieClip = param1.currentTarget as MovieClip;
         if(_loc2_.currentFrame == _loc2_.totalFrames)
         {
            this.isSaluteFiring = false;
            this.clearnSaluteFire();
            _loc3_ = this.saluteQueue.shift();
            if(_loc3_)
            {
               this.isSaluteFiring = true;
               _loc3_.addEventListener(Event.ENTER_FRAME,this.saluteFireFrameHandler);
               _loc3_.gotoAndPlay(1);
               this.saluteContainer.addChild(_loc3_);
            }
         }
      }
      
      private function clearnSaluteFire() : void
      {
         while(this.saluteContainer.numChildren > 0)
         {
            this.saluteContainer.getChildAt(0).removeEventListener(Event.ENTER_FRAME,this.saluteFireFrameHandler);
            this.saluteContainer.removeChildAt(0);
         }
      }
      
      private function playSaluteSound() : void
      {
         this.timer = new Timer(100);
         this.timer.addEventListener(TimerEvent.TIMER,this.__timer);
         this.timer.start();
      }
      
      private function __timer(param1:TimerEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Boolean = false;
         _loc2_ = Math.round(Math.random() * 15);
         if(_loc2_ < 6)
         {
            _loc3_ = !(Math.round(Math.random() * 9) % 3) ? Boolean(Boolean(true)) : Boolean(Boolean(false));
            if(_loc3_)
            {
               SoundManager.instance.play("118");
            }
         }
      }
      
      private function stopSaluteSound() : void
      {
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.__timer);
            this.timer = null;
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this.timer)
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.__timer);
         }
         this.timer = null;
         if(this.saluteMask && this.saluteMask.parent)
         {
            this.saluteMask.parent.removeChild(this.saluteMask);
         }
         this.saluteMask = null;
         this.clearnSaluteFire();
         this.stopSaluteSound();
         if(this.saluteContainer && this.saluteContainer.parent)
         {
            this.saluteContainer.parent.removeChild(this.saluteContainer);
         }
         this.saluteContainer = null;
         if(parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
