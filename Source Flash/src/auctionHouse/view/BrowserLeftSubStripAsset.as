package auctionHouse.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   
   public class BrowserLeftSubStripAsset extends BrowserLeftStripAsset
   {
       
      
      private var _type_text:FilterFrameText;
      
      public function BrowserLeftSubStripAsset()
      {
         super();
      }
      
      override protected function initView() : void
      {
         bg = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftSubStripBG");
         addChild(bg);
         this._type_text = ComponentFactory.Instance.creat("auctionHouse.BrowseLeftSubStripText");
         _type_txt = ComponentFactory.Instance.creatComponentByStylename("auctionHouse.BrowseLeftStripTextFilt");
         addChild(this._type_text);
         icon = null;
      }
      
      override public function set type_txt(param1:GradientText) : void
      {
         _type_txt = param1;
         this._type_text.text = _type_txt.text;
      }
      
      override public function get type_txt() : GradientText
      {
         return _type_txt;
      }
      
      override public function set type_text(param1:String) : void
      {
         this._type_text.text = param1;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         if(this._type_text)
         {
            ObjectUtils.disposeObject(this._type_text);
         }
         this._type_text = null;
      }
   }
}
