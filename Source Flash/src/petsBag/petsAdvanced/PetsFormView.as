package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import petsBag.data.PetsFormData;
   import petsBag.event.PetItemEvent;
   import road7th.comm.PackageIn;
   
   public class PetsFormView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Bitmap;
      
      private var _shiner:Bitmap;
      
      private var _lifeGuard:FilterFrameText;
      
      private var _absorbHurt:FilterFrameText;
      
      private var _prePageBtn:SimpleBitmapButton;
      
      private var _nextPageBtn:SimpleBitmapButton;
      
      private var _currentPageInput:Scale9CornerImage;
      
      private var _currentPage:FilterFrameText;
      
      private var _page:int = 1;
      
      private var _petsVec:Vector.<PetsFormPetsItem>;
      
      public function PetsFormView()
      {
         super();
         this.initData();
         this.initView();
         this.initEvent();
         this.sendPkg();
      }
      
      private function sendPkg() : void
      {
         SocketManager.Instance.out.sendPetFormInfo();
      }
      
      private function initData() : void
      {
         this._petsVec = new Vector.<PetsFormPetsItem>();
      }
      
      private function initView() : void
      {
         this._bg = ComponentFactory.Instance.creat("petsBag.form.bg");
         addChild(this._bg);
         this._lifeGuard = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.lifeGuardText");
         addChild(this._lifeGuard);
         this._absorbHurt = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.lifeGuardText");
         PositionUtils.setPos(this._absorbHurt,"petsBag.form.absorbHurtPos");
         addChild(this._absorbHurt);
         this._prePageBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.prePageBtn");
         addChild(this._prePageBtn);
         this._nextPageBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.nextPageBtn");
         addChild(this._nextPageBtn);
         this._currentPageInput = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.currentPageInput");
         addChild(this._currentPageInput);
         this._currentPage = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.currentPage");
         addChild(this._currentPage);
      }
      
      private function creatPetsView() : void
      {
         var _loc2_:PetsFormPetsItem = null;
         _loc2_ = null;
         var _loc3_:PetsFormData = null;
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = ComponentFactory.Instance.creatComponentByStylename("petsBag.form.PetsFormPetsItem");
            if(_loc1_ < 3)
            {
               _loc2_.x = 34 + 180 * _loc1_;
               _loc2_.y = 95;
            }
            else
            {
               _loc2_.x = 34 + 180 * (_loc1_ - 3);
               _loc2_.y = 243;
            }
            _loc3_ = null;
            if(_loc1_ < PetsAdvancedManager.Instance.formDataList.length)
            {
               _loc3_ = PetsAdvancedManager.Instance.formDataList[_loc1_];
               if(_loc3_.TemplateID == PlayerManager.Instance.Self.PetsID)
               {
                  _loc3_.ShowBtn = 2;
               }
            }
            _loc2_.setInfo(_loc1_,_loc3_);
            _loc2_.addEventListener(PetItemEvent.ITEM_CLICK,this.__onClickPetsItem);
            addChild(_loc2_);
            this._petsVec.push(_loc2_);
            _loc1_++;
         }
         this._shiner = ComponentFactory.Instance.creat("petsBag.form.clickPets");
         this.setShinerPos(0);
         addChild(this._shiner);
         this.setItemInfo();
      }
      
      protected function __onClickPetsItem(param1:PetItemEvent) : void
      {
         var _loc2_:int = param1.data.id;
         this.setShinerPos(_loc2_);
      }
      
      private function setShinerPos(param1:int) : void
      {
         this._shiner.x = this._petsVec[param1].x - 4;
         this._shiner.y = this._petsVec[param1].y - 4;
      }
      
      private function setItemInfo() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc3_ < this._petsVec.length)
         {
            if(this._petsVec[_loc3_].info && this._petsVec[_loc3_].info.State == 1)
            {
               _loc1_ += this._petsVec[_loc3_].info.HeathUp;
               _loc2_ += this._petsVec[_loc3_].info.DamageReduce;
            }
            _loc3_++;
         }
         this._lifeGuard.text = LanguageMgr.GetTranslation("petsBag.form.petsListGuardTxt",_loc1_);
         this._absorbHurt.text = LanguageMgr.GetTranslation("petsBag.form.petsabsorbHurtTxt",_loc2_);
      }
      
      private function initEvent() : void
      {
         this._prePageBtn.addEventListener(MouseEvent.CLICK,this.__onPrePageClick);
         this._nextPageBtn.addEventListener(MouseEvent.CLICK,this.__onNextPageClick);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_FORMINFO,this.__onGetPetsFormInfo);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_FOLLOW,this.__onPetsFollowOrCall);
         SocketManager.Instance.addEventListener(CrazyTankSocketEvent.PET_WAKE,this.__onPetsWake);
      }
      
      protected function __onPrePageClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(this._page > 1)
         {
            --this._page;
            this.setPageInfo();
         }
      }
      
      protected function __onNextPageClick(param1:MouseEvent) : void
      {
         SoundManager.instance.playButtonSound();
         if(6 * this._page < PetsAdvancedManager.Instance.formDataList.length)
         {
            ++this._page;
            this.setPageInfo();
         }
      }
      
      private function setPageInfo() : void
      {
         var _loc2_:int = 0;
         var _loc3_:PetsFormData = null;
         var _loc1_:int = 0;
         while(_loc1_ < this._petsVec.length)
         {
            _loc2_ = 6 * (this._page - 1) + _loc1_;
            _loc3_ = null;
            if(_loc2_ < PetsAdvancedManager.Instance.formDataList.length)
            {
               _loc3_ = PetsAdvancedManager.Instance.formDataList[_loc2_];
            }
            this._petsVec[_loc1_].setInfo(_loc1_,_loc3_);
            _loc1_++;
         }
      }
      
      protected function __onGetPetsFormInfo(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = _loc2_.readInt();
            _loc6_ = PetsAdvancedManager.Instance.getFormDataIndexByTempId(_loc5_);
            PetsAdvancedManager.Instance.formDataList[_loc6_].State = 1;
            PetsAdvancedManager.Instance.formDataList[_loc6_].ShowBtn = 1;
            _loc4_++;
         }
         this.creatPetsView();
      }
      
      protected function __onPetsWake(param1:CrazyTankSocketEvent) : void
      {
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = PetsAdvancedManager.Instance.getFormDataIndexByTempId(_loc3_);
         PetsAdvancedManager.Instance.formDataList[_loc4_].State = 1;
         this.resetItemInfo(_loc3_,1,_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < this._petsVec.length)
         {
            if(this._petsVec[_loc5_].info)
            {
               if(this._petsVec[_loc5_].info.TemplateID == _loc3_)
               {
                  this._petsVec[_loc5_].addPetBitmap(PetsAdvancedManager.Instance.formDataList[_loc4_].Appearance);
                  break;
               }
            }
            _loc5_++;
         }
      }
      
      protected function __onPetsFollowOrCall(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:int = 0;
         var _loc2_:PackageIn = param1.pkg;
         var _loc3_:Boolean = _loc2_.readBoolean();
         var _loc4_:int = _loc2_.readInt();
         if(_loc4_ != -1)
         {
            _loc5_ = PetsAdvancedManager.Instance.getFormDataIndexByTempId(_loc4_);
            this.resetItemInfo(_loc4_,!!_loc3_ ? int(int(2)) : int(int(1)),_loc5_);
            PlayerManager.Instance.Self.PetsID = !!_loc3_ ? int(int(_loc4_)) : int(int(-1));
            if(_loc3_)
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.form.petsFollowStateTxt"));
            }
            else
            {
               MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("petsBag.form.petsCallBackTxt"));
            }
         }
      }
      
      private function resetItemInfo(param1:int, param2:int, param3:int) : void
      {
         this.setItemInfo();
         PetsAdvancedManager.Instance.formDataList[param3].ShowBtn = param2;
         var _loc4_:int = 0;
         while(_loc4_ < this._petsVec.length)
         {
            if(this._petsVec[_loc4_].info)
            {
               if(this._petsVec[_loc4_].info.TemplateID == param1)
               {
                  this._petsVec[_loc4_].setInfo(_loc4_,PetsAdvancedManager.Instance.formDataList[param3]);
               }
               else if(this._petsVec[_loc4_].showBtn == 2)
               {
                  this._petsVec[_loc4_].showBtn = 1;
               }
            }
            _loc4_++;
         }
      }
      
      private function removeEvent() : void
      {
         this._prePageBtn.removeEventListener(MouseEvent.CLICK,this.__onPrePageClick);
         this._nextPageBtn.removeEventListener(MouseEvent.CLICK,this.__onNextPageClick);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_FORMINFO,this.__onGetPetsFormInfo);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_FOLLOW,this.__onPetsFollowOrCall);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.PET_WAKE,this.__onPetsWake);
      }
      
      private function deletePets() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < this._petsVec.length)
         {
            if(this._petsVec[_loc1_])
            {
               this._petsVec[_loc1_].removeEventListener(PetItemEvent.ITEM_CLICK,this.__onClickPetsItem);
               this._petsVec[_loc1_].dispose();
               this._petsVec[_loc1_] = null;
            }
            _loc1_++;
         }
         this._petsVec.length = 0;
         this._petsVec = null;
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this.deletePets();
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._shiner)
         {
            ObjectUtils.disposeObject(this._shiner);
            this._shiner = null;
         }
         if(this._lifeGuard)
         {
            this._lifeGuard.dispose();
            this._lifeGuard = null;
         }
         if(this._absorbHurt)
         {
            this._absorbHurt.dispose();
            this._absorbHurt = null;
         }
         if(this._prePageBtn)
         {
            this._prePageBtn.dispose();
            this._prePageBtn = null;
         }
         if(this._nextPageBtn)
         {
            this._nextPageBtn.dispose();
            this._nextPageBtn = null;
         }
         if(this._currentPageInput)
         {
            this._currentPageInput.dispose();
            this._currentPageInput = null;
         }
         if(this._currentPage)
         {
            this._currentPage.dispose();
            this._currentPage = null;
         }
         ObjectUtils.disposeAllChildren(this);
         ObjectUtils.removeChildAllChildren(this);
      }
   }
}
