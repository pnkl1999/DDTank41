package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.command.NumberSelecter;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class QuickBuyItem extends Sprite implements Disposeable
   {
      
      private static const HammerJumpStep:int = 5;
      
      private static const PotJumpStep:int = 1;
      
      private static const HammerTemplateID:int = 11456;
      
      private static const PotTemplateID:int = 112047;
       
      
      private var _bg:Bitmap;
      
      private var _cell:BaseCell;
      
      private var _selectNumber:NumberSelecter;
      
      private var _count:int;
      
      private var _countField:FilterFrameText;
      
      private var _countPos:Point;
      
      private var _selsected:Boolean = false;
      
      private var _selectedBitmap:Bitmap;
      
      public function QuickBuyItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._countPos = ComponentFactory.Instance.creatCustomObject("caddyII.bead.QuickBuyItem.CountPos");
         this._bg = ComponentFactory.Instance.creatBitmap("asset.bead.quickCellBG");
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("bead.quickCellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         _loc2_.graphics.endFill();
         this._cell = ComponentFactory.Instance.creatCustomObject("bead.quickCell",[_loc2_]);
         this._selectNumber = ComponentFactory.Instance.creatCustomObject("bead.numberSelecter",[0]);
         this._selectNumber.number = 0;
         this._countField = ComponentFactory.Instance.creatComponentByStylename("caddy.QuickBuy.ItemCountField");
         this._selectedBitmap = ComponentFactory.Instance.creatBitmap("asset.caddy.QuickBuy.Selected");
         addChild(this._selectedBitmap);
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._selectNumber);
         addChild(this._countField);
      }
      
      private function initEvents() : void
      {
         this._selectNumber.addEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.addEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function removeEvents() : void
      {
         this._selectNumber.removeEventListener(Event.CHANGE,this._numberChange);
         this._selectNumber.removeEventListener(NumberSelecter.NUMBER_CLOSE,this._numberClose);
      }
      
      private function _numberChange(param1:Event) : void
      {
         if(this._cell.info.TemplateID == HammerTemplateID)
         {
            this._countField.text = String(HammerJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
         else if(this._cell.info.TemplateID == PotTemplateID)
         {
            this._countField.text = String(PotJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function _numberClose(param1:Event) : void
      {
         dispatchEvent(new Event(NumberSelecter.NUMBER_CLOSE));
      }
      
      public function setFocus() : void
      {
         this._selectNumber.setFocus();
      }
      
      public function set itemID(param1:int) : void
      {
         this._cell.info = ItemManager.Instance.getTemplateById(param1);
         if(this._cell.info.TemplateID == HammerTemplateID)
         {
            this._countField.text = String(HammerJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
         else if(this._cell.info.TemplateID == PotTemplateID)
         {
            this._countField.text = String(PotJumpStep * this._selectNumber.number);
            this._countField.x = this._countPos.x - this._countField.width;
            this._countField.y = this._countPos.y - this._countField.height;
         }
      }
      
      public function get info() : ItemTemplateInfo
      {
         return this._cell.info;
      }
      
      public function set count(param1:int) : void
      {
         this._selectNumber.number = param1;
      }
      
      public function get count() : int
      {
         return this._selectNumber.number;
      }
      
      public function get selected() : Boolean
      {
         return this._selsected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._selsected != param1)
         {
            this._selsected = param1;
            this._selectedBitmap.visible = this._selsected;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(this._selectNumber)
         {
            ObjectUtils.disposeObject(this._selectNumber);
         }
         this._selectNumber = null;
         if(this._selectedBitmap)
         {
            ObjectUtils.disposeObject(this._selectedBitmap);
         }
         this._selectedBitmap = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
