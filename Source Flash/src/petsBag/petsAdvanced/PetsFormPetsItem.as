package petsBag.petsAdvanced
{
   import baglocked.BaglockedManager;
   import com.pickgliss.loader.BaseLoader;
   import com.pickgliss.loader.LoaderEvent;
   import com.pickgliss.loader.LoaderManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PathManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petsBag.data.PetsFormData;
   import petsBag.event.PetItemEvent;
   
   public class PetsFormPetsItem extends Component implements Disposeable
   {
       
      
      private var _bg:ScaleFrameImage;
      
      private var _pet:Sprite;
      
      private var _petsName:FilterFrameText;
      
      private var _followBtn:TextButton;
      
      private var _wakeBtn:TextButton;
      
      private var _callBackBtn:TextButton;
      
      private var _showBtnFlag:int;
      
      private var _info:PetsFormData;
      
      private var _itemId:int;
      
      public function PetsFormPetsItem()
      {
         super();
         this.initView();
         this.initEvent();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsBg");
         addChild(this._bg);
         width = this._bg.width;
         height = this._bg.height;
         this._pet = new Sprite();
         PositionUtils.setPos(this._pet,"petsBag.form.petsPos");
         addChild(this._pet);
         this._petsName = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.petsNameTxt");
         addChild(this._petsName);
         this._followBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.followBtn");
         this._followBtn.text = LanguageMgr.GetTranslation("petsBag.form.petsFollowTxt");
         this._followBtn.visible = false;
         addChild(this._followBtn);
         this._wakeBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.followBtn");
         this._wakeBtn.text = LanguageMgr.GetTranslation("petsBag.form.petsWakeTxt");
         this._wakeBtn.visible = false;
         addChild(this._wakeBtn);
         this._callBackBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.callBackBtn");
         this._callBackBtn.text = LanguageMgr.GetTranslation("ddt.pets.unfight");
         this._callBackBtn.visible = false;
         addChild(this._callBackBtn);
      }
      
      private function initEvent() : void
      {
         this._followBtn.addEventListener(MouseEvent.CLICK,this.__onFollowClick);
         this._wakeBtn.addEventListener(MouseEvent.CLICK,this.__onWakeClick);
         this._callBackBtn.addEventListener(MouseEvent.CLICK,this.__onCallBackClick);
         addEventListener(MouseEvent.CLICK,this.__onMouseClick);
         addEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      public function setInfo(param1:int, param2:PetsFormData) : void
      {
         var _loc3_:Object = null;
         this._itemId = param1;
         this._info = param2;
         if(param2)
         {
            _loc3_ = new Object();
            _loc3_.title = param2.Name;
            _loc3_.isActive = param2.State == 1;
            _loc3_.state = param2.State == 1 ? LanguageMgr.GetTranslation("petsBag.form.petsWakeTxt") : LanguageMgr.GetTranslation("petsBag.form.petsUnWakeTxt");
            _loc3_.activeValue = param2.Name + LanguageMgr.GetTranslation("petsBag.form.petsWakeCard");
            _loc3_.propertyValue = LanguageMgr.GetTranslation("petsBag.form.petsListGuardTxt",param2.HeathUp) + "\n" + LanguageMgr.GetTranslation("petsBag.form.petsabsorbHurtTxt",param2.DamageReduce);
            _loc3_.getValue = LanguageMgr.GetTranslation("petsBag.form.petsCrypt").toString().split(",")[param1];
            tipData = _loc3_;
            tipDirctions = "2,1";
            this.showBtn = param2.ShowBtn;
            this._petsName.text = param2.Name;
            if(this._pet.numChildren == 0)
            {
               this.addPetBitmap(param2.Appearance);
            }
         }
         else
         {
            this.showBtn = 0;
         }
      }
      
      public function addPetBitmap(param1:String) : void
      {
         var _loc2_:BaseLoader = LoaderManager.Instance.creatLoader(PathManager.petsFormPath(param1,this.showBtn == 3 ? int(int(2)) : int(int(1))),BaseLoader.BITMAP_LOADER);
         _loc2_.addEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         LoaderManager.Instance.startLoad(_loc2_,true);
      }
      
      protected function __onComplete(param1:LoaderEvent) : void
      {
         var _loc2_:BaseLoader = param1.loader;
         _loc2_.removeEventListener(LoaderEvent.COMPLETE,this.__onComplete);
         _loc2_.content.x = -_loc2_.content.width / 2;
         _loc2_.content.y = -_loc2_.content.height;
         ObjectUtils.disposeAllChildren(this._pet);
         this._pet.addChild(_loc2_.content);
      }
      
      protected function __onFollowClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.sendPetFollowOrCall(true,this._info.TemplateID);
      }
      
      protected function __onCallBackClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         SocketManager.Instance.out.sendPetFollowOrCall(false,this._info.TemplateID);
      }
      
      protected function __onWakeClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(PlayerManager.Instance.Self.bagLocked)
         {
            BaglockedManager.Instance.show();
            return;
         }
         SocketManager.Instance.out.sendPetWake(this._info.TemplateID);
      }
      
      protected function __onMouseClick(param1:MouseEvent) : void
      {
         if(this._bg.getFrame < 2)
         {
            SoundManager.instance.playButtonSound();
            dispatchEvent(new PetItemEvent(PetItemEvent.ITEM_CLICK,{"id":this._itemId}));
         }
      }
      
      protected function __onMouseOut(param1:MouseEvent) : void
      {
         this.setBtnVisible(false);
      }
      
      protected function __onMouseOver(param1:MouseEvent) : void
      {
         this.setBtnVisible(true);
      }
      
      private function setBtnVisible(param1:Boolean) : void
      {
         if(this._showBtnFlag == 1)
         {
            this._followBtn.visible = param1;
         }
         else if(this._showBtnFlag == 2)
         {
            this._callBackBtn.visible = param1;
         }
         else if(this._showBtnFlag == 3)
         {
            this._wakeBtn.visible = param1;
         }
      }
      
      public function set showBtn(param1:int) : void
      {
         this._showBtnFlag = param1;
         this.mouseChildren = this.mouseEnabled = true;
         this._bg.setFrame(1);
         if(param1 == 1)
         {
            this._callBackBtn.visible = false;
            this._wakeBtn.visible = false;
         }
         else if(param1 == 2)
         {
            this._followBtn.visible = false;
            this._wakeBtn.visible = false;
         }
         else if(param1 == 3)
         {
            this._followBtn.visible = false;
            this._callBackBtn.visible = false;
         }
         else
         {
            this._callBackBtn.visible = false;
            this._followBtn.visible = false;
            this._wakeBtn.visible = false;
            this._bg.setFrame(2);
            this.mouseChildren = this.mouseEnabled = false;
         }
      }
      
      public function get showBtn() : int
      {
         return this._showBtnFlag;
      }
      
      private function removeEvent() : void
      {
         this._followBtn.removeEventListener(MouseEvent.CLICK,this.__onFollowClick);
         this._wakeBtn.removeEventListener(MouseEvent.CLICK,this.__onWakeClick);
         this._callBackBtn.removeEventListener(MouseEvent.CLICK,this.__onCallBackClick);
         removeEventListener(MouseEvent.CLICK,this.__onMouseClick);
         removeEventListener(MouseEvent.MOUSE_OVER,this.__onMouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.__onMouseOut);
      }
      
      override public function dispose() : void
      {
         this.removeEvent();
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._petsName);
         this._petsName = null;
         ObjectUtils.disposeObject(this._followBtn);
         this._followBtn = null;
         ObjectUtils.disposeObject(this._wakeBtn);
         this._wakeBtn = null;
         ObjectUtils.disposeObject(this._callBackBtn);
         this._callBackBtn = null;
         if(this._pet)
         {
            ObjectUtils.disposeAllChildren(this._pet);
            ObjectUtils.disposeObject(this._pet);
            this._pet = null;
         }
         this._info = null;
         ObjectUtils.disposeAllChildren(this);
         if(parent)
         {
            parent.removeChild(this);
         }
         super.dispose();
      }
      
      public function get info() : PetsFormData
      {
         return this._info;
      }
   }
}
