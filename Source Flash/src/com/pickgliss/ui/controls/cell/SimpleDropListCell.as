package com.pickgliss.ui.controls.cell
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   
   public class SimpleDropListCell extends Component implements IDropListCell
   {
       
      
      protected var _data:String;
      
      protected var _textField:FilterFrameText;
      
      private var _selected:Boolean;
      
      protected var _bg:ScaleFrameImage;
      
      public function SimpleDropListCell()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         this._bg = ComponentFactory.Instance.creatComponentByStylename("droplist.CellBg");
         this._textField = ComponentFactory.Instance.creatComponentByStylename("droplist.CellText");
         this._bg.setFrame(1);
         width = this._bg.width;
         height = this._bg.height;
      }
      
      override protected function addChildren() : void
      {
         super.addChildren();
         if(this._bg)
         {
            addChild(this._bg);
         }
         if(this._textField)
         {
            addChild(this._textField);
         }
      }
      
      public function get selected() : Boolean
      {
         return this._selected;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._selected = param1;
         if(this._selected)
         {
            this._bg.setFrame(2);
         }
         else
         {
            this._bg.setFrame(1);
         }
      }
      
      public function getCellValue() : *
      {
         if(this._data)
         {
            return this._data;
         }
         return "";
      }
      
      public function setCellValue(param1:*) : void
      {
         if(param1)
         {
            this._data = String(param1);
            this._textField.text = this._data;
         }
      }
   }
}
