package ddt.view.caddyII
{
   import bagAndInfo.bag.SellGoodsBtn;
   import bagAndInfo.cell.BagCell;
   import bagAndInfo.cell.DragEffect;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.events.CellEvent;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   
   public class CaddyCell extends BagCell
   {
       
      
      private var _isSellGoods:Boolean;
      
      public function CaddyCell(param1:int, param2:ItemTemplateInfo = null, param3:Boolean = true, param4:Sprite = null)
      {
         super(param1,param2,param3,param4);
         tipDirctions = "7,5,2,6,4,1";
         addEventListener(MouseEvent.CLICK,this.__click);
      }
      
      override public function dragDrop(param1:DragEffect) : void
      {
         if(param1.data is SellGoodsBtn)
         {
            this._isSellGoods = true;
         }
         else
         {
            this._isSellGoods = false;
         }
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         if(param1 != null)
         {
            buttonMode = true;
         }
         else
         {
            buttonMode = false;
         }
      }
      
      private function __click(param1:MouseEvent) : void
      {
         if(info && !this._isSellGoods)
         {
            dispatchEvent(new CellEvent(CellEvent.ITEM_CLICK,this));
         }
         this._isSellGoods = false;
      }
   }
}
