package email.view
{
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.InventoryItemInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.LeavePageManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import email.manager.MailManager;
   import flash.events.MouseEvent;
   
   public class DiamondOfReading extends DiamondBase
   {
       
      
      private var type:int;
      
      private var payAlertFrame:BaseAlerFrame;
      
      public function DiamondOfReading()
      {
         super();
      }
      
      public function set readOnly(value:Boolean) : void
      {
         if(value)
         {
            this.removeEvent();
         }
         else
         {
            this.addEvent();
         }
      }
      
      override protected function addEvent() : void
      {
         addEventListener(MouseEvent.CLICK,this.__distill);
      }
      
      override protected function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this.__distill);
      }
      
      override protected function update() : void
      {
         var annex:* = undefined;
         annex = undefined;
         annex = undefined;
         annex = _info.getAnnexByIndex(index);
         chargedImg.visible = false;
         if(annex && annex is String)
         {
            this.buttonMode = true;
            _cell.visible = false;
            centerMC.visible = true;
            countTxt.text = "";
            mouseEnabled = true;
            mouseChildren = true;
            if(annex == "gold")
            {
               centerMC.setFrame(3);
               countTxt.text = String(_info.Gold);
               mouseChildren = false;
            }
            else if(annex == "money")
            {
               if(_info.Type > 100)
               {
                  centerMC.visible = false;
                  mouseEnabled = false;
                  mouseChildren = false;
               }
               else
               {
                  centerMC.setFrame(2);
                  countTxt.text = String(_info.Money);
                  mouseChildren = false;
               }
            }
            else if(annex == "gift")
            {
               centerMC.setFrame(6);
               countTxt.text = String(_info.GiftToken);
               mouseChildren = false;
            }
            else if(annex == "medal")
            {
               centerMC.setFrame(7);
               countTxt.text = String(_info.Medal);
               mouseChildren = false;
            }
         }
         else if(annex)
         {
            _cell.visible = true;
            _cell.info = annex as InventoryItemInfo;
            mouseEnabled = true;
            mouseChildren = true;
            countTxt.text = "";
            if(_info.Type > 100 && _info.Money > 0)
            {
               centerMC.visible = false;
               chargedImg.visible = true;
            }
            else
            {
               centerMC.visible = false;
            }
         }
         else
         {
            mouseEnabled = false;
            mouseChildren = false;
            centerMC.visible = false;
            _cell.visible = false;
            countTxt.text = "";
         }
      }
      
      private function __distill(event:MouseEvent) : void
      {
         var i:uint = 0;
         SoundManager.instance.play("008");
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         mouseEnabled = false;
         mouseChildren = false;
         if(_info == null)
         {
            return;
         }
         var annex:* = _info.getAnnexByIndex(index);
         if(annex)
         {
            for(i = 1; i <= 5; i++)
            {
               if(annex == _info["Annex" + i])
               {
                  this.type = i;
                  break;
               }
            }
            if(annex == "gold")
            {
               this.type = 6;
            }
            else if(annex == "money")
            {
               this.type = 7;
            }
            else if(annex == "gift")
            {
               this.type = 8;
            }
            else if(annex == "medal")
            {
               this.type = 9;
            }
         }
         if(this.type > -1)
         {
            if(_info.Type > 100 && (this.type >= 1 && this.type <= 5) && _info.Money > 0)
            {
               this.payAlertFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.emailTip"),LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.deleteTip") + " " + _info.Money + LanguageMgr.GetTranslation("tank.view.emailII.EmailIIDiamondView.money"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
               this.payAlertFrame.addEventListener(FrameEvent.RESPONSE,this.__payFrameResponse);
               return;
            }
            MailManager.Instance.getAnnexToBag(_info,this.type);
         }
      }
      
      private function __payFrameResponse(event:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this.payAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__payFrameResponse);
         this.payAlertFrame.dispose();
         this.payAlertFrame = null;
         if(event.responseCode == FrameEvent.SUBMIT_CLICK)
         {
            this.confirmPay();
         }
         else if(event.responseCode == FrameEvent.CANCEL_CLICK || event.responseCode == FrameEvent.CLOSE_CLICK || event.responseCode == FrameEvent.ESC_CLICK)
         {
            this.canclePay();
         }
      }
      
      private function confirmPay() : void
      {
         var confirm:BaseAlerFrame = null;
         if(PlayerManager.Instance.Self.Money >= _info.Money)
         {
            MailManager.Instance.getAnnexToBag(_info,this.type);
            mouseEnabled = false;
            mouseChildren = false;
         }
         else
         {
            confirm = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.view.comon.lack"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
            confirm.addEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
            mouseEnabled = true;
            mouseChildren = true;
         }
      }
      
      private function __confirmResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var frame:BaseAlerFrame = evt.currentTarget as BaseAlerFrame;
         frame.removeEventListener(FrameEvent.RESPONSE,this.__confirmResponse);
         ObjectUtils.disposeObject(frame);
         if(frame.parent)
         {
            frame.parent.removeChild(frame);
         }
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            LeavePageManager.leaveToFillPath();
         }
      }
      
      private function canclePay() : void
      {
         mouseEnabled = true;
         mouseChildren = true;
      }
      
      override public function dispose() : void
      {
         if(this.payAlertFrame)
         {
            this.payAlertFrame.removeEventListener(FrameEvent.RESPONSE,this.__payFrameResponse);
            this.payAlertFrame.dispose();
         }
         this.payAlertFrame = null;
         super.dispose();
      }
   }
}
