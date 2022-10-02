package shop.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ISelectable;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import ddt.manager.LanguageMgr;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ShopBugleViewItem extends Sprite implements ISelectable, Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _cell:ShopItemCell;
      
      private var _count:String;
      
      private var _money:int;
      
      private var _countTxt:FilterFrameText;
      
      private var _moneyTxt:FilterFrameText;
      
      private var _type:int;
      
      public function ShopBugleViewItem(param1:int = 0, param2:String = "", param3:int = 0, param4:ShopItemCell = null)
      {
         super();
         buttonMode = true;
         this._type = param1;
         this._count = param2;
         this._money = param3;
         this._cell = param4;
         this._bg = ComponentFactory.Instance.creatComponentByStylename("shop.BugleViewBg");
         this._countTxt = ComponentFactory.Instance.creatComponentByStylename("shop.BugleViewCountText");
         this._moneyTxt = ComponentFactory.Instance.creatComponentByStylename("shop.BugleViewMoneyText");
         this._moneyTxt.mouseEnabled = false;
         this._countTxt.mouseEnabled = false;
         this._countTxt.text = this._count;
         this._moneyTxt.text = String(this._money) + LanguageMgr.GetTranslation("money");
         this._bg.setFrame(1);
         addChild(this._bg);
         addChild(this._cell);
         addChild(this._countTxt);
         addChild(this._moneyTxt);
      }
      
      public function set autoSelect(param1:Boolean) : void
      {
      }
      
      public function get selected() : Boolean
      {
         return this._bg.getFrame == 2;
      }
      
      public function set selected(param1:Boolean) : void
      {
         this._bg.setFrame(!!param1 ? int(int(2)) : int(int(1)));
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this as DisplayObject;
      }
      
      public function get type() : int
      {
         return this._type;
      }
      
      public function get count() : String
      {
         return this._count;
      }
      
      public function get money() : int
      {
         return this._money;
      }
      
      public function dispose() : void
      {
         this._bg.dispose();
         this._bg = null;
         this._cell.dispose();
         this._cell = null;
         this._countTxt.dispose();
         this._countTxt = null;
         this._moneyTxt.dispose();
         this._moneyTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
