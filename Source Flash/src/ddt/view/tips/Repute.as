package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class Repute extends Sprite implements Disposeable
   {
      
      public static const LEFT:String = "left";
      
      public static const RIGHT:String = "right";
       
      
      protected var _repute:int;
      
      protected var _level:int;
      
      protected var _reputeTxt:FilterFrameText;
      
      protected var _reputeBg:Bitmap;
      
      protected var _align:String = "right";
      
      protected var dx:int;
      
      public function Repute(param1:int = 0, param2:int = 0)
      {
         super();
         this._repute = param1;
         this._level = param2;
         this._reputeBg = ComponentFactory.Instance.creat("asset.core.leveltip.ReputeBg");
         this._reputeTxt = ComponentFactory.Instance.creat("core.ReputeTxt");
         this.dx = this._reputeTxt.x;
         addChild(this._reputeBg);
         addChild(this._reputeTxt);
         this.setRepute(this._repute);
      }
      
      public function set level(param1:int) : void
      {
         this._level = param1;
      }
      
      public function setRepute(param1:int) : void
      {
         this._repute = param1;
         this._reputeTxt.text = this._level <= 3 || param1 > 9999999 || param1 == 0 ? LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.new") : String(param1);
         this._reputeTxt.width = this._reputeTxt.textWidth + 3;
         if(this._align == LEFT)
         {
            this._reputeBg.x = 0;
            this._reputeTxt.x = this._reputeBg.x + this.dx;
         }
         else
         {
            this._reputeTxt.x = -this._reputeTxt.textWidth;
            this._reputeBg.x = this._reputeTxt.x - this.dx;
         }
      }
      
      public function set align(param1:String) : void
      {
         this._align = param1;
         if(param1 == LEFT)
         {
            this._reputeBg.x = 0;
            this._reputeTxt.x = this._reputeBg.x + this.dx;
         }
         else
         {
            this._reputeTxt.x = -this._reputeTxt.textWidth;
            this._reputeBg.x = this._reputeTxt.x - this.dx;
         }
      }
      
      public function dispose() : void
      {
         if(this._reputeTxt)
         {
            ObjectUtils.disposeObject(this._reputeTxt);
         }
         this._reputeTxt = null;
         if(this._reputeBg)
         {
            ObjectUtils.disposeObject(this._reputeBg);
         }
         this._reputeBg = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
