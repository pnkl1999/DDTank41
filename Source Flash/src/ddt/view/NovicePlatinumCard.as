package ddt.view
{
   import activeEvents.ActiveEventsManager;
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLVariables;
   
   public class NovicePlatinumCard extends Frame
   {
       
      
      private var _bg:ScaleBitmapImage;
      
      private var _activityCardPSWII:Bitmap;
      
      private var _divisionLine:Bitmap;
      
      private var _iconGive:Bitmap;
      
      private var _textInput:TextInput;
      
      private var _awardTxt:FilterFrameText;
      
      private var _activeGetBtn:TextButton;
      
      private var _activeCloseBtn:TextButton;
      
      private var _activeEventsInfo:ActiveEventsInfo;
      
      public function NovicePlatinumCard()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         this.titleText = LanguageMgr.GetTranslation("ddt.view.NovicePlatinumCard.titleText");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("core.activeEventsBg");
         this.addToContent(this._bg);
         this._activityCardPSWII = ComponentFactory.Instance.creatBitmap("asset.core.NovicePlatinumCard.activityCardPSWII");
         this.addToContent(this._activityCardPSWII);
         this._divisionLine = ComponentFactory.Instance.creatBitmap("asset.core.NovicePlatinumCard.divisionLine");
         this.addToContent(this._divisionLine);
         this._iconGive = ComponentFactory.Instance.creatBitmap("asset.core.NovicePlatinumCard.iconGive");
         this.addToContent(this._iconGive);
         this._textInput = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.textInput");
         this.addToContent(this._textInput);
         this._awardTxt = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.awardTxt");
         this.addToContent(this._awardTxt);
         this._activeGetBtn = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.activeGetBtn");
         this._activeGetBtn.text = LanguageMgr.GetTranslation("get");
         this._activeGetBtn.enable = false;
         this.addToContent(this._activeGetBtn);
         this._activeCloseBtn = ComponentFactory.Instance.creatComponentByStylename("core.NovicePlatinumCard.activeCloseBtn");
         this._activeCloseBtn.text = LanguageMgr.GetTranslation("cancel");
         this.addToContent(this._activeCloseBtn);
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput.addEventListener(TextEvent.TEXT_INPUT,this.__input);
         this._textInput.addEventListener(Event.CHANGE,this.__onChange);
         this._textInput.addEventListener(KeyboardEvent.KEY_DOWN,this.__textInputKeyDown);
         this._activeGetBtn.addEventListener(MouseEvent.CLICK,this.__activeGetBtnClick);
         this._activeCloseBtn.addEventListener(MouseEvent.CLICK,this.__activeCloseBtnClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.ACTIVE_PULLDOWN,this.__activeSocket);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__frameEventHandler);
         this._textInput.removeEventListener(TextEvent.TEXT_INPUT,this.__input);
         this._textInput.removeEventListener(Event.CHANGE,this.__onChange);
         this._textInput.removeEventListener(KeyboardEvent.KEY_DOWN,this.__textInputKeyDown);
         this._activeGetBtn.removeEventListener(MouseEvent.CLICK,this.__activeGetBtnClick);
         this._activeCloseBtn.removeEventListener(MouseEvent.CLICK,this.__activeCloseBtnClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.ACTIVE_PULLDOWN,this.__activeSocket);
      }
      
      protected function __activeSocket(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:Boolean = param1.pkg.readBoolean();
         if(_loc2_)
         {
            this.dispose();
         }
         else
         {
            this._activeGetBtn.enable = true;
         }
      }
      
      private function __input(param1:TextEvent) : void
      {
         if(this._textInput.text.length + param1.text.length > 50)
         {
            param1.preventDefault();
         }
      }
      
      private function __onChange(param1:Event) : void
      {
         if(this._textInput.text != "")
         {
            this._activeGetBtn.enable = true;
         }
         else
         {
            this._activeGetBtn.enable = false;
         }
      }
      
      protected function __textInputKeyDown(param1:KeyboardEvent) : void
      {
         if(this._activeGetBtn.enable && param1.keyCode == 13)
         {
            this.__activeGetBtnClick();
         }
      }
      
      protected function __activeGetBtnClick(param1:MouseEvent = null) : void
      {
         var _loc2_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._textInput.text == "")
         {
            _loc2_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
            _loc2_.info.showCancel = false;
            return;
         }
         this._activeGetBtn.enable = false;
         SocketManager.Instance.out.sendActivePullDown(this._activeEventsInfo.ActiveID,this._textInput.text);
      }
      
      public function setup() : void
      {
         var _loc3_:URLVariables = null;
         var _loc4_:BaseLoader = null;
         var _loc1_:Array = ActiveEventsManager.Instance.model.list;
         if(_loc1_ == null)
         {
            this.dispose();
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_].Type == 10)
            {
               this._activeEventsInfo = _loc1_[_loc2_] as ActiveEventsInfo;
            }
            _loc2_++;
         }
         if(this._activeEventsInfo)
         {
            _loc3_ = RequestVairableCreater.creatWidthKey(true);
            _loc4_ = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("UserGetActiveState.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
            _loc4_.addEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
            _loc4_.addEventListener(LoaderEvent.LOAD_ERROR,this.__loadError);
            LoaderManager.Instance.startLoad(_loc4_);
         }
         else
         {
            this.dispose();
         }
      }
      
      protected function __loadComplete(param1:LoaderEvent) : void
      {
         param1.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         param1.currentTarget.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loadError);
         if(param1.loader.content == "True")
         {
            this._awardTxt.text = this._activeEventsInfo.Content;
            this.show();
         }
         else
         {
            this.dispose();
         }
      }
      
      protected function __loadError(param1:LoaderEvent) : void
      {
         param1.currentTarget.removeEventListener(LoaderEvent.COMPLETE,this.__loadComplete);
         param1.currentTarget.removeEventListener(LoaderEvent.LOAD_ERROR,this.__loadError);
         this.dispose();
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      protected function __activeCloseBtnClick(param1:MouseEvent) : void
      {
         this.dispose();
      }
      
      private function __frameEventHandler(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.ESC_CLICK:
            case FrameEvent.CLOSE_CLICK:
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this._activeEventsInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._activityCardPSWII);
         this._activityCardPSWII = null;
         ObjectUtils.disposeObject(this._divisionLine);
         this._divisionLine = null;
         ObjectUtils.disposeObject(this._iconGive);
         this._iconGive = null;
         ObjectUtils.disposeObject(this._textInput);
         this._textInput = null;
         ObjectUtils.disposeObject(this._awardTxt);
         this._awardTxt = null;
         ObjectUtils.disposeObject(this._activeGetBtn);
         this._activeGetBtn = null;
         ObjectUtils.disposeObject(this._activeCloseBtn);
         this._activeCloseBtn = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
