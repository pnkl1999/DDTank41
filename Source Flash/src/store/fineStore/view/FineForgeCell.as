package store.fineStore.view
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.view.tips.GoodTipInfo;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   
   public class FineForgeCell extends BaseCell implements ISelectable
   {
       
      
      private var _select:Boolean;
      
      private var _shine:Bitmap;
      
      private var _text:FilterFrameText;
      
      private var _type:int;
      
      private var _name:String;
      
      public function FineForgeCell(param1:int, param2:String = "", param3:ItemTemplateInfo = null, param4:Boolean = true, param5:Boolean = true)
      {
         this._type = param1;
         this._name = param2;
         var _loc6_:DisplayObject = ComponentFactory.Instance.creatBitmap("store.fineforge.cellBg" + this._type);
         super(_loc6_,param3,param4,param5);
      }
      
      override public function set info(param1:ItemTemplateInfo) : void
      {
         super.info = param1;
         if(_tipData && _tipData is GoodTipInfo)
         {
            GoodTipInfo(_tipData).suitIcon = true;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._text = UICreatShortcut.creatTextAndAdd("storeFine.cell.text",this._name,this);
         this._shine = UICreatShortcut.creatAndAdd("store.fineforge.cellShine",this);
         this._shine.visible = false;
         PicPos = new Point(5,6);
      }
      
      public function set bgType(param1:int) : void
      {
         if(this._type == param1)
         {
            return;
         }
         this._type = param1;
         ObjectUtils.disposeObject(_bg);
         _bg = ComponentFactory.Instance.creatBitmap("store.fineforge.cellBg" + this._type);
         addChildAt(_bg,0);
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get cellName() : String
      {
         return this._name;
      }
      
      public function set selected(param1:Boolean) : void
      {
         if(this._select == param1)
         {
            return;
         }
         this._select = param1;
         this._shine.visible = param1;
      }
      
      public function get selected() : Boolean
      {
         return this._select;
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      override public function dispose() : void
      {
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._shine);
         this._shine = null;
         super.dispose();
      }
   }
}
