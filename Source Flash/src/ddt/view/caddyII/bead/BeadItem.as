package ddt.view.caddyII.bead
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class BeadItem extends Sprite implements ISelectable, Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _numberTxt:FilterFrameText;
      
      private var _beadCell:BaseCell;
      
      private var _count:int;
      
      private var _isSelected:Boolean = false;
      
      public function BeadItem()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("bead.beatItemBG");
         this._numberTxt = ComponentFactory.Instance.creatComponentByStylename("bead.numberTxt");
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("bead.cellSize");
         var _loc2_:Shape = new Shape();
         _loc2_.graphics.beginFill(16777215,0);
         _loc2_.graphics.drawRect(0,0,_loc1_.x,_loc1_.y);
         _loc2_.graphics.endFill();
         this._beadCell = ComponentFactory.Instance.creatCustomObject("bead.selectCell",[_loc2_]);
         addChild(this._bg);
         addChild(this._numberTxt);
         addChild(this._beadCell);
         this._bg.setFrame(1);
      }
      
      private function initEvents() : void
      {
         addEventListener(MouseEvent.MOUSE_OVER,this._over);
         addEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function removeEvents() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this._over);
         removeEventListener(MouseEvent.MOUSE_OUT,this._out);
      }
      
      private function _over(param1:MouseEvent) : void
      {
         this._bg.setFrame(2);
      }
      
      private function _out(param1:MouseEvent) : void
      {
         if(!this._isSelected)
         {
            this._bg.setFrame(1);
         }
      }
      
      public function set info(param1:ItemTemplateInfo) : void
      {
         this._beadCell.info = param1;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._bg.setFrame(!!param1 ? int(int(2)) : int(int(1)));
         this._isSelected = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._isSelected;
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function set count(param1:int) : void
      {
         this._count = param1;
         this._numberTxt.text = String(this._count);
      }
      
      public function get count() : int
      {
         return this._count;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._numberTxt)
         {
            ObjectUtils.disposeObject(this._numberTxt);
         }
         this._numberTxt = null;
         if(this._beadCell)
         {
            ObjectUtils.disposeObject(this._beadCell);
         }
         this._beadCell = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
