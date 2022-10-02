package ddt.manager
{
   import bagAndInfo.cell.BagCell;
   import com.pickgliss.action.FunctionAction;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.events.UIModuleEvent;
   import com.pickgliss.loader.UIModuleLoader;
   import com.pickgliss.manager.CacheSysManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import ddt.command.QuickBuyFrame;
   import ddt.constants.CacheConsts;
   import ddt.data.EquipType;
   import ddt.data.UIModuleTypes;
   import ddt.data.box.BoxGoodsTempInfo;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.events.BagEvent;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.states.StateType;
   import ddt.view.UIModuleSmallLoading;
   import ddt.view.caddyII.CaddyEvent;
   import ddt.view.caddyII.CaddyFrame;
   import ddt.view.caddyII.CaddyModel;
   import ddt.view.caddyII.badLuck.ReceiveBadLuckAwardFrame;
   import ddt.view.caddyII.card.CardFrame;
   import ddt.view.roulette.RouletteBoxPanel;
   import ddt.view.roulette.RouletteEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import road7th.comm.PackageIn;
   import surpriseRoulette.view.SurpriseRouletteView;
   
   public class RouletteManager extends EventDispatcher
   {
      
      private static var _instance:RouletteManager = null;
      
      public static const SLEEP:int = 0;
      
      public static const OPEN_ROULETTEBOX:int = 1;
      
      public static const OPEN_CADDY:int = 2;
      
      public static const OPEN_S_ROULETTE:int = 3;
      
      public static const NO_BOX:int = 0;
      
      public static const ROULETTEBOX:int = 1;
      
      public static const CADDY:int = 2;
       
      
      private var _rouletteBoxkeyCount:int = -1;
      
      private var _sRouletteKeyCount:int = 10;
      
      private var id:int;
      
      private var _caddyKeyCount:int = -1;
      
      private var _templateIDList:Array;
      
      private var _bagType:int;
      
      private var _place:int;
      
      private var _stateAfterBuyKey:int = 0;
      
      private var _boxType:int = 0;
      
      public var dataList:Vector.<Object>;
      
      public var goodList:Vector.<InventoryItemInfo>;
      
      private var _openCaddyCell:BagCell;
      
      public function RouletteManager(param1:IEventDispatcher = null)
      {
         super(param1);
      }
      
      public static function get instance() : RouletteManager
      {
         if(_instance == null)
         {
            _instance = new RouletteManager();
         }
         return _instance;
      }
      
      public function setup() : void
      {
         this.init();
         this.initEvent();
      }
      
      private function init() : void
      {
         this._templateIDList = new Array();
      }
      
      private function initEvent() : void
      {
         PlayerManager.Instance.Self.PropBag.addEventListener(BagEvent.UPDATE,this._bagUpdate);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.CADDY_GET_BADLUCK,this.__getBadLuckHandler);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.LOTTERY_ALTERNATE_LIST,this._showBox);
      }
      
      private function _showBox(param1:CrazyTankSocketEvent) : void
      {
         switch(this._boxType)
         {
            case ROULETTEBOX:
               this._showRoultteView(param1);
               break;
            case CADDY:
         }
      }
      
      private function _showRoultteView(param1:CrazyTankSocketEvent) : void
      {
         var _loc4_:BoxGoodsTempInfo = null;
         var _loc2_:PackageIn = param1.pkg;
         try
         {
            this.id = _loc2_.readInt();
         }
         catch(e:Error)
         {
         }
         var _loc3_:int = 0;
         while(_loc3_ < 18)
         {
            try
            {
               _loc4_ = new BoxGoodsTempInfo();
               _loc4_.TemplateId = _loc2_.readInt();
               _loc4_.IsBind = _loc2_.readBoolean();
               _loc4_.ItemCount = _loc2_.readByte();
               _loc4_.ItemValid = _loc2_.readByte();
               this._templateIDList.push(_loc4_);
            }
            catch(e:Error)
            {
            }
            _loc3_++;
         }
         this._randomTemplateID();
         if(this.id == EquipType.SURPRISE_ROULETTE_BOX)
         {
            this.showSurpriseRouletteView();
         }
         else if(this.id == EquipType.ROULETTE_BOX)
         {
            this.showRouletteView();
         }
         this._boxType = NO_BOX;
      }
      
      public function useRouletteBox(param1:BagCell) : void
      {
         this._rouletteBoxkeyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
         this._bagType = param1.itemInfo.BagType;
         this._place = param1.itemInfo.Place;
         this._boxType = ROULETTEBOX;
         if(this._rouletteBoxkeyCount >= 1)
         {
            SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
         }
         else
         {
            this._stateAfterBuyKey = OPEN_ROULETTEBOX;
            this.showBuyRouletteKey(1,EquipType.ROULETTE_KEY);
         }
      }
      
      public function useSurpriseRoulette(param1:BagCell) : void
      {
         this._sRouletteKeyCount = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.SURPRISE_ROULETTE_KEY);
         this._bagType = param1.itemInfo.BagType;
         this._place = param1.itemInfo.Place;
         this._boxType = ROULETTEBOX;
         if(this._sRouletteKeyCount >= 1)
         {
            SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
         }
         else
         {
            this._stateAfterBuyKey = OPEN_ROULETTEBOX;
            this.showBuyRouletteKey(1,EquipType.SURPRISE_ROULETTE_KEY);
         }
      }
      
      private function updateState() : void
      {
         switch(this._stateAfterBuyKey)
         {
            case SLEEP:
               break;
            case OPEN_ROULETTEBOX:
               if(this._rouletteBoxkeyCount >= 1)
               {
                  SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
               }
               this._stateAfterBuyKey = SLEEP;
               break;
            case OPEN_CADDY:
               break;
            case OPEN_S_ROULETTE:
               if(this._sRouletteKeyCount >= 1)
               {
                  SocketManager.Instance.out.sendRouletteBox(this._bagType,this._place);
               }
               this._stateAfterBuyKey = SLEEP;
         }
      }
      
      public function showRouletteView() : void
      {
         var _loc1_:RouletteBoxPanel = ComponentFactory.Instance.creat("roulette.RoulettePanelAsset");
         _loc1_.templateIDList = this._templateIDList;
         _loc1_.keyCount = this._rouletteBoxkeyCount;
         _loc1_.show();
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function showSurpriseRouletteView() : void
      {
         var _loc1_:SurpriseRouletteView = new SurpriseRouletteView(this._templateIDList);
         _loc1_.keyCount = this._sRouletteKeyCount;
         LayerManager.Instance.addToLayer(_loc1_,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function showBuyRouletteKey(param1:int, param2:int) : void
      {
         var _loc3_:QuickBuyFrame = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
         _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
         _loc3_.itemID = param2;
         _loc3_.stoneNumber = param1;
         LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         _loc3_.addEventListener(FrameEvent.RESPONSE,this._response);
      }
      
      private function _response(param1:FrameEvent) : void
      {
         (param1.currentTarget as QuickBuyFrame).removeEventListener(FrameEvent.RESPONSE,this._response);
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            this._closeFun();
         }
      }
      
      private function _closeFun() : void
      {
         this._stateAfterBuyKey = SLEEP;
      }
      
      private function _randomTemplateID() : void
      {
         var _loc3_:int = 0;
         var _loc1_:BoxGoodsTempInfo = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._templateIDList.length)
         {
            _loc3_ = Math.floor(Math.random() * this._templateIDList.length);
            _loc1_ = this._templateIDList[_loc2_] as BoxGoodsTempInfo;
            this._templateIDList[_loc2_] = this._templateIDList[_loc3_];
            this._templateIDList[_loc3_] = _loc1_;
            _loc2_++;
         }
      }
      
      private function _bagUpdate(param1:BagEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:RouletteEvent = null;
         _loc2_ = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.SURPRISE_ROULETTE_KEY);
         if(this._sRouletteKeyCount != _loc2_)
         {
            _loc3_ = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
            _loc3_.keyCount = this._sRouletteKeyCount = _loc2_;
            dispatchEvent(_loc3_);
            this.updateState();
            return;
         }
         _loc2_ = PlayerManager.Instance.Self.PropBag.getItemCountByTemplateId(EquipType.ROULETTE_KEY);
         if(this._rouletteBoxkeyCount != _loc2_)
         {
            _loc3_ = new RouletteEvent(RouletteEvent.ROULETTE_KEYCOUNT_UPDATE);
            _loc3_.keyCount = this._rouletteBoxkeyCount = _loc2_;
            dispatchEvent(_loc3_);
            this.updateState();
         }
      }
      
      private function __getBadLuckHandler(param1:CrazyTankSocketEvent) : void
      {
         var _loc6_:Object = null;
         var _loc7_:CaddyEvent = null;
         this.dataList = new Vector.<Object>();
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:String = _loc2_.readUTF();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_)
         {
            _loc6_ = new Object();
            _loc6_["Rank"] = _loc2_.readInt();
            _loc6_["UserID"] = _loc2_.readInt();
            _loc6_["Count"] = _loc2_.readInt();
            _loc6_["TemplateID"] = _loc2_.readInt();
            _loc6_["Nickname"] = _loc2_.readUTF();
            this.dataList.push(_loc6_);
            _loc5_++;
         }
         if(_loc4_ == 0 || this.dataList[0].TemplateID == 0)
         {
            _loc7_ = new CaddyEvent(CaddyEvent.UPDATE_BADLUCK);
            _loc7_.lastTime = _loc3_;
            _loc7_.dataList = this.dataList;
            dispatchEvent(_loc7_);
         }
         else if(this.getStateAble(StateManager.currentStateType))
         {
            this.__showBadLuckEndFrame();
         }
         else
         {
            CacheSysManager.getInstance().cacheFunction(CacheConsts.ALERT_IN_HALL,new FunctionAction(this.__showBadLuckEndFrame));
         }
      }
      
      private function __showBadLuckEndFrame() : void
      {
         var _loc1_:ReceiveBadLuckAwardFrame = ComponentFactory.Instance.creatComponentByStylename("caddy.ReceiveBadLuckAwardFrame");
         _loc1_.dataList = this.dataList;
         _loc1_.show();
      }
      
      private function getStateAble(param1:String) : Boolean
      {
         if(param1 == StateType.CHURCH_ROOM_LIST || param1 == StateType.ROOM_LIST || param1 == StateType.CONSORTIA || param1 == StateType.DUNGEON_LIST || param1 == StateType.HOT_SPRING_ROOM_LIST || param1 == StateType.FIGHT_LIB || param1 == StateType.ACADEMY_REGISTRATION || param1 == StateType.CIVIL || param1 == StateType.TOFFLIST)
         {
            return true;
         }
         return false;
      }
      
      public function useCaddy(param1:BagCell) : void
      {
         this._openCaddyCell = param1;
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__caddyModuleComplete);
         UIModuleLoader.Instance.addEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
         UIModuleLoader.Instance.addUIModuleImp(UIModuleTypes.CADDY);
      }
      
      private function __loadingClose(param1:Event) : void
      {
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__caddyModuleComplete);
         UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
      }
      
      private function __onProgress(param1:UIModuleEvent) : void
      {
         UIModuleSmallLoading.Instance.progress = param1.loader.progress * 100;
      }
      
      private function __caddyModuleComplete(param1:UIModuleEvent) : void
      {
         if(param1.module == UIModuleTypes.CADDY)
         {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__loadingClose);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_COMPLETE,this.__caddyModuleComplete);
            UIModuleLoader.Instance.removeEventListener(UIModuleEvent.UI_MODULE_PROGRESS,this.__onProgress);
            this.useCaddyImp(this._openCaddyCell);
         }
      }
      
      private function useCaddyImp(param1:BagCell) : void
      {
         var _loc2_:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.CADDY_TYPE,param1.info]);
         _loc2_.show();
         this._boxType = NO_BOX;
      }
      
      public function useBead(param1:int) : void
      {
         var _loc2_:CaddyFrame = null;
         if(param1 == EquipType.MYSTICAL_CARDBOX)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.MYSTICAL_CARDBOX]);
         }
         else if(param1 == EquipType.MY_CARDBOX)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.MY_CARDBOX]);
         }
         else if(param1 == EquipType.CARD_CARTON)
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.CARD_CARTON]);
         }
         else
         {
            _loc2_ = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.BEAD_TYPE]);
         }
         _loc2_.setBeadType(param1);
         _loc2_.show();
      }
      
      public function useOfferPack(param1:BagCell) : void
      {
         CaddyModel.instance.offerType = param1.info.TemplateID;
         var _loc2_:CaddyFrame = ComponentFactory.Instance.creatCustomObject("caddyII.CaddyFrame",[CaddyModel.OFFER_PACKET]);
         _loc2_.setOfferType(param1.info.TemplateID);
         _loc2_.show();
      }
      
      public function useCard(param1:BagCell) : void
      {
         var _loc2_:CardFrame = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame");
         _loc2_.setCardType(param1.info.TemplateID,param1.place);
         _loc2_.show();
      }
      
      public function uesCardBox(param1:BagCell) : void
      {
         var _loc2_:CardFrame = ComponentFactory.Instance.creatCustomObject("caddy.CardFrame");
         _loc2_.setCardBox(param1.info.TemplateID,param1.place);
         _loc2_.show();
      }
   }
}
