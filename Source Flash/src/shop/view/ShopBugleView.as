package shop.view
{
   import bagAndInfo.cell.CellFactory;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.EquipType;
   import ddt.data.goods.ShopItemInfo;
   import ddt.manager.ChatManager;
   import ddt.manager.KeyboardShortcutsManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.ShopManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class ShopBugleView extends Sprite implements Disposeable
   {
      
      private static const BUGLE:uint = 3;
      
      private static const GOLD:uint = 0;
      
      private static const TEXP:uint = 6;
      
      public static const DONT_BUY_ANYTHING:String = "dontBuyAnything";
       
      
      private var _frame:BaseAlerFrame;
      
      private var _info:ShopItemInfo;
      
      private var _itemContainer:HBox;
      
      private var _itemGroup:SelectedButtonGroup;
      
      private var _type:int;
      
      private var _buyFrom:int;
      
      public function ShopBugleView(param1:int)
      {
         super();
         this._type = param1;
         this.init();
         ChatManager.Instance.focusFuncEnabled = false;
         if(this._info)
         {
            LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:ShopBugleViewItem = null;
         StageReferance.stage.removeEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDownd);
         if(this._type == EquipType.TEXP_LV_II)
         {
            KeyboardShortcutsManager.Instance.prohibitNewHandBag(true);
         }
         while(this._itemContainer.numChildren > 0)
         {
            _loc1_ = this._itemContainer.getChildAt(0) as ShopBugleViewItem;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__click);
            _loc1_.dispose();
            _loc1_ = null;
         }
         this._frame.dispose();
         this.clearAllItem();
         this._frame = null;
         this._itemContainer.dispose();
         this._itemContainer = null;
         this._info = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         ChatManager.Instance.focusFuncEnabled = true;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get info() : ShopItemInfo
      {
         return this._info;
      }
      
      protected function __onKeyDownd(param1:KeyboardEvent) : void
      {
         var _loc2_:int = this._itemGroup.selectIndex;
         var _loc3_:int = this._itemContainer.numChildren;
         if(param1.keyCode == Keyboard.LEFT)
         {
            _loc2_ = _loc2_ == 0 ? int(int(0)) : int(int(--_loc2_));
         }
         else if(param1.keyCode == Keyboard.RIGHT)
         {
            _loc2_ = _loc2_ == _loc3_ - 1 ? int(int(_loc3_ - 1)) : int(int(++_loc2_));
         }
         if(this._itemGroup.selectIndex != _loc2_)
         {
            SoundManager.instance.play("008");
            this._itemGroup.selectIndex = _loc2_;
         }
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         var _loc2_:ShopBugleViewItem = null;
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(PlayerManager.Instance.Self.bagLocked)
               {
                  BaglockedManager.Instance.show();
                  return;
               }
               _loc2_ = this._itemContainer.getChildAt(this._itemGroup.selectIndex) as ShopBugleViewItem;
               if(PlayerManager.Instance.Self.Money < _loc2_.money)
               {
                  LeavePageManager.showFillFrame();
                  return;
               }
               SocketManager.Instance.out.sendBuyGoods([this._info.GoodsID],[_loc2_.type],[""],[0],[Boolean(0)],[""],this._buyFrom);
               this.dispose();
               break;
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               dispatchEvent(new Event("DONT_BUY_ANYTHING"));
               this.dispose();
         }
      }
      
      private function addItem(param1:ShopItemInfo, param2:int) : void
      {
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.beginFill(16777215,0);
         _loc3_.graphics.drawRect(0,0,70,70);
         _loc3_.graphics.endFill();
         var _loc4_:ShopItemCell = CellFactory.instance.createShopItemCell(_loc3_,param1.TemplateInfo) as ShopItemCell;
         PositionUtils.setPos(_loc4_,"shop.BugleViewItemCellPos");
         var _loc5_:ShopBugleViewItem = new ShopBugleViewItem(param2,param1.getTimeToString(param2),param1.getItemPrice(param2).moneyValue,_loc4_);
         _loc5_.addEventListener(MouseEvent.CLICK,this.__click);
         this._itemContainer.addChild(_loc5_);
         this._itemGroup.addSelectItem(_loc5_);
      }
      
      private function __click(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._itemGroup.selectIndex = this._itemContainer.getChildIndex(param1.currentTarget as ShopBugleViewItem);
      }
      
      private function addItems() : void
      {
         var _loc1_:int = 0;
         if(this._type == EquipType.T_BBUGLE)
         {
            _loc1_ = EquipType.T_BBUGLE;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.bigbugletitle");
            this._buyFrom = BUGLE;
         }
         else if(this._type == EquipType.T_SBUGLE)
         {
            _loc1_ = EquipType.T_SBUGLE;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.smallbugletitle");
            this._buyFrom = BUGLE;
         }
         else if(this._type == EquipType.T_CBUGLE)
         {
            _loc1_ = EquipType.T_CBUGLE;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.crossbugletitle");
            this._buyFrom = BUGLE;
         }
         else if(this._type == EquipType.CADDY_KEY)
         {
            _loc1_ = EquipType.CADDY_KEY;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.view.store.matte.goldQuickBuy");
            this._buyFrom = GOLD;
         }
         else if(this._type == EquipType.TEXP_LV_II)
         {
            _loc1_ = EquipType.TEXP_LV_II;
            this._frame.titleText = LanguageMgr.GetTranslation("tank.dialog.showbugleframe.texpQuickBuy");
            this._buyFrom = TEXP;
         }
         this._info = ShopManager.Instance.getMoneyShopItemByTemplateID(_loc1_);
         if(this._info)
         {
            if(this._info.getItemPrice(1).IsValid)
            {
               this.addItem(this._info,1);
            }
            if(this._info.getItemPrice(2).IsValid)
            {
               this.addItem(this._info,2);
            }
            if(this._info.getItemPrice(3).IsValid)
            {
               this.addItem(this._info,3);
            }
         }
      }
      
      private function clearAllItem() : void
      {
         var _loc1_:ShopBugleViewItem = null;
         while(this._itemContainer.numChildren > 0)
         {
            _loc1_ = this._itemContainer.getChildAt(0) as ShopBugleViewItem;
            _loc1_.removeEventListener(MouseEvent.CLICK,this.__click);
            _loc1_.dispose();
            _loc1_ = null;
         }
      }
      
      private function init() : void
      {
         this._itemGroup = new SelectedButtonGroup();
         this._frame = ComponentFactory.Instance.creatComponentByStylename("shop.BugleFrame");
         this._itemContainer = ComponentFactory.Instance.creatComponentByStylename("shop.BugleViewItemContainer");
         var _loc1_:AlertInfo = new AlertInfo("",LanguageMgr.GetTranslation("tank.dialog.showbugleframe.ok"));
         this._frame.info = _loc1_;
         this._frame.addToContent(this._itemContainer);
         this._frame.addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         addChild(this._frame);
         this.updateView();
         if(this._info)
         {
            this._itemGroup.selectIndex = 0;
         }
         StageReferance.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.__onKeyDownd);
      }
      
      private function updateView() : void
      {
         this.clearAllItem();
         this.addItems();
      }
   }
}
