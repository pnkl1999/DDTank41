package ddt.view.caddyII.badLuck
{
   import bagAndInfo.cell.BaseCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class ReceiveBadLuckItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _RsortTxt:FilterFrameText;
      
      private var _RnameTxt:FilterFrameText;
      
      private var _RgoosTxt:FilterFrameText;
      
      private var _topThteeBit:ScaleFrameImage;
      
      private var _cell:BaseCell;
      
      public function ReceiveBadLuckItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RbadLuckItemBG");
         this._RsortTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RsortTxt");
         this._RnameTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RNameTxt");
         this._RgoosTxt = ComponentFactory.Instance.creatComponentByStylename("caddy.badLuck.RgoodsTxt");
         this._topThteeBit = ComponentFactory.Instance.creatComponentByStylename("caddy.RBadTopThreeRink");
         var _loc1_:Shape = new Shape();
         _loc1_.graphics.beginFill(16777215,0);
         _loc1_.graphics.drawRect(0,0,28,28);
         _loc1_.graphics.endFill();
         this._cell = ComponentFactory.Instance.creatCustomObject("badLuck.itemCell",[_loc1_]);
         addChild(this._bg);
         addChild(this._RsortTxt);
         addChild(this._RnameTxt);
         addChild(this._RgoosTxt);
         addChild(this._topThteeBit);
         addChild(this._cell);
      }
      
      public function update(param1:int, param2:String, param3:InventoryItemInfo) : void
      {
         this._bg.setFrame(param1 % 2 + 1);
         this._RsortTxt.text = param1 + 1 + "th";
         this._topThteeBit.setFrame(param1 < 3 ? int(int(param1 + 1)) : int(int(1)));
         this._topThteeBit.visible = param1 < 3;
         this._RsortTxt.visible = param1 >= 3;
         this._RnameTxt.text = param2;
         this._RgoosTxt.text = param3.Name;
         this._cell.info = param3;
      }
      
      override public function get height() : Number
      {
         return 34;
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._RsortTxt)
         {
            ObjectUtils.disposeObject(this._RsortTxt);
         }
         this._RsortTxt = null;
         if(this._RnameTxt)
         {
            ObjectUtils.disposeObject(this._RnameTxt);
         }
         this._RnameTxt = null;
         if(this._RgoosTxt)
         {
            ObjectUtils.disposeObject(this._RgoosTxt);
         }
         this._RgoosTxt = null;
         if(this._topThteeBit)
         {
            ObjectUtils.disposeObject(this._topThteeBit);
         }
         this._topThteeBit = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
