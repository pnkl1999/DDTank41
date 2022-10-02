package auctionHouse.view
{
   import auctionHouse.event.AuctionSellEvent;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import bagAndInfo.cell.LinkedBagCell;
   import baglocked.BaglockedManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Rectangle;
   
   public class AuctionCellView extends LinkedBagCell
   {
      
      public static const SELECT_BID_GOOD:String = "selectBidGood";
      
      public static const SELECT_GOOD:String = "selectGood";
      
      public static const CELL_MOUSEOVER:String = "Cell_mouseOver";
      
      public static const CELL_MOUSEOUT:String = "Cell_mouseOut";
       
      
      private var _picRect:Rectangle;
      
      private var _temporaryInfo:InventoryItemInfo;
      
      private var _temporaryCount:int;
      
      private var _goodsCount:int;
      
      public function AuctionCellView()
      {
         this._goodsCount = 1;
         var _loc1_:Sprite = new Sprite();
         _loc1_.addChild(ComponentFactory.Instance.creatBitmap("asset.auctionHouse.CellBgIIAsset"));
         super(_loc1_);
         tipDirctions = "7";
         (_bg as Sprite).graphics.beginFill(0,0);
         (_bg as Sprite).graphics.drawRect(-5,-5,203,55);
         (_bg as Sprite).graphics.endFill();
         this._picRect = ComponentFactory.Instance.creatCustomObject("auctionHouse.sell.cell.PicRect");
         PicPos = this._picRect.topLeft;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         var _loc3_:AuctionSellLeftAler = null;
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action != DragEffect.SPLIT)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Object"));
            }
            else if(_loc2_.IsBinds)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.auctionHouse.view.AuctionCellView.Sale"));
            }
            else
            {
               this._goodsCount = 1;
               bagCell = param1.source as BagCell;
               this._temporaryCount = bagCell.itemInfo.Count;
               this._temporaryInfo = bagCell.itemInfo;
               if(bagCell.itemInfo.Count > 1)
               {
                  _loc3_ = ComponentFactory.Instance.creat("auctionHouse.AuctionSellLeftAler");
                  _loc3_.show(this._temporaryInfo.Count);
                  _loc3_.addEventListener(AuctionSellEvent.SELL,this._alerSell);
                  _loc3_.addEventListener(AuctionSellEvent.NOTSELL,this._alerNotSell);
               }
               DragManager.acceptDrag(bagCell,DragEffect.LINK);
            }
         }
      }
      
      private function _alerSell(param1:AuctionSellEvent) : void
      {
         var _loc2_:AuctionSellLeftAler = param1.currentTarget as AuctionSellLeftAler;
         this._goodsCount = param1.sellCount;
         this._temporaryInfo.Count = param1.sellCount;
         info = this._temporaryInfo;
         if(bagCell)
         {
            bagCell.itemInfo.Count = this._temporaryCount;
         }
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      private function _alerNotSell(param1:AuctionSellEvent) : void
      {
         var _loc2_:AuctionSellLeftAler = param1.currentTarget as AuctionSellLeftAler;
         info = null;
         bagCell.locked = false;
         bagCell = null;
         _loc2_.dispose();
         if(_loc2_ && _loc2_.parent)
         {
            removeChild(_loc2_);
         }
         _loc2_ = null;
      }
      
      public function get goodsCount() : int
      {
         return this._goodsCount;
      }
      
      override public function dragStop(param1:DragEffect) : void
      {
         super.dragStop(param1);
      }
      
      override protected function onMouseClick(param1:MouseEvent) : void
      {
         super.onMouseClick(param1);
         dispatchEvent(new Event(AuctionCellView.SELECT_BID_GOOD));
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CELL_MOUSEOVER));
      }
      
      override protected function onMouseOut(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(CELL_MOUSEOUT));
      }
      
      public function onObjectClicked() : void
      {
         super.dragStart();
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      override public function updateCount() : void
      {
         if(_tbxCount == null)
         {
            return;
         }
         if(_info && itemInfo && itemInfo.MaxCount > 1)
         {
            _tbxCount.visible = true;
            _tbxCount.text = String(itemInfo.Count);
            _tbxCount.x = this._picRect.right - _tbxCount.width;
            _tbxCount.y = this._picRect.bottom - _tbxCount.height;
            addChild(_tbxCount);
         }
         else
         {
            _tbxCount.visible = false;
         }
      }
   }
}
