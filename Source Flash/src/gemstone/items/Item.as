package gemstone.items
{
   import bagAndInfo.cell.PersonalInfoCell;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import gemstone.info.GemstListInfo;
   import gemstone.info.GemstoneInfo;
   
   public class Item extends Sprite
   {
       
      
      private var _bg:Bitmap;
      
      private var _icon:PersonalInfoCell;
      
      public var list:Vector.<GemstoneInfo>;
      
      public function Item()
      {
         super();
         this._bg = ComponentFactory.Instance.creatBitmap("gemstone.bigCil");
         addChild(this._bg);
         this._icon = new PersonalInfoCell();
         this._icon.x = 39;
         this._icon.y = 39;
         addChild(this._icon);
      }
      
      public function upDataIcon(param1:ItemTemplateInfo) : void
      {
         if(!param1)
         {
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.gemstone.curInfo.noeq"));
            return;
         }
         if(!this._icon)
         {
            this._icon = new PersonalInfoCell();
            this._icon.x = 39;
            this._icon.y = 39;
            addChild(this._icon);
         }
         this._icon.info = param1;
      }
      
      public function updataInfo(param1:Vector.<GemstListInfo>) : void
      {
         if(this._icon)
         {
            (this._icon.info as InventoryItemInfo).gemstoneList = param1;
         }
      }
      
      public function dispose() : void
      {
         while(numChildren)
         {
            ObjectUtils.disposeObject(getChildAt(0));
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
