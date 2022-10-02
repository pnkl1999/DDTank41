package consortion.view.selfConsortia
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.NumberSelecter;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import consortion.ConsortionModelControl;
   import consortion.data.ConsortionSkillInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class ConsortionOpenSkillFrame extends Frame
   {
       
      
      private var _cellBG:Bitmap;
      
      private var _cell:ConsortionSkillCell;
      
      private var _numSelected:NumberSelecter;
      
      private var _riches:FilterFrameText;
      
      private var _ok:TextButton;
      
      private var _richesbg:ScaleFrameImage;
      
      private var _day:Bitmap;
      
      private var _info:ConsortionSkillInfo;
      
      private var _alertFrame:BaseAlerFrame;
      
      private var _isMetal:Boolean;
      
      public function ConsortionOpenSkillFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      public function set isMetal(param1:Boolean) : void
      {
         this._isMetal = param1;
      }
      
      private function initView() : void
      {
         escEnable = true;
         disposeChildren = true;
         titleText = LanguageMgr.GetTranslation("ddt.consortion.openSkillFrame.title");
         this._cellBG = ComponentFactory.Instance.creatBitmap("asset.consortion.skillFrame.showbg");
         this._cell = ComponentFactory.Instance.creatCustomObject("openSkillFrame.cell");
         this._numSelected = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.numberSelected");
         this._day = ComponentFactory.Instance.creatBitmap("asset.consortion.skillFrame.day");
         this._richesbg = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.richbg");
         this._riches = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.rich");
         this._ok = ComponentFactory.Instance.creatComponentByStylename("consortion.openSkillFrame.ok");
         addToContent(this._cellBG);
         addToContent(this._cell);
         addToContent(this._numSelected);
         addToContent(this._day);
         addToContent(this._richesbg);
         addToContent(this._riches);
         addToContent(this._ok);
         this._ok.text = LanguageMgr.GetTranslation("ok");
         this._riches.text = "0";
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._numSelected.addEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._ok.addEventListener(MouseEvent.CLICK,this.__okHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._numSelected.removeEventListener(Event.CHANGE,this.__numberSelecterChange);
         this._ok.removeEventListener(MouseEvent.CLICK,this.__okHandler);
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __numberSelecterChange(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._riches.text = String(this._numSelected.currentValue * this._info.riches);
         if(this._isMetal)
         {
            this._riches.text = String(this._info.metal * this._numSelected.currentValue);
         }
      }
      
      private function __okHandler(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._info)
         {
            if(this._isMetal)
            {
               if(PlayerManager.Instance.Self.medal < int(this._riches.text))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough3"));
                  return;
               }
            }
            else if(this._info.type == 1 && PlayerManager.Instance.Self.consortiaInfo.Riches < int(this._riches.text) || this._info.type == 2 && PlayerManager.Instance.Self.Riches < int(this._riches.text))
            {
               _loc3_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillItem.click.enough" + this._info.type),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.BLCAK_BLOCKGOUND);
               _loc3_.addEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
               return;
            }
            if(ConsortionModelControl.Instance.model.hasSomeGroupSkill(this._info.group,this._info.id))
            {
               this._alertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("ddt.consortion.skillFrame.alertFrame.content"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,true,LayerManager.BLCAK_BLOCKGOUND);
               this._alertFrame.addEventListener(FrameEvent.RESPONSE,this.__alertResponseHandler);
               return;
            }
            _loc2_ = !!this._isMetal ? int(int(2)) : int(int(1));
            SocketManager.Instance.out.sendConsortionSkill(true,this._info.id,int(this._numSelected.currentValue),_loc2_);
            this.dispose();
         }
      }
      
      private function __noEnoughHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
            case FrameEvent.ENTER_CLICK:
               ConsortionModelControl.Instance.alertTaxFrame();
         }
         var _loc2_:BaseAlerFrame = param1.currentTarget as BaseAlerFrame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__noEnoughHandler);
         _loc2_.dispose();
         _loc2_ = null;
      }
      
      private function __alertResponseHandler(param1:FrameEvent) : void
      {
         var _loc2_:int = 0;
         this._alertFrame.removeEventListener(FrameEvent.RESPONSE,this.__alertResponseHandler);
         this._alertFrame.dispose();
         this._alertFrame = null;
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               if(this._info && this._numSelected)
               {
                  _loc2_ = !!this._isMetal ? int(int(2)) : int(int(1));
                  SocketManager.Instance.out.sendConsortionSkill(true,this._info.id,int(this._numSelected.currentValue),_loc2_);
                  this.dispose();
                  break;
               }
         }
      }
      
      public function set info(param1:ConsortionSkillInfo) : void
      {
         this._info = param1;
         this._riches.text = String(this._info.riches * this._numSelected.currentValue);
         if(this._isMetal)
         {
            this._riches.text = String(this._info.metal * this._numSelected.currentValue);
         }
         this._richesbg.setFrame(param1.type);
         if(this._isMetal)
         {
            this._richesbg.setFrame(3);
         }
         this._cell.tipData = param1;
         this._cell.contentRect(60,59);
         this._cell.setGray(false);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         this._info = null;
         super.dispose();
         this._cellBG = null;
         this._cell = null;
         this._richesbg = null;
         this._day = null;
         this._numSelected = null;
         this._riches = null;
         this._ok = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
