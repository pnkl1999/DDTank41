package cardSystem.view
{
   import cardSystem.CardControl;
   import cardSystem.data.CardInfo;
   import cardSystem.data.SetsUpgradeRuleInfo;
   import cardSystem.elements.CardCell;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.EquipType;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.media.SoundTransform;
   import road7th.data.DictionaryEvent;
   
   public class UpGradeFrame extends Frame
   {
      
      public static const PROGRESS_HEIGHT:int = 29;
      
      public static const PROGRESS_WIDTH:int = 158;
       
      
      private var _BG:Bitmap;
      
      private var _card:CardCell;
      
      private var _cardNumBG:Bitmap;
      
      private var _progressBar:MovieClip;
      
      private var _progressBarMask:Sprite;
      
      private var _upGradeBtn:TextButton;
      
      private var _cardInfo:CardInfo;
      
      private var _helpBtn:BaseButton;
      
      private var _leftCardNumText:FilterFrameText;
      
      private var _progressText:FilterFrameText;
      
      private var _ruleText:FilterFrameText;
      
      private var _progressMoive:MovieClip;
      
      private var _upgradeRuleArr:Vector.<SetsUpgradeRuleInfo>;
      
      private var _levelBmp:Bitmap;
      
      private var _level:FilterFrameText;
      
      private var _helpFrame:Frame;
      
      private var _okBtn:TextButton;
      
      private var _content:Bitmap;
      
      private var _ruleInfo:SetsUpgradeRuleInfo;
      
      private var _lastGP:int = -1;
      
      private var _lastLevel:int = -1;
      
      private var upgradeMovie:MovieClip;
      
      private var _soundControl:SoundTransform;
      
      public function UpGradeFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         escEnable = true;
         titleText = LanguageMgr.GetTranslation("ddt.cardSystem.UpGradeFrame.title");
         this._BG = ComponentFactory.Instance.creatBitmap("asset.upgradeFrame.bg");
         this._card = new CardCell(ComponentFactory.Instance.creatBitmap("asset.upgradeFrame.cardBG"));
         this._card.setContentSize(120,175);
         this._card.starVisible = false;
         PositionUtils.setPos(this._card,"upgradeFrame.cellPos");
         this._cardNumBG = ComponentFactory.Instance.creatBitmap("asset.upgradeFrame.cardNum");
         this._progressBar = ClassUtils.CreatInstance("asset.upgradeFrame.progressBG") as MovieClip;
         PositionUtils.setPos(this._progressBar,"upgradeFrame.progressPos");
         this._progressBarMask = new Sprite();
         this._progressBarMask.graphics.beginFill(16777215,1);
         this._progressBarMask.graphics.drawRect(0,0,PROGRESS_WIDTH,PROGRESS_HEIGHT);
         this._progressBarMask.graphics.endFill();
         PositionUtils.setPos(this._progressBarMask,"upgradeFrame.progressMaskPos");
         this._progressBar.mask = this._progressBarMask;
         this._upGradeBtn = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.button");
         this._upGradeBtn.text = LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaUpgrade.okLabel");
         this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.helpBtn");
         this._leftCardNumText = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.leftNum");
         this._progressText = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.progeressTxt");
         this._ruleText = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.ruleTxt");
         this._progressMoive = ClassUtils.CreatInstance("asset.upgradeFrame.progressBarfalsh") as MovieClip;
         PositionUtils.setPos(this._progressMoive,"upgradeFrame.progressMoivePos");
         this._levelBmp = ComponentFactory.Instance.creatBitmap("asset.upgradeFrame.level");
         this._level = ComponentFactory.Instance.creatComponentByStylename("cardSystem.level.big");
         PositionUtils.setPos(this._level,"cardSystem.upgrade.level.pos");
         addToContent(this._BG);
         addToContent(this._card);
         addToContent(this._cardNumBG);
         addToContent(this._progressBar);
         addToContent(this._progressBarMask);
         addToContent(this._upGradeBtn);
         addToContent(this._helpBtn);
         addToContent(this._leftCardNumText);
         addToContent(this._progressText);
         addToContent(this._ruleText);
         addToContent(this._progressMoive);
         addToContent(this._levelBmp);
         addToContent(this._level);
         this._progressMoive.visible = false;
         this._progressBar["arrow"].visible = false;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._upGradeBtn.addEventListener(MouseEvent.CLICK,this.__upGradeHandler);
         PlayerManager.Instance.Self.cardBagDic.addEventListener(DictionaryEvent.UPDATE,this.__upDateHandler);
         this._helpBtn.addEventListener(MouseEvent.CLICK,this.__helpHandler);
         this._progressMoive.addEventListener(Event.COMPLETE,this.__progressPlayOver);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._upGradeBtn.removeEventListener(MouseEvent.CLICK,this.__upGradeHandler);
         PlayerManager.Instance.Self.cardBagDic.removeEventListener(DictionaryEvent.UPDATE,this.__upDateHandler);
         this._helpBtn.removeEventListener(MouseEvent.CLICK,this.__helpHandler);
         this._progressMoive.removeEventListener(Event.COMPLETE,this.__progressPlayOver);
      }
      
      private function __progressPlayOver(param1:Event) : void
      {
         this._progressMoive.visible = false;
      }
      
      private function __helpHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._helpFrame == null)
         {
            this._helpFrame = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.helpFrame");
            this._okBtn = ComponentFactory.Instance.creatComponentByStylename("UpGradeFrame.helpFrame.OK");
            this._content = ComponentFactory.Instance.creatBitmap("asset.upgradeFrame.content");
            this._okBtn.text = LanguageMgr.GetTranslation("ok");
            this._helpFrame.titleText = LanguageMgr.GetTranslation("ddt.cardSystem.upgrade.explain");
            this._helpFrame.addToContent(this._okBtn);
            this._helpFrame.addToContent(this._content);
            this._okBtn.addEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
            this._helpFrame.addEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         }
         LayerManager.Instance.addToLayer(this._helpFrame,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __helpFrameRespose(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.disposeHelpFrame();
         }
      }
      
      private function disposeHelpFrame() : void
      {
         this._helpFrame.removeEventListener(FrameEvent.RESPONSE,this.__helpFrameRespose);
         this._okBtn.removeEventListener(MouseEvent.CLICK,this.__closeHelpFrame);
         this._helpFrame.dispose();
         this._okBtn = null;
         this._content = null;
         this._helpFrame = null;
      }
      
      protected function __closeHelpFrame(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.disposeHelpFrame();
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      private function __upDateHandler(param1:DictionaryEvent) : void
      {
         var _loc2_:CardInfo = param1.data as CardInfo;
         if(_loc2_.TemplateID != this._cardInfo.TemplateID)
         {
            return;
         }
         if(_loc2_.CardGP - this._lastGP == 0)
         {
            return;
         }
         MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.upgradeFrame.upSuccess",_loc2_.CardGP - this._lastGP),0,true);
         this.cardInfo = _loc2_;
         this._progressMoive.visible = true;
         this._progressMoive.gotoAndPlay(1);
         this._progressBar.gotoAndPlay(1);
         this._progressBar["arrow"].visible = true;
      }
      
      protected function __upGradeHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._cardInfo.Count < this._ruleInfo.UpdateCardCount)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.UpGradeFrame.moreCards"));
            return;
         }
         if(this._cardInfo.Level >= EquipType.CardMaxLv)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.cardSystem.upgradeFrame.isMaxLevel"));
            return;
         }
         SocketManager.Instance.out.sendUpGradeCard(this._cardInfo.Place);
      }
      
      public function set cardInfo(param1:CardInfo) : void
      {
         this._cardInfo = param1;
         this._upgradeRuleArr = CardControl.Instance.model.upgradeRuleVec;
         var _loc2_:int = 0;
         while(_loc2_ < this._upgradeRuleArr.length)
         {
            if((this._upgradeRuleArr[_loc2_] as SetsUpgradeRuleInfo).Level == param1.Level + 1)
            {
               this._ruleInfo = this._upgradeRuleArr[_loc2_];
               break;
            }
            _loc2_++;
         }
         this.upView();
      }
      
      private function upView() : void
      {
         this._level.text = this._cardInfo.Level < 10 ? "0" + this._cardInfo.Level : this._cardInfo.Level.toString();
         if(this._lastLevel != -1 && this._lastLevel + 1 == this._cardInfo.Level)
         {
            if(this.upgradeMovie == null)
            {
               this.upgradeMovie = ClassUtils.CreatInstance("asset.upgradeFrame.upSuccess.movie") as MovieClip;
               LayerManager.Instance.addToLayer(this.upgradeMovie,LayerManager.STAGE_TOP_LAYER,false,LayerManager.ALPHA_BLOCKGOUND);
               this._soundControl = new SoundTransform();
               if(SoundManager.instance.allowSound)
               {
                  this._soundControl.volume = 1;
               }
               else
               {
                  this._soundControl.volume = 0;
               }
               this.upgradeMovie.soundTransform = this._soundControl;
               this.upgradeMovie.addEventListener(Event.COMPLETE,this.__playOver);
               this._upGradeBtn.enable = false;
            }
            PositionUtils.setPos(this.upgradeMovie,"upgradeFrame.upSuccessMoivePos");
         }
         this._card.cardInfo = this._cardInfo;
         this._leftCardNumText.htmlText = LanguageMgr.GetTranslation("ddt.cardSystem.upgradeFrame.ownCardNum",this._cardInfo.Count);
         if(this._cardInfo.Level == 0)
         {
            this._progressText.text = this._cardInfo.CardGP + "/" + this._ruleInfo.Exp;
            this._progressBarMask.width = PROGRESS_WIDTH * this._cardInfo.CardGP / this._ruleInfo.Exp;
         }
         else if(this._cardInfo.Level < EquipType.CardMaxLv)
         {
            this._progressText.text = String(this._cardInfo.CardGP - this._upgradeRuleArr[this._cardInfo.Level - 1].Exp) + "/" + String(this._ruleInfo.Exp - this._upgradeRuleArr[this._cardInfo.Level - 1].Exp);
            this._progressBarMask.width = PROGRESS_WIDTH * (this._cardInfo.CardGP - this._upgradeRuleArr[this._cardInfo.Level - 1].Exp) / (this._upgradeRuleArr[this._cardInfo.Level].Exp - this._upgradeRuleArr[this._cardInfo.Level - 1].Exp);
         }
         else
         {
            this._progressText.visible = false;
            this._progressBarMask.width = 0;
         }
         this._ruleText.htmlText = LanguageMgr.GetTranslation("ddt.cardSystem.upgradeFrame.rule",this._ruleInfo.Level > EquipType.CardMaxLv ? EquipType.CardMaxLv : this._ruleInfo.Level,this._ruleInfo.UpdateCardCount,this._ruleInfo.MinExp,this._ruleInfo.MaxExp);
         this._lastGP = this._cardInfo.CardGP;
         this._lastLevel = this._cardInfo.Level;
      }
      
      private function __playOver(param1:Event) : void
      {
         this.upgradeMovie.removeEventListener(Event.COMPLETE,this.__playOver);
         this._soundControl.volume = 0;
         this.upgradeMovie.soundTransform = this._soundControl;
         this._soundControl = null;
         if(this.upgradeMovie)
         {
            ObjectUtils.disposeObject(this.upgradeMovie);
         }
         this.upgradeMovie = null;
         this._upGradeBtn.enable = true;
      }
      
      override public function dispose() : void
      {
         if(this.upgradeMovie)
         {
            this.upgradeMovie.removeEventListener(Event.COMPLETE,this.__playOver);
            ObjectUtils.disposeObject(this.upgradeMovie);
         }
         this.removeEvent();
         super.dispose();
         this._cardInfo = null;
         this._upgradeRuleArr = null;
         this._upGradeBtn = null;
         this.upgradeMovie = null;
         this._BG = null;
         this._card = null;
         this._cardNumBG = null;
         this._progressBar = null;
         this._upGradeBtn = null;
         this._helpBtn = null;
         this._leftCardNumText = null;
         this._progressText = null;
         this._ruleText = null;
         this._progressMoive = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
