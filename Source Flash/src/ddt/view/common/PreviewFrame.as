package ddt.view.common
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   
   public class PreviewFrame extends BaseAlerFrame implements Disposeable
   {
       
      
      private var _previewBitmap:DisplayObject;
      
      private var _scroll:ScrollPanel;
      
      private var _titleTxt:String;
      
      private var _previewBitmapStyle:String;
      
      private var _scrollStyle:String;
      
      private var _submitFunction:Function;
      
      private var _submitEnable:Boolean;
      
      private var _previewBmp:Bitmap;
      
      public function PreviewFrame()
      {
         super();
      }
      
      public function setStyle(param1:String, param2:String, param3:String, param4:Function = null, param5:Boolean = true, param6:Bitmap = null) : void
      {
         this._titleTxt = param1;
         this._previewBitmapStyle = param2;
         this._scrollStyle = param3;
         this._submitFunction = param4;
         this._submitEnable = param5;
         this._previewBmp = param6;
         this.initContent();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      public function initContent() : void
      {
         if(this._previewBitmapStyle != "")
         {
            this._previewBitmap = ComponentFactory.Instance.creat(this._previewBitmapStyle);
         }
         else
         {
            this._previewBitmap = this._previewBmp;
         }
         this._scroll = ComponentFactory.Instance.creatComponentByStylename(this._scrollStyle);
         var _loc1_:AlertInfo = new AlertInfo(this._titleTxt,LanguageMgr.GetTranslation("ok"));
         _loc1_.autoDispose = false;
         _loc1_.moveEnable = false;
         _loc1_.showCancel = false;
         _loc1_.bottomGap = 8;
         info = _loc1_;
         this.submitButtonEnable = this._submitEnable;
         this._scroll.setView(this._previewBitmap);
         addToContent(this._scroll);
         addEventListener(FrameEvent.RESPONSE,this.__frameEvent);
      }
      
      private function __frameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               if(this._submitFunction != null && this._submitEnable)
               {
                  this._submitFunction();
               }
               this.dispose();
               break;
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.CANCEL_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         removeEventListener(FrameEvent.RESPONSE,this.__frameEvent);
         this._previewBmp = null;
         if(this._previewBitmap && this._previewBitmap.parent)
         {
            this._previewBitmap.parent.removeChild(this._previewBitmap);
         }
         if(this._previewBitmap)
         {
            ObjectUtils.disposeObject(this._previewBitmap);
            this._previewBitmap = null;
         }
         if(this._scroll)
         {
            this._scroll.dispose();
         }
         this._scroll = null;
      }
   }
}
