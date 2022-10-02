package im.chatFrame
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.MinimizeFrame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.ui.text.TextArea;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.data.player.SelfInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.FilterWordManager;
   import ddt.utils.PositionUtils;
   import ddt.view.PlayerPortraitView;
   import ddt.view.common.LevelIcon;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   import im.IMController;
   import road7th.utils.StringHelper;
   import vip.VipController;
   
   public class PrivateChatFrame extends MinimizeFrame
   {
       
      
      private var _info:PlayerInfo;
      
      private var _outputBG:ScaleBitmapImage;
      
      private var _inputBG:ScaleBitmapImage;
      
      private var _output:TextArea;
      
      private var _input:TextArea;
      
      private var _send:SimpleBitmapButton;
      
      private var _record:SimpleBitmapButton;
      
      private var _recordFrame:PrivateRecordFrame;
      
      private var _show:Boolean = false;
      
      private var _selfPortrait:PlayerPortraitView;
      
      private var _selfLevelT:FilterFrameText;
      
      private var _selfLevel:LevelIcon;
      
      private var _selfName:FilterFrameText;
      
      private var _selfVipName:GradientText;
      
      private var _targetProtrait:PlayerPortraitView;
      
      private var _targetLevelT:FilterFrameText;
      
      private var _targetLevel:LevelIcon;
      
      private var _targetName:FilterFrameText;
      
      private var _targetVipName:GradientText;
      
      private var _warningBg:Bitmap;
      
      private var _warning:Bitmap;
      
      private var _warningWord:FilterFrameText;
      
      public function PrivateChatFrame()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         var _loc1_:SelfInfo = null;
         _loc1_ = null;
         this._selfPortrait = ComponentFactory.Instance.creatCustomObject("chatFrame.selfPortrait",["right"]);
         this._selfLevelT = ComponentFactory.Instance.creatComponentByStylename("chatFrame.selflevel");
         this._selfLevel = ComponentFactory.Instance.creatCustomObject("chatFrame.selfLevelIcon");
         this._targetProtrait = ComponentFactory.Instance.creatCustomObject("chatFrame.targetPortrait",["right"]);
         this._targetLevelT = ComponentFactory.Instance.creatComponentByStylename("chatFrame.targetlevel");
         this._targetLevel = ComponentFactory.Instance.creatCustomObject("chatFrame.targetLevelIcon");
         this._outputBG = ComponentFactory.Instance.creatComponentByStylename("chatFrame.outputBG");
         this._inputBG = ComponentFactory.Instance.creatComponentByStylename("chatFrame.inputBG");
         this._output = ComponentFactory.Instance.creatComponentByStylename("chatFrame.output");
         this._input = ComponentFactory.Instance.creatComponentByStylename("chatFrame.input");
         this._send = ComponentFactory.Instance.creatComponentByStylename("chatFrame.send");
         this._record = ComponentFactory.Instance.creatComponentByStylename("chatFrame.record");
         this._warningBg = ComponentFactory.Instance.creatBitmap("asset.chatFrame.worningbg");
         this._warning = ComponentFactory.Instance.creatBitmap("asset.chatFrame.worning");
         this._warningWord = ComponentFactory.Instance.creatComponentByStylename("chatFrame.warningword");
         addToContent(this._selfPortrait);
         addToContent(this._selfLevelT);
         addToContent(this._selfLevel);
         addToContent(this._targetProtrait);
         addToContent(this._targetLevelT);
         addToContent(this._targetLevel);
         addToContent(this._outputBG);
         addToContent(this._inputBG);
         addToContent(this._output);
         addToContent(this._input);
         addToContent(this._send);
         addToContent(this._record);
         addToContent(this._warningBg);
         addToContent(this._warningWord);
         addToContent(this._warning);
         this._input.textField.maxChars = 150;
         this._send.tipStyle = "ddt.view.tips.OneLineTip";
         this._send.tipDirctions = "0";
         this._send.tipGapV = 5;
         this._send.tipData = LanguageMgr.GetTranslation("IM.privateChatFrame.send.tipdata");
         _loc1_ = PlayerManager.Instance.Self;
         this._selfPortrait.info = _loc1_;
         this._selfLevelT.text = LanguageMgr.GetTranslation("IM.ChatFrame.level");
         this._selfLevel.setSize(LevelIcon.SIZE_SMALL);
         this._selfLevel.setInfo(_loc1_.Grade,_loc1_.Repute,_loc1_.WinCount,_loc1_.TotalCount,_loc1_.FightPower,_loc1_.Offer,false,true);
         this._selfLevel.mouseChildren = false;
         this._selfLevel.mouseEnabled = false;
         if(_loc1_.IsVIP)
         {
            this._selfVipName = VipController.instance.getVipNameTxt(84,_loc1_.typeVIP);
            this._selfVipName.textSize = 14;
            this._selfVipName.x = 16;
            this._selfVipName.y = 303;
            this._selfVipName.text = _loc1_.NickName;
            addToContent(this._selfVipName);
         }
         else
         {
            this._selfName = ComponentFactory.Instance.creatComponentByStylename("chatFrame.selfName");
            this._selfName.text = _loc1_.NickName;
            addToContent(this._selfName);
         }
         this._targetLevelT.text = LanguageMgr.GetTranslation("IM.ChatFrame.level");
         this._targetLevel.setSize(LevelIcon.SIZE_SMALL);
         this._targetLevel.mouseChildren = false;
         this._targetLevel.mouseEnabled = false;
         this._warningWord.text = LanguageMgr.GetTranslation("IM.ChatFrame.warning");
      }
      
      public function set playerInfo(param1:PlayerInfo) : void
      {
         if(this._info != param1)
         {
            this._input.text = "";
            this._output.htmlText = "";
            this.closeRecordFrame();
         }
         this._info = param1;
         this._targetProtrait.info = this._info;
         this._targetLevel.setInfo(this._info.Grade,this._info.Repute,this._info.WinCount,this._info.TotalCount,this._info.FightPower,this._info.Offer,false,true);
         if(this._info.IsVIP)
         {
            if(this._targetVipName == null)
            {
               this._targetVipName = VipController.instance.getVipNameTxt(84,this._info.typeVIP);
               this._targetVipName.textSize = 14;
               this._targetVipName.x = 16;
               this._targetVipName.y = 136;
               addToContent(this._targetVipName);
            }
            if(this._targetName)
            {
               this._targetName.visible = false;
            }
            this._targetVipName.visible = true;
            this._targetVipName.text = this._info.NickName;
         }
         else
         {
            if(this._targetName == null)
            {
               this._targetName = ComponentFactory.Instance.creatComponentByStylename("chatFrame.targetName");
               addToContent(this._targetName);
            }
            if(this._targetVipName)
            {
               this._targetVipName.visible = false;
            }
            this._targetName.visible = true;
            this._targetName.text = this._info.NickName;
         }
      }
      
      public function clearOutput() : void
      {
         this._output.htmlText = "";
      }
      
      public function addMessage(param1:String) : void
      {
         this._output.htmlText += param1 + "<br/>";
         this._output.textField.setSelection(this._output.text.length - 1,this._output.text.length - 1);
         this._output.upScrollArea();
      }
      
      public function addAllMessage(param1:Vector.<String>) : void
      {
         this._output.htmlText = "";
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            this._output.htmlText += param1[_loc2_] + "<br/>";
            _loc2_++;
         }
         this._output.textField.setSelection(this._output.text.length - 1,this._output.text.length - 1);
         this._output.upScrollArea();
      }
      
      public function get playerInfo() : PlayerInfo
      {
         return this._info;
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._send.addEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._record.addEventListener(MouseEvent.CLICK,this.__recordHandler);
         this._input.addEventListener(KeyboardEvent.KEY_UP,this.__keyUpHandler);
         this._input.addEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._input.addEventListener(FocusEvent.FOCUS_IN,this.__focusInHandler);
         this._input.addEventListener(FocusEvent.FOCUS_OUT,this.__focusOutHandler);
         addEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         this._send.removeEventListener(MouseEvent.CLICK,this.__sendHandler);
         this._record.removeEventListener(MouseEvent.CLICK,this.__recordHandler);
         this._input.removeEventListener(KeyboardEvent.KEY_UP,this.__keyUpHandler);
         this._input.removeEventListener(KeyboardEvent.KEY_DOWN,this.__keyDownHandler);
         this._input.removeEventListener(FocusEvent.FOCUS_IN,this.__focusInHandler);
         this._input.removeEventListener(FocusEvent.FOCUS_OUT,this.__focusOutHandler);
         removeEventListener(Event.ADDED_TO_STAGE,this.__addToStageHandler);
      }
      
      private function __keyDownHandler(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
      }
      
      protected function __addToStageHandler(param1:Event) : void
      {
         this._input.textField.setFocus();
      }
      
      protected function __focusOutHandler(param1:FocusEvent) : void
      {
         IMController.Instance.privateChatFocus = false;
      }
      
      protected function __focusInHandler(param1:FocusEvent) : void
      {
         IMController.Instance.privateChatFocus = true;
      }
      
      protected function __keyUpHandler(param1:KeyboardEvent) : void
      {
         param1.stopImmediatePropagation();
         param1.stopPropagation();
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.__sendHandler(null);
         }
      }
      
      protected function __recordHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._recordFrame == null)
         {
            this._recordFrame = ComponentFactory.Instance.creatComponentByStylename("privateRecordFrame");
            this._recordFrame.addEventListener(FrameEvent.RESPONSE,this.__recordResponseHandler);
            this._recordFrame.addEventListener(PrivateRecordFrame.CLOSE,this.__recordCloseHandler);
            PositionUtils.setPos(this._recordFrame,"recordFrame.pos");
         }
         if(!this._show)
         {
            addToContent(this._recordFrame);
            this._recordFrame.playerId = this._info.ID;
            this._show = true;
         }
         else
         {
            this.closeRecordFrame();
         }
      }
      
      private function closeRecordFrame() : void
      {
         if(this._recordFrame && this._recordFrame.parent)
         {
            this._recordFrame.parent.removeChild(this._recordFrame);
         }
         this._show = false;
      }
      
      protected function __recordCloseHandler(param1:Event) : void
      {
         SoundManager.instance.play("008");
         this._recordFrame.parent.removeChild(this._recordFrame);
         this._show = false;
      }
      
      protected function __recordResponseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK)
         {
            SoundManager.instance.play("008");
            this._recordFrame.parent.removeChild(this._recordFrame);
            this._show = false;
         }
      }
      
      protected function __sendHandler(param1:MouseEvent) : void
      {
         var _loc2_:String = null;
         SoundManager.instance.play("008");
         if(this._info.Grade < 5)
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.other.noEnough.five"));
            return;
         }
         if(StringHelper.trim(this._input.text) != "")
         {
            _loc2_ = this._input.text.replace(/</g,"&lt;").replace(/>/g,"&gt;");
            _loc2_ = FilterWordManager.filterWrod(_loc2_);
            SocketManager.Instance.out.sendOneOnOneTalk(this._info.ID,_loc2_);
            this._input.text = "";
         }
         else
         {
            this._input.text = "";
         }
         this.__addToStageHandler(null);
      }
      
      private function checkHtmlTag(param1:String) : Boolean
      {
         if(param1.indexOf("<") != -1 || FilterWordManager.isGotForbiddenWords(param1))
         {
            MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("IM.privateChatFrame.failWord"));
            return false;
         }
         return true;
      }
      
      protected function __responseHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               IMController.Instance.disposePrivateFrame(this._info.ID);
               this._output.htmlText = "";
               break;
            case FrameEvent.MINIMIZE_CLICK:
               IMController.Instance.hidePrivateFrame(this._info.ID);
         }
      }
      
      override public function dispose() : void
      {
         IMController.Instance.privateChatFocus = false;
         this.removeEvent();
         super.dispose();
         if(this._recordFrame)
         {
            this._recordFrame.removeEventListener(FrameEvent.RESPONSE,this.__recordResponseHandler);
            this._recordFrame.removeEventListener(PrivateRecordFrame.CLOSE,this.__recordCloseHandler);
            this._recordFrame.dispose();
            this._recordFrame = null;
         }
         this._info = null;
         if(this._outputBG)
         {
            ObjectUtils.disposeObject(this._outputBG);
         }
         this._outputBG = null;
         if(this._inputBG)
         {
            ObjectUtils.disposeObject(this._inputBG);
         }
         this._inputBG = null;
         if(this._output)
         {
            ObjectUtils.disposeObject(this._output);
         }
         this._output = null;
         if(this._input)
         {
            ObjectUtils.disposeObject(this._input);
         }
         this._input = null;
         if(this._send)
         {
            ObjectUtils.disposeObject(this._send);
         }
         this._send = null;
         if(this._record)
         {
            ObjectUtils.disposeObject(this._record);
         }
         this._record = null;
         if(this._selfPortrait)
         {
            ObjectUtils.disposeObject(this._selfPortrait);
         }
         this._selfPortrait = null;
         if(this._selfLevelT)
         {
            ObjectUtils.disposeObject(this._selfLevelT);
         }
         this._selfLevelT = null;
         if(this._selfLevel)
         {
            ObjectUtils.disposeObject(this._selfLevel);
         }
         this._selfLevel = null;
         if(this._selfName)
         {
            ObjectUtils.disposeObject(this._selfName);
         }
         this._selfName = null;
         if(this._selfVipName)
         {
            ObjectUtils.disposeObject(this._selfVipName);
         }
         this._selfVipName = null;
         if(this._targetProtrait)
         {
            ObjectUtils.disposeObject(this._targetProtrait);
         }
         this._targetProtrait = null;
         if(this._targetLevelT)
         {
            ObjectUtils.disposeObject(this._targetLevelT);
         }
         this._targetLevelT = null;
         if(this._targetLevel)
         {
            ObjectUtils.disposeObject(this._targetLevel);
         }
         this._targetLevel = null;
         if(this._targetName)
         {
            ObjectUtils.disposeObject(this._targetName);
         }
         this._targetName = null;
         if(this._targetVipName)
         {
            ObjectUtils.disposeObject(this._targetVipName);
         }
         this._targetVipName = null;
         if(this._warningBg)
         {
            ObjectUtils.disposeObject(this._warningBg);
         }
         this._warningBg = null;
         if(this._warning)
         {
            ObjectUtils.disposeObject(this._warning);
         }
         this._warning = null;
         if(this._warningWord)
         {
            ObjectUtils.disposeObject(this._warningWord);
         }
         this._warningWord = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
