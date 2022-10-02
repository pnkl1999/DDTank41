package email.view
{
   import bagAndInfo.BagAndGiftFrame;
   import bagAndInfo.BagAndInfoManager;
   import baglocked.BaglockedManager;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import email.data.EmailInfo;
   import email.data.EmailType;
   import email.manager.MailManager;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.SoundTransform;
   
   public class EmailStrip extends Sprite implements Disposeable
   {
      
      public static const SELECT:String = "select";
       
      
      protected var _info:EmailInfo;
      
      protected var _isReading:Boolean;
      
      protected var _checkBox:SelectedCheckButton;
      
      protected var _cell:DiamondOfStrip;
      
      protected var _emailStripBg:ScaleFrameImage;
      
      protected var _deleteBtn:BaseButton;
      
      protected var _GMImg:Bitmap;
      
      protected var _emailType:ScaleFrameImage;
      
      protected var _EggKingImg:Bitmap;
      
      protected var _topicTxt:FilterFrameText;
      
      protected var _senderTxt:FilterFrameText;
      
      protected var _validityTxt:FilterFrameText;
      
      protected var _payImg:Bitmap;
      
      protected var _unReadImg:Bitmap;
      
      protected var _payIMGII:Bitmap;
      
      private var _deleteAlert:BaseAlerFrame;
      
      private var _emptyItem:Boolean = false;
      
      private var _movie:MovieClip;
      
      private var _soundControl:SoundTransform;
      
      public function EmailStrip()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      protected function initView() : void
      {
         var topicS:Sprite = null;
         topicS = null;
         topicS = null;
         this._emailStripBg = ComponentFactory.Instance.creat("email.emailStripMC");
         addChildAt(this._emailStripBg,0);
         this._emailStripBg.setFrame(1);
         this._cell = ComponentFactory.Instance.creatCustomObject("email.emailStrip.cell");
         addChild(this._cell);
         var cellMask:Sprite = this.creatMaskSprit();
         addChild(cellMask);
         this._cell.mask = cellMask;
         this._emailType = ComponentFactory.Instance.creat("email.emailType");
         addChild(this._emailType);
         this._EggKingImg = ComponentFactory.Instance.creatBitmap("asset.email.eggKingAsset");
         addChild(this._EggKingImg);
         this._EggKingImg.visible = false;
         this._topicTxt = ComponentFactory.Instance.creat("email.strip.topicTxt");
         addChild(this._topicTxt);
         topicS = new Sprite();
         topicS.graphics.beginFill(16711680);
         topicS.graphics.drawRect(0,0,218,18);
         topicS.graphics.endFill();
         topicS.x = this._topicTxt.x;
         topicS.y = this._topicTxt.y;
         addChild(topicS);
         this._topicTxt.mask = topicS;
         this._senderTxt = ComponentFactory.Instance.creat("email.strip.senderTxt");
         addChild(this._senderTxt);
         this._validityTxt = ComponentFactory.Instance.creat("email.strip.validityTxt");
         addChild(this._validityTxt);
         this._payImg = ComponentFactory.Instance.creatBitmap("asset.email.payImg");
         addChild(this._payImg);
         this._payImg.visible = true;
         this._unReadImg = ComponentFactory.Instance.creatBitmap("asset.email.unReadImg");
         addChild(this._unReadImg);
         this._unReadImg.visible = false;
         this._deleteBtn = ComponentFactory.Instance.creat("email.stripDeleteBtn");
         addChild(this._deleteBtn);
         buttonMode = true;
         this._checkBox = ComponentFactory.Instance.creat("email.stripCheckBtn");
         addChild(this._checkBox);
         this._checkBox.selected = false;
         this._payIMGII = ComponentFactory.Instance.creatBitmap("asset.email.payImgII");
         addChild(this._payIMGII);
         this._payIMGII.visible = false;
      }
      
      private function creatMaskSprit() : Sprite
      {
         var mask:Sprite = new Sprite();
         mask.graphics.beginFill(16777215);
         mask.graphics.drawRect(0,0,45,45);
         mask.graphics.endFill();
         return mask;
      }
      
      private function addEvent() : void
      {
         this._deleteBtn.addEventListener(MouseEvent.CLICK,this.__delete);
         addEventListener(MouseEvent.CLICK,this.__click);
         addEventListener(MouseEvent.MOUSE_OVER,this.__over);
         addEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      private function removeEvent() : void
      {
         if(this._deleteBtn)
         {
            this._deleteBtn.removeEventListener(MouseEvent.CLICK,this.__delete);
         }
         removeEventListener(MouseEvent.CLICK,this.__click);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__over);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__out);
      }
      
      public function set info(value:EmailInfo) : void
      {
         this._info = value;
         this.update();
      }
      
      public function get info() : EmailInfo
      {
         return this._info;
      }
      
      public function set isReading(value:Boolean) : void
      {
         if(this._isReading == value)
         {
            return;
         }
         this._isReading = value;
         this.update();
      }
      
      public function get selected() : Boolean
      {
         return this._checkBox.selected;
      }
      
      public function set selected(value:Boolean) : void
      {
         if(this._info.Type == 58 || this._info.Type == 13)
         {
            value = false;
         }
         this._checkBox.selected = value;
      }
      
      public function update() : void
      {
         var remain:Number = NaN;
         this._topicTxt.text = this._info.Title;
         this._senderTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.sender") + this._info.Sender;
         if(this._info.Type == 59)
         {
            this._info.ValidDate = 24 * 3;
         }
         remain = MailManager.Instance.calculateRemainTime(this._info.SendTime,this._info.ValidDate);
         if(remain >= 24)
         {
            this._validityTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.validity") + String(Math.ceil(remain / 24)) + LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.day");
         }
         else if(remain > 0 && remain < 24)
         {
            this._validityTxt.text = LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.validity") + String(Math.ceil(remain)) + LanguageMgr.GetTranslation("hours");
         }
         else
         {
            MailManager.Instance.removeMail(this.info);
            MailManager.Instance.changeSelected(null);
            this.clearItem();
         }
         this._unReadImg.visible = !this._info.IsRead;
         if(this._info.Type > 100)
         {
            this._unReadImg.visible = false;
            this._payImg.visible = this._info.Money > 0;
            this._payIMGII.visible = this._info.Type == 101;
         }
         else
         {
            this._deleteBtn.enable = this._info.Type != 58;
            this._EggKingImg.visible = this._info.Type == 58;
            this._checkBox.enable = this._info.Type != 58;
            this._payImg.visible = false;
            this._payIMGII.visible = false;
            if(this._info.Type == 58 || this._info.Type == 13)
            {
               this._deleteBtn.enable = false;
            }
            this._EggKingImg.visible = this._info.Type == 58;
            if(this._info.Type == 58 || this._info.Type == 13)
            {
               this._checkBox.enable = false;
            }
            this._payImg.visible = false;
            this._payIMGII.visible = false;
         }
         if(this._info.ReceiverID != this._info.SenderID && this._info.Type == 1 || this._info.Type == 59 || this._info.Type == 101)
         {
            this._emailType.setFrame(1);
         }
         else if(this._info.Type == 51)
         {
            this._emailType.setFrame(2);
         }
         else
         {
            this._emailType.visible = false;
         }
         if(this._isReading)
         {
            this._emailStripBg.setFrame(2);
         }
         else
         {
            this._emailStripBg.setFrame(1);
         }
         this._cell.info = this._info;
      }
      
      private function __delete(event:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         event.stopImmediatePropagation();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         if(this.info.hasAnnexs() || this.info.Money != 0)
         {
            this._deleteAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.view.task.TaskCatalogContentView.tip"),LanguageMgr.GetTranslation("tank.view.emailII.EmailIIStripView.delectEmail"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,true,true,LayerManager.ALPHA_BLOCKGOUND);
            this._deleteAlert.addEventListener(FrameEvent.RESPONSE,this.__deleteAlertResponse);
         }
         else
         {
            this.ok();
         }
      }
      
      private function __deleteAlertResponse(evt:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         this._deleteAlert.removeEventListener(FrameEvent.RESPONSE,this.__deleteAlertResponse);
         if(this._deleteAlert)
         {
            this._deleteAlert.dispose();
            this._deleteAlert = null;
         }
         if(evt.responseCode == FrameEvent.CANCEL_CLICK || evt.responseCode == FrameEvent.CLOSE_CLICK)
         {
            this.cancel();
         }
         if(evt.responseCode == FrameEvent.SUBMIT_CLICK || evt.responseCode == FrameEvent.ENTER_CLICK)
         {
            this.ok();
         }
      }
      
      private function cancel() : void
      {
         SoundManager.instance.play("008");
      }
      
      private function ok() : void
      {
         SoundManager.instance.play("008");
         MailManager.Instance.deleteEmail(this._info);
         this.clearItem();
         MailManager.Instance.removeMail(this.info);
         MailManager.Instance.changeSelected(null);
      }
      
      public function get emptyItem() : Boolean
      {
         return this._emptyItem;
      }
      
      private function clearItem() : void
      {
         this.removeEvent();
         buttonMode = false;
         this._emptyItem = true;
         this._topicTxt.text = "";
         this._senderTxt.text = "";
         this._validityTxt.text = "";
         if(this._emailType.parent)
         {
            removeChild(this._emailType);
         }
         if(this._topicTxt.parent)
         {
            removeChild(this._topicTxt);
         }
         if(this._senderTxt.parent)
         {
            removeChild(this._senderTxt);
         }
         if(this._validityTxt.parent)
         {
            removeChild(this._validityTxt);
         }
         if(this._unReadImg.parent)
         {
            removeChild(this._unReadImg);
         }
         if(this._payImg.parent)
         {
            removeChild(this._payImg);
         }
         if(this._checkBox.parent)
         {
            removeChild(this._checkBox);
         }
         if(this._cell.parent)
         {
            removeChild(this._cell);
         }
         if(this._payIMGII.parent)
         {
            removeChild(this._payIMGII);
         }
         this._emailStripBg.setFrame(1);
      }
      
      private function __over(event:MouseEvent) : void
      {
         if(!this._isReading)
         {
            this._emailStripBg.setFrame(2);
         }
      }
      
      private function __out(event:MouseEvent) : void
      {
         if(!this._isReading)
         {
            this._emailStripBg.setFrame(1);
         }
      }
      
      private function __click(event:MouseEvent) : void
      {
         var str:String = null;
         var startTime:Date = null;
         var arr:Array = null;
         SoundManager.instance.play("008");
         if(!this._info.IsRead)
         {
            MailManager.Instance.readEmail(this._info);
            this._info.IsRead = true;
            if(this._info.Type == EmailType.ADVERT_MAIL || this._info.Type == EmailType.CONSORTION_EMAIL)
            {
               if(SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID])
               {
                  arr = SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID] as Array;
                  if(arr.indexOf(this._info.ID) < 0)
                  {
                     arr.push(this._info.ID);
                  }
               }
               else
               {
                  SharedManager.Instance.spacialReadedMail[PlayerManager.Instance.Self.ID] = [this._info.ID];
               }
               SharedManager.Instance.save();
            }
            str = this._info.SendTime;
            startTime = new Date(Number(str.substr(0,4)),Number(str.substr(5,2)) - 1,Number(str.substr(8,2)),Number(str.substr(11,2)),Number(str.substr(14,2)),Number(str.substr(17,2)));
            if(!(this._info.Type > 100 && this._info.Money > 0) && this._info.Type != 58)
            {
               this._info.ValidDate = 72 + (TimeManager.Instance.Now().time - startTime.time) / (60 * 60 * 1000);
            }
            this.update();
            if(this._info.Type == EmailType.GIFT_GUIDE)
            {
               this._movie = ClassUtils.CreatInstance("asset.giftMovie") as MovieClip;
               LayerManager.Instance.addToLayer(this._movie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.BLCAK_BLOCKGOUND);
               this._movie.x = StageReferance.stageWidth / 2;
               this._movie.y = StageReferance.stageHeight / 2 - 250;
               this._movie.addEventListener(Event.CLOSE,this.__removeMovie);
               this._movie.addEventListener(Event.ENTER_FRAME,this.__addClickEvent);
               this._soundControl = new SoundTransform();
               if(SoundManager.instance.allowSound)
               {
                  this._soundControl.volume = 1;
               }
               else
               {
                  this._soundControl.volume = 0;
               }
               this._movie.soundTransform = this._soundControl;
            }
         }
         this.isReading = true;
         dispatchEvent(new Event(SELECT));
         MailManager.Instance.changeSelected(this._info);
      }
      
      protected function __removeMovie(event:Event) : void
      {
         this._movie.removeEventListener(Event.CLOSE,this.__removeMovie);
         this._movie.removeEventListener(MouseEvent.CLICK,this.__movieClickHandler);
         this._soundControl.volume = 0;
         this._movie.soundTransform = this._soundControl;
         this._soundControl = null;
         ObjectUtils.disposeObject(this._movie);
         this._movie = null;
      }
      
      protected function __addClickEvent(event:Event) : void
      {
         if(this._movie["ikNode_5"])
         {
            this._movie.removeEventListener(Event.ENTER_FRAME,this.__addClickEvent);
            this._movie.addEventListener(MouseEvent.CLICK,this.__movieClickHandler);
            this._movie.buttonMode = true;
         }
      }
      
      protected function __movieClickHandler(event:Event) : void
      {
         SoundManager.instance.play("008");
         BagAndInfoManager.Instance.showBagAndInfo(BagAndGiftFrame.GIFTVIEW);
         MailManager.Instance.hide();
         this.__removeMovie(null);
      }
      
      override public function get height() : Number
      {
         return this._emailStripBg.height;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._checkBox)
         {
            ObjectUtils.disposeObject(this._checkBox);
         }
         this._checkBox = null;
         if(this._emailType)
         {
            ObjectUtils.disposeObject(this._emailType);
         }
         this._emailType = null;
         if(this._payImg)
         {
            ObjectUtils.disposeObject(this._payImg);
         }
         this._payImg = null;
         if(this._unReadImg)
         {
            ObjectUtils.disposeObject(this._unReadImg);
         }
         this._unReadImg = null;
         if(this._deleteBtn)
         {
            ObjectUtils.disposeObject(this._deleteBtn);
         }
         this._deleteBtn = null;
         if(this._topicTxt)
         {
            ObjectUtils.disposeObject(this._topicTxt);
         }
         this._topicTxt = null;
         if(this._senderTxt)
         {
            ObjectUtils.disposeObject(this._senderTxt);
         }
         this._senderTxt = null;
         if(this._validityTxt)
         {
            ObjectUtils.disposeObject(this._validityTxt);
         }
         this._validityTxt = null;
         if(this._emailStripBg)
         {
            ObjectUtils.disposeObject(this._emailStripBg);
         }
         this._emailStripBg = null;
         if(this._cell)
         {
            ObjectUtils.disposeObject(this._cell);
         }
         this._cell = null;
         if(this._deleteAlert)
         {
            ObjectUtils.disposeObject(this._deleteAlert);
         }
         this._deleteAlert = null;
         if(this._payIMGII)
         {
            ObjectUtils.disposeObject(this._payIMGII);
         }
         this._payIMGII = null;
         this._info = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
