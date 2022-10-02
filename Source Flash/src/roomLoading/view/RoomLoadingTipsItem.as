package roomLoading.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class RoomLoadingTipsItem extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _txtField:FilterFrameText;
      
      public function RoomLoadingTipsItem()
      {
         super();
         this.init();
      }
      
      public function init() : void
      {
         this._bg = ComponentFactory.Instance.creatBitmap("asset.roomLoading.TipsItemBg");
         this._txtField = ComponentFactory.Instance.creatComponentByStylename("roomLoading.TipsItemContentTxt");
         this._txtField.text = LanguageMgr.GetTranslation("ddt.roomLoading.tips" + String(int(Math.random() * 3)));
         this._txtField.x = (this._bg.width - this._txtField.textWidth) / 2 - 4;
         this._txtField.y = (this._bg.height - this._txtField.textHeight) / 2 + 7;
         addChild(this._bg);
         addChild(this._txtField);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
