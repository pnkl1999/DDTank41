package fightLib.command
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.SoundManager;
   
   public class PopupHFrameCommand extends BaseFightLibCommand
   {
       
      
      private var _infoString:String;
      
      private var _okLabel:String;
      
      private var _cancelLabel:String;
      
      private var _okCallBack:Function;
      
      private var _cancellCallBack:Function;
      
      private var _showOkBtn:Boolean;
      
      private var _showCancelBtn:Boolean;
      
      private var _alert:BaseAlerFrame;
      
      public function PopupHFrameCommand(param1:String, param2:String = "", param3:Function = null, param4:String = "", param5:Function = null, param6:Boolean = true, param7:Boolean = false)
      {
         super();
         this._infoString = param1;
         this._okLabel = param2;
         this._cancelLabel = param4;
         this._okCallBack = param3;
         this._cancellCallBack = param5;
         this._showOkBtn = param6;
         this._showCancelBtn = param7;
      }
      
      protected function __response(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               if(this._cancellCallBack != null)
               {
                  this._cancellCallBack.apply();
               }
               this.closeAlert();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._okCallBack != null)
               {
                  this._okCallBack.apply();
               }
               this.closeAlert();
         }
      }
      
      override public function excute() : void
      {
         super.excute();
         var _loc1_:BaseAlerFrame = this._alert;
         this._alert = AlertManager.Instance.simpleAlert("",this._infoString,this._okLabel,this._cancelLabel,false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__response);
         if(_loc1_ && _loc1_ != this._alert)
         {
            _loc1_.removeEventListener(FrameEvent.RESPONSE,this.__response);
            ObjectUtils.disposeObject(_loc1_);
         }
      }
      
      override public function finish() : void
      {
         if(this._okCallBack != null)
         {
            this._okCallBack.apply();
         }
         this.closeAlert();
         super.finish();
      }
      
      override public function undo() : void
      {
         this.closeAlert();
         super.undo();
      }
      
      override public function dispose() : void
      {
         this._okCallBack = null;
         this._cancellCallBack = null;
         this._okLabel = null;
         this._cancelLabel = null;
         this.closeAlert();
      }
      
      private function closeFrame() : void
      {
      }
      
      private function closeAlert() : void
      {
         if(this._alert)
         {
            ObjectUtils.disposeObject(this._alert);
            this._alert.removeEventListener(FrameEvent.RESPONSE,this.__response);
            this._alert = null;
         }
      }
   }
}
