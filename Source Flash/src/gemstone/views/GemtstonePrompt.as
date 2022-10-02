package gemstone.views
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class GemtstonePrompt extends Frame
   {
       
      
      private var _btn:SimpleBitmapButton;
      
      private var _goodsContent:Bitmap;
      
      private var _goods:Bitmap;
      
      public function GemtstonePrompt()
      {
         super();
         backStyle = "SimpleFrameBackgoundOne";
         closestyle = "core.closebt";
         stylename = "caddyAwardListFrame";
         titleStyle = "FrameTitleTextStyle";
         titleOuterRectPosString = "15,10,5";
         x = 160;
         y = 40;
         closeInnerRectString = "44,19,6,30,14";
         width = 300;
         height = 200;
         addEventListener(FrameEvent.RESPONSE,this.response);
         this._goodsContent = ComponentFactory.Instance.creatBitmap("asset.toolbar.GemstoneAlert.back");
         addToContent(this._goodsContent);
         this._goods = ComponentFactory.Instance.creatBitmap("asset.toolbar.GemstoneAlert.attck");
         addToContent(this._goods);
         this._btn = ComponentFactory.Instance.creatComponentByStylename("lookBtn");
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHander);
         addToContent(this._btn);
      }
      
      protected function clickHander(param1:MouseEvent) : void
      {
         ObjectUtils.disposeObject(this);
      }
      
      private function response(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            ObjectUtils.disposeObject(this);
         }
      }
      
      override public function dispose() : void
      {
         this._btn.addEventListener(MouseEvent.CLICK,this.clickHander);
         if(this._goodsContent)
         {
            ObjectUtils.disposeObject(this._goodsContent);
         }
         this._goodsContent = null;
         if(this._goods)
         {
            ObjectUtils.disposeObject(this._goods);
         }
         this._goods = null;
         if(this._btn)
         {
            ObjectUtils.disposeObject(this._btn);
         }
         this._btn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
