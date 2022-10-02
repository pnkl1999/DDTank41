package ddt.view.edictum
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   
   public class EdictumFrame extends BaseAlerFrame
   {
       
      
      private var _panel:ScrollPanel;
      
      private var _titleTxt:FilterFrameText;
      
      private var _contenTxt:FilterFrameText;
      
      public function EdictumFrame()
      {
         super();
         this.initView();
         this.initEvents();
      }
      
      private function initView() : void
      {
         var _loc1_:AlertInfo = new AlertInfo();
         _loc1_.submitLabel = LanguageMgr.GetTranslation("ok");
         _loc1_.showCancel = false;
         info = _loc1_;
         var _loc2_:Scale9CornerImage = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumBGI");
         var _loc3_:Bitmap = ComponentFactory.Instance.creatBitmap("asset.coreIcon.EdictumTitle");
         this._titleTxt = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumTitle");
         this._contenTxt = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumContent");
         this._panel = ComponentFactory.Instance.creatComponentByStylename("edictum.edictumPanel");
         this._panel.setView(this._contenTxt);
         this._panel.invalidateViewport();
         addToContent(_loc2_);
         addToContent(_loc3_);
         addToContent(this._titleTxt);
         addToContent(this._panel);
      }
      
      private function initEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function removeEvents() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__response);
      }
      
      private function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         ObjectUtils.disposeObject(this);
      }
      
      public function set data(param1:Object) : void
      {
         this._titleTxt.text = param1["Title"];
         this._contenTxt.htmlText = param1["Text"];
         this._panel.invalidateViewport();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         this.removeEvents();
         if(this._panel)
         {
            ObjectUtils.disposeObject(this._panel);
         }
         this._panel = null;
         if(this._titleTxt)
         {
            ObjectUtils.disposeObject(this._titleTxt);
         }
         this._titleTxt = null;
         if(this._contenTxt)
         {
            ObjectUtils.disposeObject(this._contenTxt);
         }
         this._contenTxt = null;
         super.dispose();
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
