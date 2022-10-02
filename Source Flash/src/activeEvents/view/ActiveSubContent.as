package activeEvents.view
{
   import activeEvents.data.ActiveEventsInfo;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.AccountInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SoundManager;
   import ddt.utils.CrytoUtils;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.net.URLVariables;
   import flash.utils.ByteArray;
   
   public class ActiveSubContent extends Sprite implements Disposeable
   {
       
      
      private var _panel:ScrollPanel;
      
      private var _list:VBox;
      
      private var _discriptionBox:Sprite;
      
      private var _availabilityTimeBox:Sprite;
      
      private var _passBox:Sprite;
      
      private var _contentBox:Sprite;
      
      private var _awardBox:Sprite;
      
      private var _redBg:Bitmap;
      
      private var _discriptionTitle:FilterFrameText;
      
      private var _discriptionTxt:FilterFrameText;
      
      private var _availabilityTimeTxt:FilterFrameText;
      
      private var _contentTxt:FilterFrameText;
      
      private var _awardTxt:FilterFrameText;
      
      private var _lineBg:Bitmap;
      
      private var _contentImg:Bitmap;
      
      private var _awardImg:Bitmap;
      
      private var _availabilityTimeImg:Bitmap;
      
      private var _passImg:Bitmap;
      
      private var _textInput:TextInput;
      
      private var _activeGetBtn:TextButton;
      
      private var _info:ActiveEventsInfo;
      
      private var _loader:BaseLoader;
      
      public function ActiveSubContent()
      {
         super();
         this.init();
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeAllChildren(this);
         this._panel = null;
         this._list = null;
         this._discriptionBox = null;
         this._availabilityTimeBox = null;
         this._passBox = null;
         this._contentBox = null;
         this._awardBox = null;
         this._discriptionTitle = null;
         this._discriptionTxt = null;
         this._availabilityTimeTxt = null;
         this._contentTxt = null;
         this._awardTxt = null;
         this._lineBg = null;
         this._contentImg = null;
         this._awardImg = null;
         this._availabilityTimeImg = null;
         this._passImg = null;
         this._textInput = null;
         this._activeGetBtn = null;
         this._redBg = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function set info(param1:ActiveEventsInfo) : void
      {
         this._info = param1;
         this.updateContainer();
      }
      
      public function get info() : ActiveEventsInfo
      {
         return this._info;
      }
      
      private function init() : void
      {
         this._list = new VBox();
         this._list.spacing = 10;
         this._redBg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.bgPanel");
         this._redBg.x = -10;
         this._redBg.y = -10;
         addChild(this._redBg);
         this._panel = ComponentFactory.Instance.creatComponentByStylename("activeEvents.rightSrollPanel");
         this._panel.setView(this._list);
         addChild(this._panel);
         this.createDiscriptionBox();
         this.createAvailabilityTimeBox();
         this.createContentBox();
         this.createAwardBox();
         this.createPassBox();
      }
      
      private function createDiscriptionBox() : void
      {
         this._discriptionBox = new Sprite();
         this._discriptionTitle = ComponentFactory.Instance.creatComponentByStylename("activeEvents.titleTxt");
         addChild(this._discriptionTitle);
         this._discriptionTxt = ComponentFactory.Instance.creatComponentByStylename("activeEvents.description_txt");
         this._discriptionBox.addChild(this._discriptionTxt);
      }
      
      private function createAvailabilityTimeBox() : void
      {
         this._availabilityTimeBox = new Sprite();
         this._availabilityTimeImg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.iconTime");
         this._availabilityTimeBox.addChild(this._availabilityTimeImg);
         this._availabilityTimeTxt = ComponentFactory.Instance.creatComponentByStylename("activeEvents.availabilityTime_txt");
         this._availabilityTimeBox.addChild(this._availabilityTimeTxt);
      }
      
      private function createPassBox() : void
      {
         this._passBox = new Sprite();
         this._textInput = ComponentFactory.Instance.creatComponentByStylename("activeEvents.textInput");
         this._textInput.addEventListener(TextEvent.TEXT_INPUT,this.__input);
         this._textInput.addEventListener(Event.CHANGE,this.__onChange);
         this._passBox.addChild(this._textInput);
         this._passImg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.activityCardPSWII");
         this._passBox.addChild(this._passImg);
         this._activeGetBtn = ComponentFactory.Instance.creatComponentByStylename("activeEvents.activeGetBtn");
         this._activeGetBtn.text = LanguageMgr.GetTranslation("get");
         this._activeGetBtn.addEventListener(MouseEvent.CLICK,this._activeGetBtnClick);
         this._activeGetBtn.visible = true;
         this._panel.addChild(this._activeGetBtn);
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
      }
      
      private function _activeGetBtnClick(param1:MouseEvent) : void
      {
         var _loc5_:BaseAlerFrame = null;
         SoundManager.instance.play("008");
         if(this._textInput.text == "" && this._info.HasKey == 1)
         {
            _loc5_ = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation("tank.movement.MovementRightView.pass"),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),true,false,false,2);
            _loc5_.info.showCancel = false;
            return;
         }
         this._info.isAttend = true;
         this._activeGetBtn.enable = false;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(this._textInput.text);
         var _loc3_:URLVariables = RequestVairableCreater.creatWidthKey(true);
         var _loc4_:AccountInfo = PlayerManager.Instance.Account;
         _loc3_["activeKey"] = CrytoUtils.rsaEncry4(_loc4_.Key,_loc2_);
         _loc3_["activeID"] = this._info.ActiveID;
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            this._loader = null;
         }
         this._loader = LoaderManager.Instance.creatLoader(PathManager.solveRequestPath("ActivePullDown.ashx"),BaseLoader.REQUEST_LOADER,_loc3_);
         this._loader.addEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         this._loader.addEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         LoaderManager.Instance.startLoad(this._loader,true);
         this._textInput.text = "";
      }
      
      private function __onLoadError(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.target as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         MessageTipManager.getInstance().show(_loc2_.content);
      }
      
      private function __onLoadComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.target as BaseLoader;
         _loc2_.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
         MessageTipManager.getInstance().show(_loc2_.content);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(MouseEvent.CLICK,this._activeGetBtnClick);
         if(this._textInput)
         {
            this._textInput.removeEventListener(TextEvent.TEXT_INPUT,this.__input);
            this._textInput.removeEventListener(Event.CHANGE,this.__onChange);
         }
         if(this._loader != null)
         {
            this._loader.removeEventListener(LoaderEvent.LOAD_ERROR,this.__onLoadError);
            this._loader.removeEventListener(LoaderEvent.COMPLETE,this.__onLoadComplete);
            this._loader = null;
         }
      }
      
      private function createContentBox() : void
      {
         this._contentBox = new Sprite();
         this._contentImg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.iconContent");
         this._contentBox.addChild(this._contentImg);
         this._contentTxt = ComponentFactory.Instance.creatComponentByStylename("activeEvents.content_txt");
         this._contentBox.addChild(this._contentTxt);
      }
      
      private function createAwardBox() : void
      {
         this._awardBox = new Sprite();
         this._awardImg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.iconGive");
         this._awardBox.addChild(this._awardImg);
         this._awardTxt = ComponentFactory.Instance.creatComponentByStylename("activeEvents.award_txt");
         this._awardBox.addChild(this._awardTxt);
      }
      
      private function updateContainer() : void
      {
         if(this._textInput)
         {
            this._textInput.text = "";
         }
         this._list.disposeAllChildren();
         this.updateDiscription();
         this.updateAvailabilityTime();
         this.updateContentBox();
         this.updateAwardBox();
         this.updatePassBox();
         this._list.refreshChildPos();
         this._panel.invalidateViewport();
      }
      
      private function updateDiscription() : void
      {
         if(this._info.Title || this._info.Description)
         {
            if(this._info.Title)
            {
               this._discriptionTitle.text = this._info.Title;
            }
            if(this._info.Description)
            {
               this._discriptionTxt.htmlText = this._info.Description;
            }
            this._list.addChild(this._discriptionBox);
            this._lineBg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.divisionLine");
            this._list.addChild(this._lineBg);
         }
      }
      
      private function updateAvailabilityTime() : void
      {
         if(this._info.activeTime())
         {
            this._availabilityTimeTxt.text = this._info.activeTime();
            this._list.addChild(this._availabilityTimeBox);
            this._lineBg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.divisionLine");
            this._list.addChild(this._lineBg);
         }
      }
      
      private function updateContentBox() : void
      {
         if(this._info.Content)
         {
            this._contentTxt.htmlText = this._info.Content;
            this._list.addChild(this._contentBox);
            this._lineBg = ComponentFactory.Instance.creatBitmap("asset.activeEvents.divisionLine");
            this._list.addChild(this._lineBg);
         }
      }
      
      private function updateAwardBox() : void
      {
         if(this._info.AwardContent)
         {
            this._awardTxt.htmlText = this._info.AwardContent;
            this._list.addChild(this._awardBox);
         }
      }
      
      private function updatePassBox() : void
      {
         if(this._info.HasKey == 1)
         {
            this._list.addChild(this._passBox);
         }
         if(this._info.HasKey == 1 || this._info.HasKey == 2 || this._info.HasKey == 3 || this._info.HasKey == 6)
         {
            this._activeGetBtn.visible = true;
            this._activeGetBtn.enable = !this._info.isAttend;
         }
         else
         {
            this._activeGetBtn.visible = false;
         }
      }
   }
}
