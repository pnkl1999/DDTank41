package ddt.view.tips
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   
   public class WinRate extends Sprite implements Disposeable
   {
       
      
      private var _win:int;
      
      private var _total:int;
      
      private var _bg:Bitmap;
      
      private var rate_txt:FilterFrameText;
      
      public function WinRate(param1:int, param2:int)
      {
         super();
         this._win = param1;
         this._total = param2;
         this.init();
         this.setRate(this._win,this._total);
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creat("asset.core.leveltip.WinRateBg");
         this.rate_txt = ComponentFactory.Instance.creat("core.WinRateTxt");
         addChild(this._bg);
         addChild(this.rate_txt);
      }
      
      public function setRate(param1:int, param2:int) : void
      {
         this._win = param1;
         this._total = param2;
         var _loc3_:Number = this._total > 0 ? Number(Number(this._win / this._total * 100)) : Number(Number(0));
         this.rate_txt.text = _loc3_.toFixed(2) + "%";
      }
      
      public function dispose() : void
      {
         if(this.rate_txt)
         {
            ObjectUtils.disposeObject(this.rate_txt);
         }
         this.rate_txt = null;
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
