package ddt.view.common.church
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedIconButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.ui.vo.AlertInfo;
   import ddt.data.BagInfo;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ChurchProposeFrame extends BaseAlerFrame
   {
       
      
      private var _bg:Bitmap;
      
      private var _alertInfo:AlertInfo;
      
      private var _txtInfo:TextArea;
      
      private var _chkSysMsg:SelectedIconButton;
      
      private var _maxChar:FilterFrameText;
      
      private var _buyRingFrame:ChurchBuyRingFrame;
      
      private var _spouseID:int;
      
      private var useBugle:Boolean;
      
      public function ChurchProposeFrame()
      {
         super();
         this.initialize();
         this.addEvent();
      }
      
      public function get spouseID() : int
      {
         return this._spouseID;
      }
      
      public function set spouseID(param1:int) : void
      {
         this._spouseID = param1;
      }
      
      private function initialize() : void
      {
         cancelButtonStyle = "core.simplebt";
         submitButtonStyle = "core.simplebt";
         this._alertInfo = new AlertInfo();
         this._alertInfo.moveEnable = false;
         info = this._alertInfo;
         this.escEnable = true;
         this._bg = ComponentFactory.Instance.creatBitmap("asset.church.ProposeAsset");
         addToContent(this._bg);
         this._txtInfo = ComponentFactory.Instance.creat("common.church.txtChurchProposeFrameAsset");
         this._txtInfo.maxChars = 300;
         addToContent(this._txtInfo);
         this._chkSysMsg = ComponentFactory.Instance.creat("common.church.chkChurchProposeFrameAsset");
         this._chkSysMsg.selected = true;
         addToContent(this._chkSysMsg);
         this._maxChar = ComponentFactory.Instance.creat("common.church.churchProposeMaxCharAsset");
         this._maxChar.text = "300";
         addToContent(this._maxChar);
         this.useBugle = this._chkSysMsg.selected;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._chkSysMsg.addEventListener(Event.SELECT,this.__checkClick);
         this._chkSysMsg.addEventListener(MouseEvent.CLICK,this.getFocus);
         this._txtInfo.addEventListener(Event.CHANGE,this.__input);
         this._txtInfo.addEventListener(Event.ADDED_TO_STAGE,this.__addToStages);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SoundManager.instance.play("008");
               if(PathManager.solveChurchEnable())
               {
                  this.confirmSubmit();
               }
         }
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
         this._chkSysMsg.removeEventListener(Event.CHANGE,this.__checkClick);
         this._chkSysMsg.removeEventListener(MouseEvent.CLICK,this.getFocus);
         this._txtInfo.removeEventListener(Event.CHANGE,this.__input);
         this._txtInfo.removeEventListener(Event.ADDED_TO_STAGE,this.__addToStages);
      }
      
      private function __checkClick(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this.useBugle = this._chkSysMsg.selected;
      }
      
      private function getFocus(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(stage)
         {
            stage.focus = this;
         }
      }
      
      private function __addToStages(param1:Event) : void
      {
         this._txtInfo.stage.focus = this._txtInfo;
         this._txtInfo.text = "";
      }
      
      private function __input(param1:Event) : void
      {
         var _loc2_:int = this._txtInfo.text.length;
         this._maxChar.text = String(300 - _loc2_);
      }
      
      private function confirmSubmit() : void
      {
         var _loc1_:String = null;
         if(!PlayerManager.Instance.Self.getBag(BagInfo.PROPBAG).findFistItemByTemplateId(11103))
         {
            _loc1_ = FilterWordManager.filterWrod(this._txtInfo.text);
            this._buyRingFrame = ComponentFactory.Instance.creat("common.church.ChurchBuyRingFrame");
            this._buyRingFrame.addEventListener(Event.CLOSE,this.buyRingFrameClose);
            this._buyRingFrame.spouseID = this.spouseID;
            this._buyRingFrame.proposeStr = _loc1_;
            this._buyRingFrame.useBugle = this._chkSysMsg.selected;
            this._buyRingFrame.show();
            this.dispose();
            return;
         }
         this.sendPropose();
      }
      
      private function sendPropose() : void
      {
         var _loc1_:String = FilterWordManager.filterWrod(this._txtInfo.text);
         SocketManager.Instance.out.sendPropose(this._spouseID,_loc1_,this.useBugle);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_TOP_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
      }
      
      private function buyRingFrameClose(param1:Event) : void
      {
         if(this._buyRingFrame)
         {
            this._buyRingFrame.removeEventListener(Event.CLOSE,this.buyRingFrameClose);
            if(this._buyRingFrame.parent)
            {
               this._buyRingFrame.parent.removeChild(this._buyRingFrame);
            }
            this._buyRingFrame.dispose();
         }
         this._buyRingFrame = null;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         if(this._bg)
         {
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            this._bg.bitmapData.dispose();
            this._bg.bitmapData = null;
         }
         this._bg = null;
         this._txtInfo = null;
         if(this._chkSysMsg)
         {
            if(this._chkSysMsg.parent)
            {
               this._chkSysMsg.parent.removeChild(this._chkSysMsg);
            }
            this._chkSysMsg.dispose();
         }
         this._chkSysMsg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
         dispatchEvent(new Event(Event.CLOSE));
      }
   }
}
