package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Sprite;
   
   public class BrowserLeftStripAsset extends Sprite implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _icon:ScaleFrameImage;
      
      protected var _type_txt:GradientText;
      
      public function BrowserLeftStripAsset()
      {
         super();
         this.initView();
      }
      
      protected function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripBG");
         addChild(this._bg);
         this._icon = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripIcon");
         addChild(this._icon);
         this._type_txt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripTextFilt");
         addChild(this._type_txt);
      }
      
      public function set bg(param1:ScaleFrameImage) : void
      {
         this._bg = param1;
      }
      
      public function set icon(param1:ScaleFrameImage) : void
      {
         this._icon = param1;
      }
      
      public function set type_txt(param1:GradientText) : void
      {
         this._type_txt = param1;
      }
      
      public function get bg() : ScaleFrameImage
      {
         return this._bg;
      }
      
      public function get icon() : ScaleFrameImage
      {
         return this._icon;
      }
      
      public function get type_txt() : GradientText
      {
         return this._type_txt;
      }
      
      public function dispose() : void
      {
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
         }
         this._bg = null;
         if(this._icon)
         {
            ObjectUtils.disposeObject(this._icon);
         }
         this._icon = null;
         if(this._type_txt)
         {
            ObjectUtils.disposeObject(this._type_txt);
         }
         this._type_txt = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set type_text(param1:String) : void
      {
      }
   }
}
