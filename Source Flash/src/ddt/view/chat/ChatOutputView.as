package ddt.view.chat
{
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import ddt.manager.ChatManager;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import pet.sprite.PetSpriteController;
   
   public class ChatOutputView extends Sprite
   {
      
      public static const CHAT_OUPUT_CLUB:int = 1;
      
      public static const CHAT_OUPUT_CURRENT:int = 0;
      
      public static const CHAT_OUPUT_PRIVATE:int = 2;
      
      private static const IN_GAME:uint = 3;
       
      
      private var _bg:ScaleFrameImage;
      
      private var _consortiaBtn:SelectedButton;
      
      private var _currentBtn:SelectedButton;
      
      private var _privateBtn:SelectedButton;
      
      private var _petSpriteSwitcher:SelectedButton;
      
      private var _channel:int = -1;
      
      private var _clearBtn:BaseButton;
      
      private var _currentOffset:int = 0;
      
      private var _goBottomBtn:BaseButton;
      
      private var _isLocked:Boolean = false;
      
      private var _leftBtnContainer:Sprite;
      
      private var _lockBtn:SelectedButton;
      
      private var _model:ChatModel;
      
      private var _outputField:ChatOutputField;
      
      private var _rightBtnContainer:Sprite;
      
      private var _scrollDownBtn:BaseButton;
      
      private var _scrollUpBtn:BaseButton;
      
      private var _goBottomBtnEffect:IEffect;
      
      private var _privateBtnEffect:IEffect;
      
      private var _group:SelectedButtonGroup;
      
      private var _hotAreaInGame:Sprite;
      
      private var _functionEnabled:Boolean;
      
      private var _leftBtnContainerInGame:Sprite;
      
      private var _functionBtnInGame:SelectedButton;
      
      private var _lockBtnInGame:SelectedButton;
      
      private var _scrollUpBtnInGame:SimpleBitmapButton;
      
      private var _scrollDownBtnInGame:SimpleBitmapButton;
      
      private var _goBottomBtnInGame:SimpleBitmapButton;
      
      private var _clearBtnInGame:SimpleBitmapButton;
      
      private var _goBottomEffectInGame:IEffect;
      
      private var _more:SelectedButton;
      
      private var _leftScroll:ChatScrollBar;
      
      private var _ghostState:Boolean;
      
      public function ChatOutputView()
      {
         super();
         this.init();
      }
      
      public function set enableGameState(param1:Boolean) : void
      {
         if(param1)
         {
            if(this._more.selected)
            {
               this._more.selected = false;
               this.updateOutputViewState();
               this.bg = 3;
            }
            this._outputField.x = 25;
            this._outputField.y = 39;
            graphics.beginFill(16777215,0);
            graphics.drawRect(-10,-10,300,120);
            graphics.endFill();
            this.isLock = false;
            addChild(this._leftBtnContainerInGame);
            if(contains(this._leftBtnContainer))
            {
               removeChild(this._leftBtnContainer);
            }
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
            addEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollOver);
            addEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollOut);
         }
         else
         {
            this._ghostState = false;
            this._outputField.x = 32;
            this._outputField.y = 10;
            if(contains(this._leftBtnContainerInGame))
            {
               removeChild(this._leftBtnContainerInGame);
            }
            addChild(this._leftBtnContainer);
            addChildAt(this._bg,0);
            graphics.clear();
            removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollOut);
         }
      }
      
      public function set functionEnabled(param1:Boolean) : void
      {
         if(ChatManager.Instance.view.parent)
         {
            ChatManager.Instance.view.parent.addChild(ChatManager.Instance.view);
         }
         if(!this.isInGame())
         {
            return;
         }
         this._functionEnabled = param1;
         this._outputField.functionEnabled = this._functionEnabled;
         if(this._functionEnabled)
         {
            this._functionBtnInGame.selected = true;
            this._leftBtnContainerInGame.addChild(this._functionBtnInGame);
            this._leftBtnContainerInGame.addChild(this._clearBtnInGame);
            addChildAt(this._bg,0);
            this._outputField.functionEnabled = this._functionEnabled;
            this.updateShine();
         }
         else
         {
            this._functionBtnInGame.selected = false;
            if(this._leftBtnContainerInGame.contains(this._functionBtnInGame))
            {
               this._leftBtnContainerInGame.removeChild(this._functionBtnInGame);
            }
            if(this._leftBtnContainerInGame.contains(this._clearBtnInGame))
            {
               this._leftBtnContainerInGame.removeChild(this._clearBtnInGame);
            }
            if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
         }
      }
      
      public function set ghostState(param1:Boolean) : void
      {
         this._ghostState = param1;
         if(this._ghostState)
         {
            graphics.clear();
            removeEventListener(MouseEvent.ROLL_OVER,this.__onMouseRollOver);
            removeEventListener(MouseEvent.ROLL_OUT,this.__onMouseRollOut);
            if(parent)
            {
               parent.mouseEnabled = false;
            }
            mouseEnabled = false;
         }
      }
      
      private function __onMouseRollOver(param1:MouseEvent) : void
      {
         if(ChatManager.Instance.view.parent)
         {
            ChatManager.Instance.view.parent.addChild(ChatManager.Instance.view);
         }
         this._leftBtnContainerInGame.addChild(this._functionBtnInGame);
         this._leftBtnContainerInGame.addChild(this._clearBtnInGame);
         addChildAt(this._bg,0);
         if(parent)
         {
            parent.mouseEnabled = true;
         }
         mouseEnabled = true;
      }
      
      private function __onMouseRollOut(param1:MouseEvent) : void
      {
         if(ChatManager.Instance.view.input.parent)
         {
            return;
         }
         if(this._leftBtnContainerInGame.contains(this._functionBtnInGame))
         {
            this._leftBtnContainerInGame.removeChild(this._functionBtnInGame);
         }
         if(this._leftBtnContainerInGame.contains(this._clearBtnInGame))
         {
            this._leftBtnContainerInGame.removeChild(this._clearBtnInGame);
         }
         if(this._bg.parent)
         {
            this._bg.parent.removeChild(this._bg);
         }
         StageReferance.stage.focus = null;
      }
      
      public function set bg(param1:int) : void
      {
         if(!isNaN(param1))
         {
            this._bg.setFrame(param1);
         }
         if(this.isInGame())
         {
            if(this._rightBtnContainer.parent)
            {
               this._rightBtnContainer.parent.removeChild(this._rightBtnContainer);
            }
         }
         else
         {
            addChild(this._rightBtnContainer);
         }
      }
      
      public function set channel(param1:int) : void
      {
         if(param1 < 0 || param1 > 2)
         {
            return;
         }
         if(this._channel == param1)
         {
            return;
         }
         this._channel = param1;
         this.updateCurrnetChannel();
      }
      
      public function get contentField() : ChatOutputField
      {
         return this._outputField;
      }
      
      public function get currentOffset() : int
      {
         return this._currentOffset;
      }
      
      public function set currentOffset(param1:int) : void
      {
         this._currentOffset = param1;
         this.updateCurrnetChannel();
      }
      
      public function goBottom() : void
      {
         this._outputField.toBottom();
      }
      
      public function get isLock() : Boolean
      {
         return this._isLocked;
      }
      
      public function set isLock(param1:Boolean) : void
      {
         if(this._isLocked == param1)
         {
            return;
         }
         this._isLocked = param1;
         this._lockBtnInGame.selected = this._lockBtn.selected = this._isLocked;
         this._outputField.mouseEnabled = !this._isLocked;
         this._outputField.mouseChildren = !this._isLocked;
         if(!this.isInGame())
         {
            if(parent)
            {
               parent.mouseEnabled = !param1;
            }
            mouseEnabled = !param1;
         }
         else if(!this._ghostState)
         {
            if(parent)
            {
               parent.mouseEnabled = true;
            }
            mouseEnabled = true;
         }
         this.setChannelBtnVisible(!param1);
         this.setBgVisible(!param1);
         this.setLockBtnTipData(this._isLocked);
      }
      
      public function setLockBtnTipData(param1:Boolean) : void
      {
         if(param1)
         {
            this._lockBtn.tipData = LanguageMgr.GetTranslation("chat.UnLock");
         }
         else
         {
            this._lockBtn.tipData = LanguageMgr.GetTranslation("chat.Lock");
         }
         this._lockBtnInGame.tipData = this._lockBtn.tipData;
         ShowTipManager.Instance.hideTip(this._lockBtn);
         ShowTipManager.Instance.hideTip(this._lockBtnInGame);
      }
      
      public function set lockEnable(param1:Boolean) : void
      {
         this._lockBtnInGame.enable = this._lockBtn.enable = param1;
      }
      
      public function setBgVisible(param1:Boolean) : void
      {
         if(!this.isInGame())
         {
            if(param1)
            {
               addChildAt(this._bg,0);
            }
            else if(this._bg.parent)
            {
               this._bg.parent.removeChild(this._bg);
            }
         }
      }
      
      public function setChannelBtnVisible(param1:Boolean) : void
      {
         if(!this.isInGame())
         {
            if(param1)
            {
               addChild(this._rightBtnContainer);
            }
            else if(this._rightBtnContainer.parent)
            {
               this._rightBtnContainer.parent.removeChild(this._rightBtnContainer);
            }
         }
      }
      
      private function __leftBtnsClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._lockBtn:
            case this._lockBtnInGame:
               this.isLock = !this.isLock;
               this.setLockBtnTipData(this.isLock);
               if(this._lockBtn.parent != null && !this.isInGame())
               {
                  ShowTipManager.Instance.showTip(this._lockBtn);
               }
               if(this.isInGame() && this._lockBtnInGame.parent != null)
               {
                  ShowTipManager.Instance.showTip(this._lockBtnInGame);
               }
               if(!this._isLocked && !this.isInGame())
               {
                  addChild(this._rightBtnContainer);
               }
               else if(this._rightBtnContainer.parent)
               {
                  this._rightBtnContainer.parent.removeChild(this._rightBtnContainer);
               }
               break;
            case this._clearBtn:
            case this._clearBtnInGame:
               this._model.reset();
               this.updateCurrnetChannel();
               this._privateBtnEffect.stop();
               break;
            case this._goBottomBtn:
            case this._goBottomBtnInGame:
               this._currentOffset = 0;
               this.updateCurrnetChannel();
         }
      }
      
      private function __onAddChat(param1:ChatEvent) : void
      {
         var _loc2_:ChatData = param1.data as ChatData;
         if(_loc2_.channel == ChatInputView.PRIVATE && _loc2_.sender != PlayerManager.Instance.Self.NickName && this._channel != CHAT_OUPUT_PRIVATE && this._channel != CHAT_OUPUT_CURRENT)
         {
            this._privateBtnEffect.play();
         }
         if(this._model.getInputInOutputChannel(_loc2_.channel,this._channel))
         {
            if(this._currentOffset == 0)
            {
               this.updateCurrnetChannel();
            }
         }
      }
      
      private function __onMouseWheel(param1:MouseEvent) : void
      {
         if(param1.delta > 0)
         {
            ++this._currentOffset;
         }
         else if(this._currentOffset > 0)
         {
            --this._currentOffset;
         }
         this.updateCurrnetChannel();
      }
      
      private function __onScroll(param1:Event = null) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._scrollDownBtn:
            case this._scrollDownBtnInGame:
               if(this._currentOffset > 0)
               {
                  --this._currentOffset;
               }
               break;
            case this._scrollUpBtn:
            case this._scrollUpBtnInGame:
               ++this._currentOffset;
         }
         this.updateCurrnetChannel();
      }
      
      private function __textFieldBindScroll(param1:int = 0) : void
      {
         if(this._currentOffset == param1)
         {
            return;
         }
         this._currentOffset = param1;
         this.updateCurrnetChannel();
      }
      
      private function __rightBtnsSelected(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.currentTarget)
         {
            case this._privateBtn:
               this.channel = CHAT_OUPUT_PRIVATE;
               this._privateBtnEffect.stop();
               break;
            case this._consortiaBtn:
               this.channel = CHAT_OUPUT_CLUB;
               ChatManager.Instance.inputChannel = ChatInputView.CONSORTIA;
               break;
            case this._currentBtn:
               this.channel = CHAT_OUPUT_CURRENT;
               ChatManager.Instance.inputChannel = ChatInputView.CURRENT;
         }
      }
      
      private function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("chat.OutputBg");
         this._outputField = ComponentFactory.Instance.creatCustomObject("chat.OutputField");
         this._model = new ChatModel();
         this._bg.setFrame(1);
         addChild(this._bg);
         addChild(this._outputField);
         this._model = ChatManager.Instance.model;
         this.initBtns();
         this.initEvent();
      }
      
      private function initBtns() : void
      {
         this._group = new SelectedButtonGroup();
         this._leftBtnContainer = ComponentFactory.Instance.creatCustomObject("chat.OutputViewLeftBtnContainer");
         this._leftBtnContainerInGame = ComponentFactory.Instance.creatCustomObject("chat.OutputViewLeftBtnContainerInGame");
         this._rightBtnContainer = ComponentFactory.Instance.creatCustomObject("chat.OutputViewRightBtnContainer");
         this._lockBtn = ComponentFactory.Instance.creatComponentByStylename("chat.LockBtn");
         this._clearBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ClearBtn");
         this._scrollUpBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ScrollUpBtn");
         this._scrollDownBtn = ComponentFactory.Instance.creatComponentByStylename("chat.ScrollDownBtn");
         this._goBottomBtn = ComponentFactory.Instance.creatComponentByStylename("chat.GoBottomBtn");
         this._functionBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.FunctionBtnInGame");
         this._lockBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.LockBtnInGame");
         this._clearBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.ClearBtnInGame");
         this._scrollUpBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.ScrollUpBtnInGame");
         this._scrollDownBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.ScrollDownBtnInGame");
         this._goBottomBtnInGame = ComponentFactory.Instance.creatComponentByStylename("chat.GoBottomBtnInGame");
         this._currentBtn = ComponentFactory.Instance.creat("chat.CurrentBtn");
         this._consortiaBtn = ComponentFactory.Instance.creat("chat.ConsortiaBtn");
         this._privateBtn = ComponentFactory.Instance.creat("chat.PrivateBtn");
		 this._petSpriteSwitcher = ComponentFactory.Instance.creatComponentByStylename("chat.PetSpriteSwitcher");
		 this._petSpriteSwitcher.selected = false;
		 this._petSpriteSwitcher.enable = false;
         this._more = ComponentFactory.Instance.creatComponentByStylename("chat.MoreSwitcher");
         this._more.selected = false;
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("chat.OriginPos");
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("chat.PrivateBtnEffectPos");
         this._goBottomBtnEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goBottomBtn,"asset.chat.GoBottomBtn","chat.ChatGoBottomShineEffect");
         this._privateBtnEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._privateBtn,"asset.chat.PrivateBtn_01","chat.ChatPrivateShineEffect",_loc1_,_loc2_);
         this._goBottomEffectInGame = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._goBottomBtnInGame,"asset.chat.GoBottomBtnInGame","chat.ChatGoBottomShineEffectInGame");
         this._functionEnabled = false;
         this._scrollUpBtnInGame.pressEnable = this._scrollDownBtnInGame.pressEnable = this._scrollUpBtn.pressEnable = this._scrollDownBtn.pressEnable = true;
         this._lockBtnInGame.tipData = this._lockBtn.tipData = LanguageMgr.GetTranslation("chat.Lock");
         this._clearBtnInGame.tipData = this._clearBtn.tipData = LanguageMgr.GetTranslation("chat.Clear");
         this._scrollUpBtnInGame.tipData = this._scrollUpBtn.tipData = LanguageMgr.GetTranslation("chat.ScrollUp");
         this._scrollDownBtnInGame.tipData = this._scrollDownBtn.tipData = LanguageMgr.GetTranslation("chat.ScrollDown");
         this._goBottomBtnInGame.tipData = this._goBottomBtn.tipData = LanguageMgr.GetTranslation("chat.Bottom");
         this._functionBtnInGame.tipData = LanguageMgr.GetTranslation("chat.Function");
         this._leftScroll = new ChatScrollBar(this.__textFieldBindScroll);
         this._leftScroll.Height = 220;
         this._leftScroll.x = 4;
         this._leftScroll.y = 66;
         this._leftBtnContainer.addChild(this._lockBtn);
         this._leftBtnContainer.addChild(this._clearBtn);
         this._leftBtnContainer.addChild(this._scrollUpBtn);
         this._leftBtnContainer.addChild(this._scrollDownBtn);
         this._leftBtnContainer.addChild(this._goBottomBtn);
         this._leftBtnContainer.addChild(this._leftScroll);
         this._leftBtnContainerInGame.addChild(this._lockBtnInGame);
         this._leftBtnContainerInGame.addChild(this._scrollUpBtnInGame);
         this._leftBtnContainerInGame.addChild(this._scrollDownBtnInGame);
         this._leftBtnContainerInGame.addChild(this._goBottomBtnInGame);
         this._group.addSelectItem(this._currentBtn);
         this._group.addSelectItem(this._consortiaBtn);
         this._group.addSelectItem(this._privateBtn);
         this._rightBtnContainer.addChild(this._currentBtn);
         this._rightBtnContainer.addChild(this._consortiaBtn);
         this._rightBtnContainer.addChild(this._privateBtn);
         this._rightBtnContainer.addChild(this._more);
		 this._rightBtnContainer.addChild(this._petSpriteSwitcher);
         addChild(this._leftBtnContainer);
      }
      
      public function moreState(param1:Boolean) : void
      {
         if(param1 == this._more.selected)
         {
            return;
         }
         this._more.selected = param1;
         this.updateOutputViewState();
      }
      
      public function openPetSprite(param1:Boolean) : void
      {
         this._petSpriteSwitcher.selected = param1;
      }
      
      public function enablePetSpriteSwitcher(param1:Boolean) : void
      {
         this._petSpriteSwitcher.enable = param1;
      }
      
      public function PetSpriteSwitchVisible(param1:Boolean) : void
      {
         this._petSpriteSwitcher.visible = param1;
      }
      
      private function initEvent() : void
      {
         this._model.addEventListener(ChatEvent.ADD_CHAT,this.__onAddChat);
         this._outputField.addEventListener(MouseEvent.MOUSE_WHEEL,this.__onMouseWheel);
         this._lockBtn.addEventListener(MouseEvent.CLICK,this.__leftBtnsClick);
         this._clearBtn.addEventListener(MouseEvent.CLICK,this.__leftBtnsClick);
         this._goBottomBtn.addEventListener(MouseEvent.CLICK,this.__leftBtnsClick);
         this._lockBtnInGame.addEventListener(MouseEvent.CLICK,this.__leftBtnsClick);
         this._clearBtnInGame.addEventListener(MouseEvent.CLICK,this.__leftBtnsClick);
         this._goBottomBtnInGame.addEventListener(MouseEvent.CLICK,this.__leftBtnsClick);
         this._scrollUpBtn.addEventListener(Event.CHANGE,this.__onScroll);
         this._scrollDownBtn.addEventListener(Event.CHANGE,this.__onScroll);
         this._scrollUpBtnInGame.addEventListener(Event.CHANGE,this.__onScroll);
         this._scrollDownBtnInGame.addEventListener(Event.CHANGE,this.__onScroll);
         this._privateBtn.addEventListener(MouseEvent.CLICK,this.__rightBtnsSelected);
         this._consortiaBtn.addEventListener(MouseEvent.CLICK,this.__rightBtnsSelected);
         this._currentBtn.addEventListener(MouseEvent.CLICK,this.__rightBtnsSelected);
         this._petSpriteSwitcher.addEventListener(MouseEvent.CLICK,this.__switchPetSprite);
         this._functionBtnInGame.addEventListener(MouseEvent.CLICK,this.__functionSwitch);
         PetSpriteController.Instance.addEventListener(Event.CLOSE,this.petSpriteClose);
         PetSpriteController.Instance.addEventListener(Event.OPEN,this.petSpriteOpen);
         this._more.addEventListener(MouseEvent.CLICK,this.__moreSwitcherClick);
      }
      
      private function __moreSwitcherClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this.updateOutputViewState();
      }
      
      private function updateOutputViewState() : void
      {
         if(this._more.selected)
         {
            this.bg = 6;
            PositionUtils.setPos(this._bg,"chat.Bg.more");
            PositionUtils.setPos(this._leftBtnContainer,"chat.LeftBtnContainer.more");
            PositionUtils.setPos(this._rightBtnContainer,"chat.RightBtnContainer.more");
            PositionUtils.setPos(this._outputField,"chat.outputField.more");
            PositionUtils.setPos(this._scrollDownBtn,"chat.scrollDownBtn.more");
            PositionUtils.setPos(this._goBottomBtn,"chat.GotoBottomBtn.more");
            this._outputField.contentHeight = 340;
            this._leftScroll.visible = true;
            if(PetSpriteController.Instance.petSprite)
            {
               PositionUtils.setPos(PetSpriteController.Instance.petSprite,"chat.PetSprite.more");
               PetSpriteController.Instance.petSprite.petSpriteLand.y = PetSpriteController.Instance.petSprite.y + 59;
            }
         }
         else
         {
            this.bg = 2;
            PositionUtils.setPos(this._bg,"chat.Bg.lessen");
            PositionUtils.setPos(this._leftBtnContainer,"chat.LeftBtnContainer.lessen");
            PositionUtils.setPos(this._rightBtnContainer,"chat.RightBtnContainer.lessen");
            PositionUtils.setPos(this._outputField,"chat.outputField.lessen");
            PositionUtils.setPos(this._scrollDownBtn,"chat.scrollDownBtn.less");
            PositionUtils.setPos(this._goBottomBtn,"chat.GotoBottomBtn.less");
            this._outputField.contentHeight = 118;
            this._leftScroll.visible = false;
            if(PetSpriteController.Instance.petSprite)
            {
               PositionUtils.setPos(PetSpriteController.Instance.petSprite,"chat.PetSprite.lessen");
               if(PetSpriteController.Instance.petSprite.petSpriteLand)
               {
                  PetSpriteController.Instance.petSprite.petSpriteLand.y = PetSpriteController.Instance.petSprite.y + 65;
               }
            }
         }
         if(ChatManager.Instance.state == ChatManager.CHAT_GAME_LOADING)
         {
            this.bg = 3;
            this._bg.visible = false;
            this._rightBtnContainer.visible = false;
         }
         else
         {
            this._bg.visible = true;
            this._rightBtnContainer.visible = true;
         }
         this.updateCurrnetChannel();
      }
      
      protected function __switchPetSprite(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PetSpriteController.Instance.switchPetSprite(this._petSpriteSwitcher.selected);
         PositionUtils.setPos(PetSpriteController.Instance.petSprite,!!this._more.selected ? "chat.PetSprite.more" : "chat.PetSprite.lessen");
      }
      
      private function petSpriteClose(param1:Event) : void
      {
         this._petSpriteSwitcher.selected = false;
         PetSpriteController.Instance.switchPetSprite(this._petSpriteSwitcher.selected);
      }
      
      private function petSpriteOpen(param1:Event) : void
      {
         this._petSpriteSwitcher.selected = true;
         PetSpriteController.Instance.switchPetSprite(this._petSpriteSwitcher.selected);
      }
      
      private function __functionSwitch(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         ChatManager.Instance.switchVisible();
      }
      
      public function isInGame() : Boolean
      {
         return this._bg.getFrame == IN_GAME;
      }
      
      public function updateCurrnetChannel() : void
      {
         var _loc1_:Object = null;
         if(this.isInGame())
         {
            _loc1_ = this._model.getChatsByOutputChannel(this._channel,this._currentOffset,5);
         }
         else
         {
            _loc1_ = this._model.getChatsByOutputChannel(this._channel,this._currentOffset,!!this._more.selected ? int(int(16)) : int(int(6)));
            this._leftScroll.length = this._model.getRowsByOutputChangel(this._channel);
            this._leftScroll.currentIndex = this._currentOffset;
         }
         this._currentOffset = _loc1_["offset"];
         this._outputField.setChats(_loc1_["result"]);
         this.goBottom();
         this.updateShine();
         this._privateBtn.selected = this._consortiaBtn.selected = this._currentBtn.selected = false;
         this._privateBtn.selected = this._channel == CHAT_OUPUT_PRIVATE;
         this._consortiaBtn.selected = this._channel == CHAT_OUPUT_CLUB;
         this._currentBtn.selected = this._channel == CHAT_OUPUT_CURRENT;
      }
      
      private function updateShine() : void
      {
         if(this._currentOffset != 0)
         {
            this._goBottomBtnEffect.play();
         }
         else
         {
            this._goBottomBtnEffect.stop();
         }
         if(this._currentOffset != 0)
         {
            this._goBottomEffectInGame.play();
         }
         else
         {
            this._goBottomEffectInGame.stop();
         }
      }
   }
}
