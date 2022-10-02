package room.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.controls.container.SimpleTileList;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.StripTip;
   import ddt.data.BagInfo;
   import ddt.data.PropInfo;
   import ddt.data.ShopType;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ShopItemInfo;
   import ddt.data.player.PlayerInfo;
   import ddt.events.BagEvent;
   import ddt.events.PlayerPropertyEvent;
   import ddt.events.RoomEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerManager;
   import ddt.manager.ShopManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import room.RoomManager;
   import trainer.data.Step;
   
   public class RoomRightPropView extends Sprite implements Disposeable
   {
      
      public static const UPCELLS_NUMBER:int = 3;
       
      
      private var _bg:Bitmap;
      
      private var _upCells:Array;
      
      private var _upCellsContainer:HBox;
      
      private var _downCellsContainer:SimpleTileList;
      
      private var _roomIDTxt:FilterFrameText;
      
      private var _chanelNameTxt:FilterFrameText;
      
      private var _goldInfoTxt:FilterFrameText;
      
      private var _roomNameTxt:FilterFrameText;
      
      private var _upCellsStripTip:StripTip;
      
      private var _downCellsStripTip:StripTip;
      
      public function RoomRightPropView()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc4_:InventoryItemInfo = null;
         var _loc5_:RoomPropCell = null;
         var _loc6_:PropInfo = null;
         var _loc7_:RoomPropCell = null;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.room.view.RoomRightPropViewBGAsset");
         addChild(this._bg);
         this._upCellsContainer = ComponentFactory.Instance.creatCustomObject("room.upCellsContainer");
         addChild(this._upCellsContainer);
         this._downCellsContainer = ComponentFactory.Instance.creatCustomObject("room.downCellsContainer",[4]);
         addChild(this._downCellsContainer);
         this._upCells = [];
         var _loc1_:int = 0;
         while(_loc1_ < UPCELLS_NUMBER)
         {
            _loc5_ = new RoomPropCell(true,_loc1_);
            this._upCellsContainer.addChild(_loc5_);
            this._upCells.push(_loc5_);
            _loc1_++;
         }
         var _loc2_:Vector.<ShopItemInfo> = ShopManager.Instance.getGoodsByType(ShopType.ROOM_PROP);
         var _loc3_:int = 0;
         while(_loc3_ < this.getPropNum())
         {
            _loc6_ = new PropInfo(_loc2_[_loc3_].TemplateInfo);
            _loc7_ = new RoomPropCell(false,_loc1_);
            this._downCellsContainer.addChild(_loc7_);
            _loc7_.info = _loc6_;
            _loc3_++;
         }
         this._roomIDTxt = ComponentFactory.Instance.creatComponentByStylename("roomIDText");
         addChild(this._roomIDTxt);
         this._chanelNameTxt = ComponentFactory.Instance.creatComponentByStylename("roomChanelNameText");
         addChild(this._chanelNameTxt);
         this._roomNameTxt = ComponentFactory.Instance.creatComponentByStylename("roomNameText");
         addChild(this._roomNameTxt);
         for each(_loc4_ in PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items)
         {
            this._upCells[_loc4_.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_loc4_.Place]);
         }
         this._roomIDTxt.text = RoomManager.Instance.current.ID.toString();
         this._chanelNameTxt.text = ServerManager.Instance.current.Name;
         this._roomNameTxt.text = RoomManager.Instance.current.Name;
         this.creatTipShapeTip();
      }
      
      private function getPropNum() : int
      {
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.FROZE_PROP_OPEN))
         {
            return 8;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HIDE_PROP_OPEN))
         {
            return 7;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.POWER_PROP_OPEN))
         {
            return 4;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.GUILD_PROP_OPEN))
         {
            return 3;
         }
         if(PlayerManager.Instance.Self.IsWeakGuildFinish(Step.HP_PROP_OPEN))
         {
            return 2;
         }
         return 0;
      }
      
      private function initEvents() : void
      {
         PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addEventListener(BagEvent.UPDATE,this.__updateBag);
         RoomManager.Instance.current.addEventListener(RoomEvent.ROOM_NAME_CHANGED,this._roomNameChanged);
      }
      
      private function removeEvents() : void
      {
         PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__updateGold);
         PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).removeEventListener(BagEvent.UPDATE,this.__updateBag);
         RoomManager.Instance.current.removeEventListener(RoomEvent.ROOM_NAME_CHANGED,this._roomNameChanged);
      }
      
      private function _roomNameChanged(param1:RoomEvent) : void
      {
         this._roomNameTxt.text = RoomManager.Instance.current.Name;
      }
      
      private function creatTipShapeTip() : void
      {
         this._upCellsStripTip = ComponentFactory.Instance.creatCustomObject("room.upRightPropTip");
         this._downCellsStripTip = ComponentFactory.Instance.creatCustomObject("room.downRightPropTip");
         this._upCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.uppropTip");
         this._downCellsStripTip.tipData = LanguageMgr.GetTranslation("room.roomRightPropView.downpropTip");
         addChild(this._upCellsStripTip);
         addChild(this._downCellsStripTip);
      }
      
      private function __updateGold(param1:PlayerPropertyEvent) : void
      {
         if(param1.changedProperties[PlayerInfo.GOLD])
         {
         }
      }
      
      private function __updateBag(param1:BagEvent) : void
      {
         var _loc2_:InventoryItemInfo = null;
         for each(_loc2_ in param1.changedSlots)
         {
            if(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_loc2_.Place] == null)
            {
               this._upCells[_loc2_.Place].info = null;
               break;
            }
            this._upCells[_loc2_.Place].info = new PropInfo(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items[_loc2_.Place]);
         }
      }
      
      private function _cellClick(param1:MouseEvent) : void
      {
         var _loc3_:RoomPropCell = null;
         var _loc2_:int = 0;
         for each(_loc3_ in this._upCells)
         {
            if(_loc3_.info != null)
            {
               _loc2_++;
            }
         }
         if(_loc2_ > UPCELLS_NUMBER)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.roomRightPropView.bagFull"));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         removeChild(this._bg);
         this._bg.bitmapData.dispose();
         this._bg = null;
         this._upCells = null;
         this._upCellsContainer.dispose();
         this._upCellsContainer = null;
         this._downCellsContainer.dispose();
         this._downCellsContainer = null;
         this._roomIDTxt.dispose();
         this._roomIDTxt = null;
         this._chanelNameTxt.dispose();
         this._chanelNameTxt = null;
         this._roomNameTxt.dispose();
         this._roomNameTxt = null;
         if(this._upCellsStripTip)
         {
            ObjectUtils.disposeObject(this._upCellsStripTip);
         }
         this._upCellsStripTip = null;
         if(this._downCellsStripTip)
         {
            ObjectUtils.disposeObject(this._downCellsStripTip);
         }
         this._downCellsStripTip = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
