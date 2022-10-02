package setting.view
{
   import com.pickgliss.events.InteractiveEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SelectedCheckButton;
   import com.pickgliss.ui.controls.Silder;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.OpitionEnum;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SharedManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import setting.controll.SettingController;
   
   public class SettingView extends BaseAlerFrame
   {
       
      
      private var _bmpBg:Bitmap;
      
      private var _imgTitle1:Image;
      
      private var _imgTitle2:Image;
      
      private var _imgTitle3:Image;
      
      private var _bmpYpsz:Bitmap;
      
      private var _bmpXssz:Bitmap;
      
      private var _bmpGnsz:Bitmap;
      
      private var _cbBjyy:SelectedCheckButton;
      
      private var _cbYxyx:SelectedCheckButton;
      
      private var _cbWqtx:SelectedCheckButton;
      
      private var _cbLbgn:SelectedCheckButton;
      
      private var _cbJsyq:SelectedCheckButton;
      
      private var _cbSxts:SelectedCheckButton;
      
      private var _communityFunction:SelectedCheckButton;
      
      private var _academy:SelectedCheckButton;
      
      private var _refusedBeFriendBtn:SelectedCheckButton;
      
      private var _refusedPrivateChatBtn:SelectedCheckButton;
      
      private var _sliderBg1:Bitmap;
      
      private var _sliderBg2:Bitmap;
      
      private var _sliderBjyy:Silder;
      
      private var _sliderYxyx:Silder;
      
      private var _oldAllowMusic:Boolean;
      
      private var _oldAllowSound:Boolean;
      
      private var _oldShowParticle:Boolean;
      
      private var _oldShowBugle:Boolean;
      
      private var _oldShowInvate:Boolean;
      
      private var _oldShowOL:Boolean;
      
      private var _oldisRecommend:Boolean;
      
      private var _oldMusicVolumn:Number;
      
      private var _oldSoundVolumn:Number;
      
      private var _oldIsCommunity:Boolean;
      
      private var _recommendHint:MovieClip;
      
      public function SettingView()
      {
         super();
         this.initView();
      }
      
      override public function dispose() : void
      {
         this._cbBjyy.removeEventListener(MouseEvent.CLICK,this.__audioSelect);
         this._cbYxyx.removeEventListener(MouseEvent.CLICK,this.__audioSelect);
         this._cbWqtx.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._cbLbgn.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._cbJsyq.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._cbSxts.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._academy.removeEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._refusedBeFriendBtn.removeEventListener(MouseEvent.CLICK,this.__refusedBeFriendHandler);
         this._refusedPrivateChatBtn.removeEventListener(MouseEvent.CLICK,this.__refusedPrivateChat);
         this._sliderBjyy.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__musicSliderChanged);
         this._sliderYxyx.removeEventListener(InteractiveEvent.STATE_CHANGED,this.__soundSliderChanged);
         var _loc1_:DisplayObject = StageReferance.stage.focus as DisplayObject;
         if(_loc1_ && contains(_loc1_))
         {
            StageReferance.stage.focus = null;
         }
         if(this._recommendHint && this._recommendHint.parent)
         {
            this._recommendHint.removeEventListener(MouseEvent.CLICK,this.__recommendHintClick);
            this._recommendHint.parent.removeChild(this._recommendHint);
            this._recommendHint = null;
         }
         ObjectUtils.disposeAllChildren(this);
         this._bmpBg = null;
         this._imgTitle1 = null;
         this._imgTitle2 = null;
         this._imgTitle3 = null;
         this._bmpYpsz = null;
         this._bmpXssz = null;
         this._bmpGnsz = null;
         this._cbBjyy = null;
         this._cbYxyx = null;
         this._cbWqtx = null;
         this._cbLbgn = null;
         this._cbJsyq = null;
         this._cbSxts = null;
         this._sliderBg1 = null;
         this._sliderBg2 = null;
         this._sliderBjyy = null;
         this._sliderYxyx = null;
         this._refusedBeFriendBtn = null;
         this._refusedPrivateChatBtn = null;
         super.dispose();
         SettingController.Instance.dispose();
      }
      
      private function __refusedPrivateChat(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(!this._refusedPrivateChatBtn.selected,OpitionEnum.RefusedPrivateChat);
         SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
      }
      
      private function initView() : void
      {
         var _loc3_:Point = null;
         _loc3_ = null;
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("tank.game.ToolStripView.set"));
         _loc1_.moveEnable = false;
         info = _loc1_;
         this._bmpBg = ComponentFactory.Instance.creatBitmap("asset.setting.bg");
         addToContent(this._bmpBg);
         this._imgTitle1 = ComponentFactory.Instance.creat("setting.title1");
         addToContent(this._imgTitle1);
         this._imgTitle2 = ComponentFactory.Instance.creat("setting.title2");
         addToContent(this._imgTitle2);
         this._imgTitle3 = ComponentFactory.Instance.creat("setting.title3");
         addToContent(this._imgTitle3);
         this._bmpYpsz = ComponentFactory.Instance.creatBitmap("asset.setting.ypsz");
         addToContent(this._bmpYpsz);
         this._bmpXssz = ComponentFactory.Instance.creatBitmap("asset.setting.xssz");
         addToContent(this._bmpXssz);
         this._bmpGnsz = ComponentFactory.Instance.creatBitmap("asset.setting.gnsz");
         addToContent(this._bmpGnsz);
         this._cbBjyy = ComponentFactory.Instance.creat("setting.cbBjyy");
         this._cbBjyy.addEventListener(MouseEvent.CLICK,this.__audioSelect);
         addToContent(this._cbBjyy);
         this._cbYxyx = ComponentFactory.Instance.creat("setting.cbYxyx");
         this._cbYxyx.addEventListener(MouseEvent.CLICK,this.__audioSelect);
         addToContent(this._cbYxyx);
         this._cbWqtx = ComponentFactory.Instance.creat("setting.cbWqtx");
         this._cbWqtx.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbWqtx);
         this._cbLbgn = ComponentFactory.Instance.creat("setting.cbLbgn");
         this._cbLbgn.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbLbgn);
         this._cbJsyq = ComponentFactory.Instance.creat("setting.cbJsyq");
         this._cbJsyq.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbJsyq);
         this._cbSxts = ComponentFactory.Instance.creat("setting.cbSxts");
         this._cbSxts.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._cbSxts);
         this._communityFunction = ComponentFactory.Instance.creat("setting.CommunityFunction");
         this._communityFunction.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         addToContent(this._communityFunction);
         if(!PathManager.isVisibleExistBtn() || !PathManager.CommunityExist())
         {
            this._communityFunction.visible = false;
         }
         this._academy = ComponentFactory.Instance.creatComponentByStylename("setting.academy");
         this._academy.addEventListener(MouseEvent.CLICK,this.__checkBoxClick);
         this._refusedBeFriendBtn = ComponentFactory.Instance.creatComponentByStylename("setting.allowAddFriend");
         this._refusedBeFriendBtn.addEventListener(MouseEvent.CLICK,this.__refusedBeFriendHandler);
         addToContent(this._refusedBeFriendBtn);
         this._refusedPrivateChatBtn = ComponentFactory.Instance.creatComponentByStylename("setting.refusedPrivateChat");
         this._refusedPrivateChatBtn.addEventListener(MouseEvent.CLICK,this.__refusedPrivateChat);
         addToContent(this._refusedPrivateChatBtn);
         var _loc2_:Point = ComponentFactory.Instance.creatCustomObject("setting.sliderBg1");
         _loc3_ = ComponentFactory.Instance.creatCustomObject("setting.sliderBg2");
         this._sliderBg1 = ComponentFactory.Instance.creatBitmap("asset.setting.sliderBg");
         this._sliderBg1.x = _loc2_.x;
         this._sliderBg1.y = _loc2_.y;
         addToContent(this._sliderBg1);
         this._sliderBg2 = ComponentFactory.Instance.creatBitmap("asset.setting.sliderBg");
         this._sliderBg2.x = _loc3_.x;
         this._sliderBg2.y = _loc3_.y;
         addToContent(this._sliderBg2);
         this._sliderBjyy = ComponentFactory.Instance.creat("setting.HSilderBJYY");
         this._sliderBjyy.addEventListener(InteractiveEvent.STATE_CHANGED,this.__musicSliderChanged);
         addToContent(this._sliderBjyy);
         this._sliderYxyx = ComponentFactory.Instance.creat("setting.HSilderYXYX");
         this._sliderYxyx.addEventListener(InteractiveEvent.STATE_CHANGED,this.__soundSliderChanged);
         addToContent(this._sliderYxyx);
         this.initData();
      }
      
      private function initData() : void
      {
         this._oldAllowMusic = this.allowMusic = SharedManager.Instance.allowMusic;
         this._oldAllowSound = this.allowSound = SharedManager.Instance.allowSound;
         this._oldShowParticle = this.particle = SharedManager.Instance.showParticle;
         this._oldShowBugle = this.showbugle = SharedManager.Instance.showTopMessageBar;
         this._oldShowInvate = this.invate = SharedManager.Instance.showInvateWindow;
         this._oldShowOL = this.showOL = SharedManager.Instance.showOL;
         this._oldMusicVolumn = this.musicVolumn = SharedManager.Instance.musicVolumn;
         this._oldSoundVolumn = this.soundVolumn = SharedManager.Instance.soundVolumn;
         this._oldisRecommend = this.isRecommend = SharedManager.Instance.isRecommend;
         this._refusedBeFriendBtn.selected = !PlayerManager.Instance.Self.getOptionState(OpitionEnum.RefusedBeFriend);
         this._refusedPrivateChatBtn.selected = !PlayerManager.Instance.Self.getOptionState(OpitionEnum.RefusedPrivateChat);
         this.sliderEnable(this._sliderBjyy,this._sliderBg1,this.allowMusic);
         this.sliderEnable(this._sliderYxyx,this._sliderBg2,this.allowSound);
         this._oldIsCommunity = this.isCommunity = SharedManager.Instance.isCommunity;
      }
      
      public function setShowSettingMovie() : void
      {
         if(SharedManager.Instance.isSetingMovieClip)
         {
            this._recommendHint = ComponentFactory.Instance.creat("asset.setting.RecommendHint");
            PositionUtils.setPos(this._recommendHint,"setting.recommendHintPos");
            LayerManager.Instance.addToLayer(this._recommendHint,LayerManager.GAME_TOP_LAYER,false);
            this._recommendHint.addEventListener(MouseEvent.CLICK,this.__recommendHintClick);
         }
      }
      
      private function get allowMusic() : Boolean
      {
         return this._cbBjyy.selected;
      }
      
      private function set allowMusic(param1:Boolean) : void
      {
         this._cbBjyy.selected = param1;
      }
      
      private function get allowSound() : Boolean
      {
         return this._cbYxyx.selected;
      }
      
      private function set allowSound(param1:Boolean) : void
      {
         this._cbYxyx.selected = param1;
      }
      
      private function get particle() : Boolean
      {
         return this._cbWqtx.selected;
      }
      
      private function set particle(param1:Boolean) : void
      {
         this._cbWqtx.selected = param1;
      }
      
      private function get showbugle() : Boolean
      {
         return this._cbLbgn.selected;
      }
      
      private function set showbugle(param1:Boolean) : void
      {
         this._cbLbgn.selected = param1;
      }
      
      private function get invate() : Boolean
      {
         return this._cbJsyq.selected;
      }
      
      private function set invate(param1:Boolean) : void
      {
         this._cbJsyq.selected = param1;
      }
      
      private function get showOL() : Boolean
      {
         return this._cbSxts.selected;
      }
      
      private function set showOL(param1:Boolean) : void
      {
         this._cbSxts.selected = param1;
      }
      
      private function get musicVolumn() : int
      {
         return this._sliderBjyy.value;
      }
      
      private function set musicVolumn(param1:int) : void
      {
         this._sliderBjyy.value = param1;
      }
      
      private function get soundVolumn() : int
      {
         return this._sliderYxyx.value;
      }
      
      private function set soundVolumn(param1:int) : void
      {
         this._sliderYxyx.value = param1;
      }
      
      private function get isRecommend() : Boolean
      {
         return this._academy.selected;
      }
      
      private function set isRecommend(param1:Boolean) : void
      {
         this._academy.selected = param1;
      }
      
      private function audioChanged() : void
      {
         SharedManager.Instance.changed();
      }
      
      private function get isCommunity() : Boolean
      {
         return this._communityFunction.selected;
      }
      
      private function set isCommunity(param1:Boolean) : void
      {
         this._communityFunction.selected = param1;
      }
      
      private function revert() : void
      {
         SharedManager.Instance.allowMusic = this._oldAllowMusic;
         SharedManager.Instance.allowSound = this._oldAllowSound;
         SharedManager.Instance.showParticle = this._oldShowParticle;
         SharedManager.Instance.showTopMessageBar = this._oldShowBugle;
         SharedManager.Instance.showInvateWindow = this._oldShowInvate;
         SharedManager.Instance.showOL = this._oldShowOL;
         SharedManager.Instance.musicVolumn = this._oldMusicVolumn;
         SharedManager.Instance.soundVolumn = this._oldSoundVolumn;
         SharedManager.Instance.isCommunity = this._oldIsCommunity;
         SharedManager.Instance.isRecommend = this._oldisRecommend;
         SharedManager.Instance.save();
      }
      
      public function doConfirm() : void
      {
         SoundManager.instance.play("008");
         SharedManager.Instance.allowMusic = this.allowMusic;
         SharedManager.Instance.allowSound = this.allowSound;
         SharedManager.Instance.showParticle = this.particle;
         SharedManager.Instance.showTopMessageBar = this.showbugle;
         SharedManager.Instance.showInvateWindow = this.invate;
         SharedManager.Instance.showOL = this.showOL;
         SharedManager.Instance.musicVolumn = this.musicVolumn;
         SharedManager.Instance.soundVolumn = this.soundVolumn;
         SharedManager.Instance.isCommunity = this.isCommunity;
         SharedManager.Instance.isRecommend = this.isRecommend;
         SharedManager.Instance.save();
      }
      
      public function doCancel() : void
      {
         SoundManager.instance.play("008");
         this.revert();
      }
      
      private function sliderEnable(param1:Silder, param2:Bitmap, param3:Boolean) : void
      {
         var _loc4_:Array = null;
         param1.mouseChildren = param3;
         param1.mouseEnabled = param3;
         if(param3)
         {
            param1.filters = null;
            param2.filters = null;
         }
         else
         {
            _loc4_ = [ComponentFactory.Instance.model.getSet("grayFilter")];
            param2.filters = _loc4_;
            param1.filters = _loc4_;
         }
      }
      
      private function __checkBoxClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
      }
      
      private function __recommendHintClick(param1:MouseEvent) : void
      {
         if(this._recommendHint && this._recommendHint.parent)
         {
            this._recommendHint.removeEventListener(MouseEvent.CLICK,this.__recommendHintClick);
            this._recommendHint.parent.removeChild(this._recommendHint);
         }
      }
      
      private function __audioSelect(param1:MouseEvent) : void
      {
         SharedManager.Instance.allowMusic = this.allowMusic;
         SharedManager.Instance.allowSound = this.allowSound;
         this.audioChanged();
         if(param1.currentTarget == this._cbBjyy)
         {
            SoundManager.instance.play("008");
            this.sliderEnable(this._sliderBjyy,this._sliderBg1,this.allowMusic);
         }
         else if(param1.currentTarget == this._cbYxyx)
         {
            this.sliderEnable(this._sliderYxyx,this._sliderBg2,this.allowSound);
         }
      }
      
      private function __musicSliderChanged(param1:Event) : void
      {
         SharedManager.Instance.musicVolumn = this.musicVolumn;
         this.audioChanged();
      }
      
      private function __soundSliderChanged(param1:Event) : void
      {
         SharedManager.Instance.soundVolumn = this.soundVolumn;
         this.audioChanged();
      }
      
      private function __refusedBeFriendHandler(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         PlayerManager.Instance.Self.OptionOnOff = OpitionEnum.setOpitionState(!this._refusedBeFriendBtn.selected,OpitionEnum.RefusedBeFriend);
         SocketManager.Instance.out.sendOpition(PlayerManager.Instance.Self.OptionOnOff);
      }
   }
}
