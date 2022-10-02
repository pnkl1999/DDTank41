package newChickenBox.controller
{
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ClassUtils;
   import ddt.data.UIModuleTypes;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import ddt.view.UIModuleSmallLoading;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import newChickenBox.data.NewChickenBoxGoodsTempInfo;
   import newChickenBox.events.NewChickenBoxEvents;
   import newChickenBox.model.NewChickenBoxModel;
   import newChickenBox.view.NewChickenBoxCell;
   import newChickenBox.view.NewChickenBoxFrame;
   import newChickenBox.view.NewChickenBoxItem;
   import road7th.comm.PackageIn;
   
   public class NewChickenBoxManager extends EventDispatcher
   {
      
      private static var _instance:NewChickenBoxManager = null;
       
      
      public var firstEnter:Boolean = true;
      
      private var _isOpen:Boolean = false;
      
      private var _model:NewChickenBoxModel;
      
      private var newChickenBoxFrame:NewChickenBoxFrame;
      
      private var timer:Timer;
      
      public function NewChickenBoxManager()
      {
         super();
         this._model = NewChickenBoxModel.instance;
      }
      
      public static function get instance() : NewChickenBoxManager
      {
         if(_instance == null)
         {
            _instance = new NewChickenBoxManager();
         }
         return _instance;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN,this.__init);
      }
      
      private function __init(param1:CrazyTankSocketEvent) : void
      {
         this._isOpen = true;
         this.showNewBoxBtn();
         this.addSocketEvent();
         var _loc2_:PackageIn = param1.pkg;
         this._model.canOpenCounts = _loc2_.readInt();
         this._model.openCardPrice = [];
         var _loc3_:int = 0;
         while(_loc3_ < this._model.canOpenCounts)
         {
            this._model.openCardPrice.push(_loc2_.readInt());
            _loc3_++;
         }
         this._model.canEagleEyeCounts = _loc2_.readInt();
         this._model.eagleEyePrice = [];
         var _loc4_:int = 0;
         while(_loc4_ < this._model.canEagleEyeCounts)
         {
            this._model.eagleEyePrice.push(_loc2_.readInt());
            _loc4_++;
         }
         this._model.flushPrice = _loc2_.readInt();
         this._model.endTime = _loc2_.readDate();
      }
      
      public function showNewBoxBtn() : void
      {
         if(this._isOpen)
         {
            HallIconManager.instance.updateSwitchHandler(HallIconType.NEWCHICKENBOX,true);
         }
      }
      
      private function addSocketEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,this.__getItem);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CANCLICKCARDENABLE,this.__canclick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,this.__openCard);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,this.__openEye);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.OVERSHOWITEMS,this.__overshow);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,this.__closeActivity);
      }
      
      private function __overshow(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this.timer = new Timer(50,1);
         this.timer.addEventListener(TimerEvent.TIMER_COMPLETE,this.sendOverShow);
         this.timer.start();
         var _loc3_:Timer = new Timer(5000,1);
         _loc3_.addEventListener(TimerEvent.TIMER_COMPLETE,this.sendAgain);
         _loc3_.start();
         if(this.newChickenBoxFrame)
         {
            this.newChickenBoxFrame.closeButton.enable = false;
            this.newChickenBoxFrame.escEnable = false;
            this.newChickenBoxFrame.flushBnt.enable = false;
         }
      }
      
      private function sendAgain(param1:TimerEvent) : void
      {
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.newTurnStart"));
         this._model.countTime = 0;
         this._model.countEye = 0;
         this._model.canclickEnable = false;
         if(this.newChickenBoxFrame)
         {
            this.newChickenBoxFrame.startBnt.enable = true;
            this.newChickenBoxFrame.eyeBtn.enable = false;
            SocketManager.Instance.out.sendNewChickenBox();
            this.newChickenBoxFrame.closeButton.enable = true;
            this.newChickenBoxFrame.escEnable = true;
            this.newChickenBoxFrame.flushBnt.enable = true;
         }
      }
      
      private function sendOverShow(param1:TimerEvent) : void
      {
         var _loc2_:int = 0;
         SocketManager.Instance.out.sendOverShowItems();
         this._model.countTime = 0;
         this._model.countEye = 0;
         if(this.newChickenBoxFrame)
         {
            this.newChickenBoxFrame.startBnt.enable = false;
            this.newChickenBoxFrame.eyeBtn.enable = false;
            _loc2_ = this._model.canOpenCounts + 1 - this._model.countTime;
            this.newChickenBoxFrame.countNum.setFrame(_loc2_);
         }
         this.timer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.sendOverShow);
         this.timer = null;
      }
      
      private function __canclick(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.canclickEnable = _loc2_.readBoolean();
         this._model.dispatchEvent(new NewChickenBoxEvents(NewChickenBoxEvents.CANCLICKENABLE));
      }
      
      private function __getItem(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:NewChickenBoxGoodsTempInfo = null;
         this._model.countTime = 0;
         this._model.countEye = 0;
         var _loc2_:PackageIn = param1.pkg;
         this._model.lastFlushTime = _loc2_.readDate();
         this._model.freeFlushTime = _loc2_.readInt();
         this._model.freeRefreshBoxCount = _loc2_.readInt();
         this._model.freeEyeCount = _loc2_.readInt();
         this._model.freeOpenCardCount = _loc2_.readInt();
         this._model.isShowAll = _loc2_.readBoolean();
         this._model.boxCount = _loc2_.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < this._model.boxCount)
         {
            _loc4_ = new NewChickenBoxGoodsTempInfo();
            _loc4_.TemplateID = _loc2_.readInt();
            _loc4_.info = ItemManager.Instance.getTemplateById(_loc4_.TemplateID);
            _loc4_.StrengthenLevel = _loc2_.readInt();
            _loc4_.Count = _loc2_.readInt();
            _loc4_.ValidDate = _loc2_.readInt();
            _loc4_.AttackCompose = _loc2_.readInt();
            _loc4_.DefendCompose = _loc2_.readInt();
            _loc4_.AgilityCompose = _loc2_.readInt();
            _loc4_.LuckCompose = _loc2_.readInt();
            _loc4_.Position = _loc2_.readInt();
            _loc4_.IsSelected = _loc2_.readBoolean();
            _loc4_.IsSeeded = _loc2_.readBoolean();
            _loc4_.IsBinds = _loc2_.readBoolean();
            if(_loc4_.IsSelected)
            {
               ++this._model.countTime;
            }
            if(_loc4_.IsSeeded)
            {
               ++this._model.countEye;
            }
            if(this._model.isShowAll)
            {
               if(this.firstEnter)
               {
                  if(this._model.templateIDList.length == 18)
                  {
                     this._model.templateIDList[_loc3_] = _loc4_;
                  }
                  else
                  {
                     this._model.templateIDList.push(_loc4_);
                  }
                  this._model.countTime = 0;
                  this._model.countEye = 0;
               }
               else if(this._model.templateIDList.length == 18)
               {
                  this._model.templateIDList[_loc3_] = _loc4_;
               }
               this._model.canclickEnable = false;
            }
            else
            {
               if(this._model.templateIDList.length == 18)
               {
                  this._model.templateIDList[_loc3_] = _loc4_;
               }
               else
               {
                  this._model.templateIDList.push(_loc4_);
               }
               this._model.canclickEnable = true;
            }
            _loc3_++;
         }
         this.loadModule();
      }
      
      private function showBoxFrame() : void
      {
         if(this.firstEnter)
         {
            this.newChickenBoxFrame = ComponentFactory.Instance.creatComponentByStylename("newChickenBox.newChickenBoxFrame");
            if(this._model.isShowAll)
            {
               this.newChickenBoxFrame.startBnt.enable = true;
               this.newChickenBoxFrame.eyeBtn.enable = false;
            }
            else
            {
               this.newChickenBoxFrame.startBnt.enable = false;
               this.newChickenBoxFrame.eyeBtn.enable = true;
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("newChickenBox.firstEnterHelp"));
            }
            LayerManager.Instance.addToLayer(this.newChickenBoxFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
            this.firstEnter = false;
            if(this._model.countEye < this._model.canEagleEyeCounts)
            {
               this.newChickenBoxFrame.eyeBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useEyeCost",this._model.eagleEyePrice[this._model.countEye]);
            }
            else
            {
               this.newChickenBoxFrame.eyeBtn.enable = false;
            }
         }
         else if(this.newChickenBoxFrame)
         {
            this.newChickenBoxFrame.newBoxView.getAllItem();
            this._model.canclickEnable = false;
         }
      }
      
      private function loadModule() : void
      {
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.NEW_CHICKEN_BOX);
      }
      
      private function onUimoduleLoadProgress(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEW_CHICKEN_BOX)
         {
            UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
         }
      }
      
      private function loadCompleteHandler(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.NEW_CHICKEN_BOX)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.loadCompleteHandler);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.onUimoduleLoadProgress);
            this.showBoxFrame();
         }
      }
      
      private function __openCard(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:MovieClip = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:NewChickenBoxGoodsTempInfo = new NewChickenBoxGoodsTempInfo();
         _loc3_.TemplateID = _loc2_.readInt();
         _loc3_.info = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
         _loc3_.StrengthenLevel = _loc2_.readInt();
         _loc3_.Count = _loc2_.readInt();
         _loc3_.ValidDate = _loc2_.readInt();
         _loc3_.AttackCompose = _loc2_.readInt();
         _loc3_.DefendCompose = _loc2_.readInt();
         _loc3_.AgilityCompose = _loc2_.readInt();
         _loc3_.LuckCompose = _loc2_.readInt();
         _loc3_.Position = _loc2_.readInt();
         _loc3_.IsSelected = _loc2_.readBoolean();
         _loc3_.IsSeeded = _loc2_.readBoolean();
         _loc3_.IsBinds = _loc2_.readBoolean();
         this._model.freeOpenCardCount = _loc2_.readInt();
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,39,39);
         _loc4_.graphics.endFill();
         var _loc5_:NewChickenBoxCell = new NewChickenBoxCell(_loc4_,_loc3_.info);
         if(_loc3_.IsSelected)
         {
            _loc6_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenOver") as MovieClip;
         }
         else if(_loc3_.IsSeeded)
         {
            _loc6_ = ClassUtils.CreatInstance("asset.newChickenBox.chicken360") as MovieClip;
         }
         var _loc7_:NewChickenBoxItem = new NewChickenBoxItem(_loc5_,_loc6_);
         _loc7_.info = _loc3_;
         _loc7_.position = _loc3_.Position;
         this.newChickenBoxFrame.newBoxView.removeChild(this._model.itemList[_loc3_.Position]);
         this._model.itemList[_loc3_.Position] = _loc7_;
         this.newChickenBoxFrame.newBoxView.addChild(this._model.itemList[_loc3_.Position]);
         this._model.itemList[_loc3_.Position].bg = _loc6_;
         this._model.itemList[_loc3_.Position].cell = _loc5_;
         this._model.itemList[_loc3_.Position].cell.visible = false;
         var _loc8_:String = "newChickenBox.itemPos" + _loc3_.Position;
         PositionUtils.setPos(this._model.itemList[_loc3_.Position],_loc8_);
         ++this._model.countTime;
         var _loc9_:int = this._model.canOpenCounts + 1 - this._model.countTime;
         this.newChickenBoxFrame.countNum.setFrame(_loc9_);
         if(this._model.countTime >= this._model.canOpenCounts)
         {
            this.newChickenBoxFrame.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",0);
         }
         else
         {
            this.newChickenBoxFrame.msgText.text = LanguageMgr.GetTranslation("newChickenBox.useMoneyMsg",this._model.openCardPrice[this._model.countTime]);
         }
      }
      
      private function __openEye(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:MovieClip = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:NewChickenBoxGoodsTempInfo = new NewChickenBoxGoodsTempInfo();
         _loc3_.TemplateID = _loc2_.readInt();
         _loc3_.info = ItemManager.Instance.getTemplateById(_loc3_.TemplateID);
         _loc3_.StrengthenLevel = _loc2_.readInt();
         _loc3_.Count = _loc2_.readInt();
         _loc3_.ValidDate = _loc2_.readInt();
         _loc3_.AttackCompose = _loc2_.readInt();
         _loc3_.DefendCompose = _loc2_.readInt();
         _loc3_.AgilityCompose = _loc2_.readInt();
         _loc3_.LuckCompose = _loc2_.readInt();
         _loc3_.Position = _loc2_.readInt();
         _loc3_.IsSelected = _loc2_.readBoolean();
         _loc3_.IsSeeded = _loc2_.readBoolean();
         _loc3_.IsBinds = _loc2_.readBoolean();
         this._model.freeEyeCount = _loc2_.readInt();
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginFill(16777215,0);
         _loc4_.graphics.drawRect(0,0,39,39);
         _loc4_.graphics.endFill();
         var _loc5_:NewChickenBoxCell = new NewChickenBoxCell(_loc4_,_loc3_.info);
         if(_loc3_.IsSelected)
         {
            _loc6_ = ClassUtils.CreatInstance("asset.newChickenBox.chickenOver") as MovieClip;
         }
         else if(_loc3_.IsSeeded)
         {
            _loc6_ = ClassUtils.CreatInstance("asset.newChickenBox.chicken360") as MovieClip;
         }
         ++this._model.countEye;
         var _loc7_:NewChickenBoxItem = new NewChickenBoxItem(_loc5_,_loc6_);
         _loc7_.info = _loc3_;
         _loc7_.position = _loc3_.Position;
         this.newChickenBoxFrame.newBoxView.removeChild(this._model.itemList[_loc3_.Position]);
         this._model.itemList[_loc3_.Position] = _loc7_;
         this.newChickenBoxFrame.newBoxView.addChild(this._model.itemList[_loc3_.Position]);
         if(this._model.countEye < this._model.canEagleEyeCounts)
         {
            this.newChickenBoxFrame.eyeBtn.tipData = LanguageMgr.GetTranslation("newChickenBox.useEyeCost",this._model.eagleEyePrice[this._model.countEye]);
         }
         else
         {
            this.newChickenBoxFrame.eyeBtn.enable = false;
            this._model.clickEagleEye = false;
         }
         this._model.itemList[_loc3_.Position].bg = _loc6_;
         this._model.itemList[_loc3_.Position].cell = _loc5_;
         this._model.itemList[_loc3_.Position].cell.visible = false;
         var _loc8_:String = "newChickenBox.itemPos" + _loc3_.Position;
         PositionUtils.setPos(this._model.itemList[_loc3_.Position],_loc8_);
         this.newChickenBoxFrame.newBoxView.getItemEvent(_loc7_);
      }
      
      public function enterNewBoxView(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendNewChickenBox();
      }
      
      private function removeSocketEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.GET_NEWCHICKENBOX_LIST,this.__getItem);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CANCLICKCARDENABLE,this.__canclick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_CARD,this.__openCard);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_OPEN_EYE,this.__openEye);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.OVERSHOWITEMS,this.__overshow);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.NEWCHICKENBOX_CLOSE,this.__closeActivity);
      }
      
      private function __closeActivity(param1:CrazyTankSocketEvent) : void
      {
         this._isOpen = false;
         this.firstEnter = true;
         this._model.canclickEnable = false;
         Mouse.show();
         this.removeSocketEvent();
         if(this.newChickenBoxFrame)
         {
            this.newChickenBoxFrame.dispose();
            this.newChickenBoxFrame = null;
         }
         HallIconManager.instance.updateSwitchHandler(HallIconType.NEWCHICKENBOX,false);
      }
   }
}
