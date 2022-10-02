package pet.sprite
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.DisplayUtils;
   import ddt.events.PlayerPropertyEvent;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import ddt.utils.Helpers;
   import ddt.utils.PositionUtils;
   import farm.FarmModelController;
   import farm.modelx.FieldVO;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import pet.date.PetInfo;
   
   public class PetSpriteController extends EventDispatcher
   {
      
      private static const DEFAULT_SHOW_TIME:int = 5000;
      
      private static const CHECK_TIME:int = 30 * 1000;
      
      private static var _instance:PetSpriteController;
      
      private static const ACTION:Array = ["walkA","walkB","standA","bsetC"];
       
      
      private var _petSprite:PetSprite;
      
      private var _petModel:PetSpriteModel;
      
      private var _isShown:Boolean = false;
      
      private var _loopTimer:Timer;
      
      private var _loopIntervalTime:int = 5000;
      
      private var _queue:Vector.<PetMessage>;
      
      private var _checkTimer:Timer;
      
      private var _hasBeenSetup:Boolean = false;
      
      public function PetSpriteController(param1:SingletonEnforcer)
      {
         this._queue = new Vector.<PetMessage>();
         super();
         this._petModel = new PetSpriteModel();
      }
      
      public static function get Instance() : PetSpriteController
      {
         if(!_instance)
         {
            _instance = new PetSpriteController(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public function setup() : void
      {
         if(this._hasBeenSetup)
         {
            return;
         }
         if(!this.canInitPetSprite())
         {
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGradeChanged);
            return;
         }
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__onGradeChanged);
         this._hasBeenSetup = true;
         this.init();
         this.initEvent();
         this._checkTimer = new Timer(CHECK_TIME);
         this._checkTimer.addEventListener(TimerEvent.TIMER,this.__onCheckTimer);
         this._checkTimer.start();
         ChatManager.Instance.output.openPetSprite(PlayerManager.Instance.Self.pets.length > 0);
         this._petModel.petSwitcher = true;
         this.enableChatViewPetSwitcher(PlayerManager.Instance.Self.currentPet != null);
         this._loopTimer = new Timer(this._loopIntervalTime);
         this._loopTimer.addEventListener(TimerEvent.TIMER,this.__messageLoop);
         if(PlayerManager.Instance.Self.pets.length > 0 && !PlayerManager.Instance.Self.currentPet)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PlayerManager.Instance.Self.pets[0].Place);
         }
         else if(PlayerManager.Instance.Self.pets.length > 0 && PlayerManager.Instance.Self.currentPet)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PlayerManager.Instance.Self.currentPet.Place);
         }
      }
      
      protected function __onGradeChanged(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties["Grade"])
         {
            if(this.canInitPetSprite())
            {
               this.setup();
            }
         }
      }
      
      protected function __onCheckTimer(param1:TimerEvent) : void
      {
         this.checkMessageQueue();
         this.checkHunger();
         this.checkFarmCrop();
      }
      
      public function checkFarmCropRipe() : Boolean
      {
         return this.checkFarmCrop();
      }
      
      private function checkFarmCrop() : Boolean
      {
         var _loc3_:FieldVO = null;
         var _loc1_:Boolean = false;
         var _loc2_:Vector.<FieldVO> = FarmModelController.instance.model.selfFieldsInfo;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.plantGrownPhase == 2)
            {
               _loc1_ = true;
               break;
            }
         }
         if(_loc1_)
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.hasCropMature"),true,1,"walkA");
         }
         return _loc1_;
      }
      
      private function checkMessageQueue() : void
      {
         var _loc1_:PetMessage = null;
         if(this._isShown || !this.canShowPetSprite())
         {
            return;
         }
         while(this.hasMessageInQueue())
         {
            _loc1_ = this._queue[0];
            if(!(!_loc1_.isAlwaysShow && !this._petModel.petSwitcher))
            {
               this.showNextMessage();
            }
            this._queue.pop();
         }
      }
      
      public function get model() : PetSpriteModel
      {
         return this._petModel;
      }
      
      public function switchPetSprite(param1:Boolean) : void
      {
         if(param1 && this._petSprite.petSpriteLand && this.canShowPetSprite())
         {
            this._petSprite.petSpriteLand.gotoAndPlay(1);
         }
         else if(this._petSprite && this._petSprite.petSpriteLand)
         {
            this._petSprite.petNotMove();
         }
         this._petModel.petSwitcher = param1;
         if(!this.canInitPetSprite())
         {
            return;
         }
         if(param1)
         {
            this.say("");
         }
         else
         {
            this.hidePetSprite(false,false);
            this._queue.length = 0;
         }
      }
      
      private function canInitPetSprite() : Boolean
      {
         return PlayerManager.Instance.Self.Grade >= ServerConfigManager.instance.minOpenPetSystemLevel;
      }
      
      public function get petSwitcher() : Boolean
      {
         return this._petModel.petSwitcher;
      }
      
      public function generatePetMovie() : void
      {
         if(!this._petModel.petSwitcher)
         {
            return;
         }
         var _loc1_:String = Helpers.randomPick(ACTION);
         if(_loc1_ == "walkB")
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.pose1"),true,1,_loc1_);
            this._petSprite.petMove();
         }
         else if(_loc1_ == "walkA")
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.pose2"),true,1,_loc1_);
            this._petSprite.petMove();
         }
         else if(_loc1_ == "bsetC")
         {
            this._petSprite.petNotMove();
            this.say("",false,-1,_loc1_);
         }
         else
         {
            this._petSprite.petNotMove();
            this.say(LanguageMgr.GetTranslation("ddt.pets.pose3"),true,1,_loc1_);
         }
      }
      
      private function init() : void
      {
         this._petSprite = ComponentFactory.Instance.creatCustomObject("petSprite.PetSprite",[this._petModel,this]);
      }
      
      private function initEvent() : void
      {
         this._petModel.addEventListener(PetSpriteModel.CURRENT_PET_CHANGED,this.__onCurrentPetChanged);
      }
      
      protected function __onCurrentPetChanged(param1:Event) : void
      {
         this._petSprite.updatePet();
         if(this._petModel.currentPet)
         {
            this.generatePetMovie();
         }
         else
         {
            this._queue.length = 0;
            this.hidePetSprite(true,false);
            this.enableChatViewPetSwitcher(false);
         }
         this._petSprite.petNotMove();
         this.checkHunger();
      }
      
      public function checkHunger() : void
      {
         if(this._petModel.currentPet && Number(this._petModel.currentPet.Hunger) / PetInfo.FULL_MAX_VALUE < 0.8)
         {
            this.say(LanguageMgr.GetTranslation("ddt.pets.hungerMsg"),true,1,PetSprite.HUNGER);
            this._petSprite.petNotMove();
         }
      }
      
      public function checkGP() : void
      {
      }
      
      public function showPetSprite(param1:Boolean = false, param2:Boolean = false) : void
      {
         if(!this.canShowPetSprite() || !this._petModel.currentPet || !this._petSprite || !this._petModel.currentPet.assetReady || this._isShown)
         {
            if(!this._petModel.currentPet)
            {
               dispatchEvent(new Event(Event.CLOSE));
            }
            return;
         }
         if(!this._petModel.petSwitcher && !param2)
         {
            return;
         }
         if(this._petModel.currentPet && Number(this._petModel.currentPet.Hunger) / PetInfo.FULL_MAX_VALUE < 0.5)
         {
            SocketManager.Instance.out.sendPetFightUnFight(PlayerManager.Instance.Self.currentPet.Place,false);
            dispatchEvent(new Event(Event.CLOSE));
            return;
         }
         LayerManager.Instance.addToLayer(this._petSprite,LayerManager.GAME_UI_LAYER,false,0,false);
         LayerManager.Instance.addToLayer(this._petSprite.petSpriteLand,LayerManager.GAME_UI_LAYER,false,0,false);
         this._petSprite.petSpriteLand.gotoAndPlay(0);
         if(this._petModel.currentPet.Level < 50)
         {
            PositionUtils.setPos(this._petSprite,"petSprite.PetSprite.pet1Pos");
         }
         else
         {
            PositionUtils.setPos(this._petSprite,"petSprite.PetSprite.pet2Pos");
         }
         this._isShown = true;
         if(!param1)
         {
            this.enableChatViewPetSwitcher(false);
            this._petSprite.playAnimation(PetSprite.APPEAR,this.afterAppear);
         }
         else
         {
            this._petSprite.playAnimation("walkA");
            this.enableChatViewPetSwitcher(true);
            this._loopTimer.start();
         }
      }
      
      private function afterAppear() : void
      {
         this._loopTimer.reset();
         this._loopTimer.start();
         this.enableChatViewPetSwitcher(true);
      }
      
      private function __messageLoop(param1:TimerEvent) : void
      {
         if(!this._petModel.petSwitcher && this._isShown)
         {
            this.hidePetSprite(true,false);
            return;
         }
         if(!this.hasMessageInQueue())
         {
            this.generatePetMovie();
         }
         this.showNextMessage();
      }
      
      public function hidePetSprite(param1:Boolean = false, param2:Boolean = true) : void
      {
         if(!this._petSprite)
         {
            return;
         }
         if(param2 && this.showNextMessage())
         {
            return;
         }
         this._loopTimer.stop();
         this._petSprite.hideMessageText();
         if(param1)
         {
            this._petSprite.playAnimation("walkA");
            this.removePetSprite();
         }
         else
         {
            this.enableChatViewPetSwitcher(false);
            this._petSprite.playAnimation(PetSprite.DISAPPEAR,this.removePetSprite);
         }
      }
      
      private function removePetSprite() : void
      {
         if(this._petSprite.petSpriteLand && !this._petModel.petSwitcher)
         {
            this._petSprite.petSpriteLand.gotoAndPlay("out");
         }
         else if(this._petSprite.petSpriteLand)
         {
            DisplayUtils.removeDisplay(this._petSprite.petSpriteLand);
         }
         DisplayUtils.removeDisplay(this._petSprite);
         this._isShown = false;
         if(this._petModel.currentPet != null)
         {
            this.enableChatViewPetSwitcher(true);
         }
      }
      
      private function canShowPetSprite() : Boolean
      {
         var _loc1_:String = StateManager.currentStateType;
         if(_loc1_ == StateType.MAIN || _loc1_ == StateType.ROOM_LIST || _loc1_ == StateType.DUNGEON_LIST || _loc1_ == StateType.MATCH_ROOM || _loc1_ == StateType.DUNGEON_ROOM)
         {
            this.enableChatViewPetSwitcher(this._petModel.currentPet != null);
            ChatManager.Instance.output.PetSpriteSwitchVisible(true);
            return true;
         }
         ChatManager.Instance.output.PetSpriteSwitchVisible(false);
         return false;
      }
      
      private function enableChatViewPetSwitcher(param1:Boolean) : void
      {
         ChatManager.Instance.output.enablePetSpriteSwitcher(param1);
      }
      
      public function showNextMessage() : Boolean
      {
         if(!this._petModel.currentPet || !this.hasMessageInQueue() || !this.canShowPetSprite())
         {
            return false;
         }
         var _loc1_:PetMessage = this._queue.pop();
         if(this._isShown)
         {
            this._petSprite.playAnimation(_loc1_.action);
         }
         else
         {
            this.showPetSprite(false,_loc1_.isAlwaysShow);
         }
         if(_loc1_.type == 1)
         {
            this._petSprite.say(_loc1_.msg);
         }
         else if(_loc1_.type == -1)
         {
            this._petSprite.hideMessageText();
         }
         return true;
      }
      
      public function say(param1:String, param2:Boolean = false, param3:int = -1, param4:String = "born3") : void
      {
         if(this._isShown || !this.canShowPetSprite())
         {
            if(this._petModel.petSwitcher || param2)
            {
               this._queue.push(new PetMessage(param3,param4,param1,param2));
            }
         }
         else
         {
            if(param4 == PetSprite.HUNGER)
            {
               this.showPetSprite(true,true);
               this._petSprite.playAnimation(PetSprite.HUNGER);
            }
            else
            {
               this.showPetSprite(param3 == 1,param2);
            }
            if(param3 == 1)
            {
               this._petSprite.say(param1);
            }
         }
      }
      
      public function hasMessageInQueue() : Boolean
      {
         return this._queue.length > 0;
      }
      
      public function get petSprite() : PetSprite
      {
         return this._petSprite;
      }
      
      public function set petSprite(param1:PetSprite) : void
      {
         this._petSprite = param1;
      }
   }
}

class SingletonEnforcer
{
    
   
   function SingletonEnforcer()
   {
      super();
   }
}

class PetMessage
{
    
   
   public var type:int;
   
   public var action:String;
   
   public var msg:String;
   
   public var isAlwaysShow:Boolean;
   
   function PetMessage(param1:int, param2:String, param3:String, param4:Boolean)
   {
      super();
      this.type = param1;
      this.action = param2;
      this.msg = param3;
      this.isAlwaysShow = param4;
   }
}
