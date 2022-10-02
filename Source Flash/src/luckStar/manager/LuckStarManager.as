package luckStar.manager
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.StateManager;
   import ddt.states.StateType;
   import flash.events.MouseEvent;
   import hallIcon.HallIconManager;
   import hallIcon.HallIconType;
   import luckStar.LoadingLuckStarUI;
   import luckStar.event.LuckStarEvent;
   import luckStar.model.LuckStarModel;
   import luckStar.view.LuckStarFrame;
   import road7th.comm.PackageIn;
   
   public class LuckStarManager
   {
      
      private static var _instance:LuckStarManager;
       
      
      private var _frame:LuckStarFrame;
      
      private var _model:LuckStarModel;
      
      private var _isOpen:Boolean;
      
      public function LuckStarManager()
      {
         super();
         this._model = new LuckStarModel();
      }
      
      public static function get Instance() : LuckStarManager
      {
         if(_instance == null)
         {
            _instance = new LuckStarManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_OPEN,this.__onActivityOpen);
      }
      
      private function __onActivityOpen(param1:CrazyTankSocketEvent) : void
      {
         if(!this._isOpen)
         {
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_END,this.__onActivityEnd);
         }
         this._isOpen = true;
         this.addEnterIcon();
      }
      
      private function __onActivityEnd(param1:CrazyTankSocketEvent) : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_END,this.__onActivityEnd);
         this._isOpen = false;
         this.disposeEnterIcon();
      }
      
      private function __onAllGoodsInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc8_:int = 0;
         var _loc9_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         this._model.coins = _loc2_.readInt();
         this._model.setActivityDate(_loc2_.readDate(),_loc2_.readDate());
         this._model.minUseNum = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc8_ = _loc2_.readInt();
            _loc9_ = this.getTemplateInfo(_loc8_);
            _loc9_.StrengthenLevel = _loc2_.readInt();
            _loc9_.Count = _loc2_.readInt();
            _loc9_.ValidDate = _loc2_.readInt();
            _loc9_.AttackCompose = _loc2_.readInt();
            _loc9_.DefendCompose = _loc2_.readInt();
            _loc9_.AgilityCompose = _loc2_.readInt();
            _loc9_.LuckCompose = _loc2_.readInt();
            _loc9_.IsBinds = _loc2_.readBoolean();
            _loc9_.Quality = _loc2_.readInt();
            _loc4_.push(_loc9_);
            _loc5_++;
         }
         var _loc6_:Vector.<InventoryItemInfo> = _loc4_.slice();
         var _loc7_:int = _loc6_.length;
         while(_loc7_)
         {
            _loc6_.push(_loc6_.splice(int(Math.random() * _loc7_--),1)[0]);
         }
         this._model.goods = _loc6_;
         if(this._frame)
         {
            this._frame.updateActivityDate();
         }
      }
      
      private function __onTurnGoodsInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         this._model.coins = _loc2_.readInt();
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:InventoryItemInfo = this.getTemplateInfo(_loc3_);
         _loc4_.StrengthenLevel = _loc2_.readInt();
         _loc4_.Count = _loc2_.readInt();
         _loc4_.ValidDate = _loc2_.readInt();
         _loc4_.AttackCompose = _loc2_.readInt();
         _loc4_.DefendCompose = _loc2_.readInt();
         _loc4_.AgilityCompose = _loc2_.readInt();
         _loc4_.LuckCompose = _loc2_.readInt();
         _loc4_.IsBinds = _loc2_.readBoolean();
         this._frame.getAwardGoods(_loc4_);
      }
      
      private function __onUpdateReward(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:String = _loc2_.readUTF();
         this._frame.updateNewAwardList(_loc5_,_loc3_,_loc4_);
      }
      
      private function __onReward(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:Array = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Vector.<Array> = new Vector.<Array>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = [];
            _loc6_.push(_loc2_.readInt());
            _loc6_.push(_loc2_.readInt());
            _loc6_.push(_loc2_.readUTF());
            _loc4_.push(_loc6_);
            _loc5_++;
         }
         this._model.newRewardList = _loc4_;
      }
      
      private function __onAwardRank(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:int = 0;
         var _loc7_:InventoryItemInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:Vector.<InventoryItemInfo> = new Vector.<InventoryItemInfo>();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc6_ = _loc2_.readInt();
            _loc7_ = this.getTemplateInfo(_loc6_);
            _loc7_.StrengthenLevel = _loc2_.readInt();
            _loc7_.Count = _loc2_.readInt();
            _loc7_.ValidDate = _loc2_.readInt();
            _loc7_.AttackCompose = _loc2_.readInt();
            _loc7_.DefendCompose = _loc2_.readInt();
            _loc7_.AgilityCompose = _loc2_.readInt();
            _loc7_.LuckCompose = _loc2_.readInt();
            _loc7_.IsBinds = _loc2_.readBoolean();
            _loc7_.Quality = _loc2_.readInt();
            _loc4_.push(_loc7_);
            _loc5_++;
         }
         this._model.reward = _loc4_;
      }
      
      private function getTemplateInfo(param1:int) : InventoryItemInfo
      {
         var _loc2_:InventoryItemInfo = new InventoryItemInfo();
         _loc2_.TemplateID = param1;
         ItemManager.fill(_loc2_);
         return _loc2_;
      }
      
      private function _onLuckyStarEvent(param1:LuckStarEvent) : void
      {
         if(this._frame)
         {
            if(param1.code == LuckStarEvent.GOODS)
            {
               this._frame.updateCellInfo();
               this._frame.updateMinUseNum();
            }
            else if(param1.code == LuckStarEvent.COINS)
            {
               this._frame.updateLuckyStarCoins();
            }
            else if(param1.code == LuckStarEvent.NEW_REWARD_LIST)
            {
               this._frame.updatePlayActionList();
            }
         }
      }
      
      public function addEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LUCKSTAR,true);
      }
      
      public function onClickLuckyStarIocn(param1:MouseEvent) : void
      {
         if(StateManager.currentStateType == StateType.MAIN)
         {
            LoadingLuckStarUI.Instance.startLoad();
         }
      }
      
      public function disposeEnterIcon() : void
      {
         HallIconManager.instance.updateSwitchHandler(HallIconType.LUCKSTAR,false);
      }
      
      public function dispose() : void
      {
         this.disposeEnterIcon();
      }
      
      public function openLuckyStarFrame() : void
      {
         if(this._frame == null)
         {
            this._frame = ComponentFactory.Instance.creat("luckyStar.view.LuckStarFrame");
            this._frame.titleText = LanguageMgr.GetTranslation("ddt.luckStar.frameTitle");
            this._frame.addEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._model.addEventListener(LuckStarEvent.LUCKYSTAR_EVENT,this._onLuckyStarEvent);
         }
         LoadingLuckStarUI.Instance.RequestActivityRank();
         LayerManager.Instance.addToLayer(this._frame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         this.addSocketEvent();
         SocketManager.Instance.out.sendLuckyStarEnter();
      }
      
      private function __onFrameClose(param1:FrameEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            if(this._frame.isTurn)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.luckStar.notExit"));
               return;
            }
            this._frame.removeEventListener(FrameEvent.RESPONSE,this.__onFrameClose);
            this._model.removeEventListener(LuckStarEvent.LUCKYSTAR_EVENT,this._onLuckyStarEvent);
            ObjectUtils.disposeObject(this._frame);
            this._frame = null;
            SocketManager.Instance.out.sendLuckyStarClose();
            this.removeSocketEvent();
         }
      }
      
      public function addSocketEvent() : void
      {
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,this.__onTurnGoodsInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,this.__onUpdateReward);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,this.__onAllGoodsInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_RECORD,this.__onReward);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,this.__onAwardRank);
      }
      
      public function removeSocketEvent() : void
      {
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_GOODSINFO,this.__onTurnGoodsInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_REWARDINFO,this.__onUpdateReward);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_ALLGOODS,this.__onAllGoodsInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_RECORD,this.__onReward);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.LUCKYSTAR_AWARDRANK,this.__onAwardRank);
      }
      
      public function updateLuckyStarRank(param1:Object) : void
      {
         if(this._frame)
         {
            this._frame.updateRankInfo();
         }
      }
      
      public function get openState() : Boolean
      {
         return this._frame != null;
      }
      
      public function get isOpen() : Boolean
      {
         return this._isOpen;
      }
      
      public function get model() : LuckStarModel
      {
         return this._model;
      }
   }
}
