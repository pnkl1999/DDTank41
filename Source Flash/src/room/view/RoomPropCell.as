package room.view
{
   import baglocked.BagLockedController;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import ddt.command.QuickBuyFrame;
   import ddt.data.BagInfo;
   import ddt.data.EquipType;
   import ddt.data.PropInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.view.PropItemView;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class RoomPropCell extends Sprite implements Disposeable
   {
       
      
      private var _info:PropInfo;
      
      private var _container:PropItemView;
      
      private var _isself:Boolean;
      
      private var _place:int;
      
      private var _bagLockControl:BagLockedController;
      
      public function RoomPropCell(param1:Boolean, param2:int)
      {
         this._isself = param1;
         this._place = param2;
         super();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__mouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__mouseClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__mouseOut);
      }
      
      public function set info(param1:PropInfo) : void
      {
         if(this._info != null && param1 != null)
         {
            if(this._info.Template == param1.Template)
            {
               return;
            }
         }
         this._info = param1;
         if(this._container != null)
         {
            if(this._container.parent)
            {
               this._container.parent.removeChild(this._container);
            }
         }
         buttonMode = false;
         if(this._info == null)
         {
            return;
         }
         buttonMode = true;
         this._container = new PropItemView(this._info,true,false);
         addChild(this._container);
      }
      
      public function get info() : PropInfo
      {
         return this._info;
      }
      
      private function __mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._isself)
         {
            SocketManager.Instance.out.sendSellProp(this._place,ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).GoodsID);
         }
         else
         {
            if(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).items.length >= RoomRightPropView.UPCELLS_NUMBER)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("room.roomRightPropView.bagFull"));
               return;
            }
            if(PlayerManager.Instance.Self.Gold < ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).getItemPrice(1).goldValue)
            {
               _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.GoldInadequate"),"",LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc2_.moveEnable = false;
               _loc2_.addEventListener(FrameEvent.RESPONSE,this.__onResponse);
               return;
            }
            SocketManager.Instance.out.sendBuyProp(ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).GoodsID);
            this.clientChange(this._info.Template.TemplateID);
         }
      }
      
      private function clientChange(param1:int) : void
      {
         if(PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).itemNumber < 3)
         {
            PlayerManager.Instance.Self.getBag(BagInfo.FIGHTBAG).addItemIntoFightBag(param1,1);
            PlayerManager.Instance.Self.Gold -= ShopManager.Instance.getGoldShopItemByTemplateID(this._info.Template.TemplateID).getItemPrice(1).goldValue;
         }
      }
      
      private function __onResponse(param1:FrameEvent) : void
      {
         var _loc3_:QuickBuyFrame = null;
         var _loc2_:BaseAlerFrame = BaseAlerFrame(param1.target);
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__onResponse);
         _loc2_.dispose();
         if(param1.responseCode == FrameEvent.SUBMIT_CLICK || param1.responseCode == FrameEvent.ENTER_CLICK)
         {
            _loc3_ = ComponentFactory.Instance.creatCustomObject("core.QuickFrame");
            _loc3_.setTitleText(LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy"));
            _loc3_.itemID = EquipType.GOLD_BOX;
            LayerManager.Instance.addToLayer(_loc3_,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         }
      }
      
      private function __mouseOver(param1:MouseEvent) : void
      {
      }
      
      private function __mouseOut(param1:MouseEvent) : void
      {
      }
      
      override public function get width() : Number
      {
         return 40;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._container)
         {
            this._container.dispose();
         }
         this._container = null;
         this._info = null;
         this._bagLockControl = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
