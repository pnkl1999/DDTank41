package calendar.view.goodsExchange
{
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.DragManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import email.view.EmaillBagCell;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class GoodsExchangeCell extends EmaillBagCell
   {
       
      
      private var _cellBG:Bitmap;
      
      private var _cellSize:Point;
      
      private var _goodsExchangeInfo:GoodsExchangeInfo;
      
      public function GoodsExchangeCell()
      {
         super();
      }
      
      override protected function init() : void
      {
         this._cellBG = UICreatShortcut.creatAndAdd("Calendar.Activity.CellBg",this);
         this._cellSize = ComponentFactory.Instance.creatCustomObject("CalendarGrid.GoodsExchangeView.cellSize");
         super.init();
      }
      
      public function set goodsExchangeInfo(param1:GoodsExchangeInfo) : void
      {
         this._goodsExchangeInfo = param1;
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(PlayerManager.Instance.Self.bagLocked)
         {
            return;
         }
         var _loc2_:InventoryItemInfo = param1.data as InventoryItemInfo;
         if(_loc2_ && param1.action == DragEffect.MOVE)
         {
            param1.action = DragEffect.NONE;
            if(_loc2_.getRemainDate() <= 0)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.view.emailII.EmaillIIBagCell.RemainDate"));
            }
            else if(this.allowDragDrop(_loc2_))
            {
               bagCell = param1.source as BagCell;
               param1.action = DragEffect.LINK;
            }
            DragManager.acceptDrag(this);
         }
      }
      
      private function allowDragDrop(param1:InventoryItemInfo) : Boolean
      {
         if(param1.CategoryID != this._goodsExchangeInfo.goodsExchangeType)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.goodsExchange.warning"));
            return false;
         }
         if(this._goodsExchangeInfo.limitType == 0 && param1.StrengthenLevel < this._goodsExchangeInfo.limitValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.goodsExchange.warningI"));
            return false;
         }
         if(this._goodsExchangeInfo.limitType == 1 && int(param1.Property1) < this._goodsExchangeInfo.limitValue)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("calendar.view.goodsExchange.warningII"));
            return false;
         }
         return true;
      }
      
      override protected function updateSize(param1:Sprite) : void
      {
         if(param1)
         {
            _pic.width = this._cellSize.x;
            _pic.height = this._cellSize.y;
            _tbxCount.x = _pic.width - _tbxCount.width - 2;
            _tbxCount.y = _pic.height - _tbxCount.height - 2;
         }
      }
      
      override protected function onMouseOver(param1:MouseEvent) : void
      {
         buttonMode = true;
      }
   }
}
