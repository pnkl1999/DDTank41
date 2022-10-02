package newTitle.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.cell.IListCell;
   import com.pickgliss.ui.controls.list.List;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class NewTitleListCell extends Sprite implements Disposeable, IListCell
   {
       
      
      private var _index:int;
      
      private var _info:*;
      
      private var _titleBg:ScaleFrameImage;
      
      private var _titleName:FilterFrameText;
      
      private var _shine:Bitmap;
      
      public function NewTitleListCell()
      {
         super();
         this.buttonMode = true;
         this.initView();
         this.initEvent();
      }
      
      private function initEvent() : void
      {
      }
      
      private function initView() : void
      {
         this._titleBg = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleNameBg");
         addChild(this._titleBg);
         this._titleName = ComponentFactory.Instance.creatComponentByStylename("newTitle.titleNameItemText");
         addChild(this._titleName);
         this._shine = ComponentFactory.Instance.creat("asset.newTitle.shine");
         addChild(this._shine);
         this._shine.visible = false;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._titleBg);
         this._titleBg = null;
         ObjectUtils.disposeObject(this._titleName);
         this._titleName = null;
         ObjectUtils.disposeObject(this._shine);
         this._shine = null;
      }
      
      private function removeEvent() : void
      {
      }
      
      public function setListCellStatus(list:List, isSelected:Boolean, index:int) : void
      {
         this._index = index;
         this._titleBg.setFrame(index % 2 + 1);
         this._shine.visible = isSelected;
      }
      
      public function getCellValue() : *
      {
         return this._info;
      }
      
      public function setCellValue(value:*) : void
      {
         this._info = value;
         this._titleName.text = String(this._info);
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
