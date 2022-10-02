package civil.view
{
   import civil.CivilController;
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.effect.EffectManager;
   import com.pickgliss.effect.EffectTypes;
   import com.pickgliss.effect.IEffect;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SelectedButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import im.IMController;
   
   public class CivilRightView extends Sprite implements Disposeable
   {
       
      
      private var _bg:Scale9CornerImage;
      
      private var _rightViewBg:Bitmap;
      
      private var _nameTitle:Bitmap;
      
      private var _levelTitle:Bitmap;
      
      private var _stateTitle:Bitmap;
      
      private var _searchBG:Bitmap;
      
      private var _civilGenderContainer:HBox;
      
      private var _civilGenderGroup:SelectedButtonGroup;
      
      private var _maleBtn:SelectedButton;
      
      private var _femaleBtn:SelectedButton;
      
      private var _searchBtn:SimpleBitmapButton;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _registerBtn:SimpleBitmapButton;
      
      private var _addBigBtn:SimpleBitmapButton;
      
      private var _menberList:CivilPlayerInfoList;
      
      private var _controller:CivilController;
      
      private var _currentPage:int = 1;
      
      private var _model:CivilModel;
      
      private var _sex:Boolean;
      
      private var _searchTxt:TextInput;
      
      private var _pageTxt:FilterFrameText;
      
      private var _loadMember:Boolean = false;
      
      private var _registerEffect:IEffect;
      
      private var _seachKey:String = "";
      
      private var _isBusy:Boolean;
      
      public function CivilRightView(param1:CivilController, param2:CivilModel)
      {
         this._model = param2;
         this._controller = param1;
         super();
         this.init();
         this.initButton();
         this.initEvnet();
         this._menberList.MemberList(this._model.civilPlayers);
         if(PlayerManager.Instance.Self.MarryInfoID <= 0 || !PlayerManager.Instance.Self.MarryInfoID)
         {
            SocketManager.Instance.out.sendRegisterInfo(PlayerManager.Instance.Self.ID,true,LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.text"));
         }
         if(this._model.IsFirst)
         {
            this._registerEffect.play();
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._registerEffect)
         {
            EffectManager.Instance.removeEffect(this._registerEffect);
            this._registerEffect = null;
         }
         if(this._civilGenderContainer)
         {
            ObjectUtils.disposeObject(this._civilGenderContainer);
            this._civilGenderContainer = null;
         }
         if(this._preBtn)
         {
            this._preBtn.dispose();
         }
         this._preBtn = null;
         if(this._preBtn)
         {
            this._preBtn.dispose();
         }
         this._preBtn = null;
         if(this._nextBtn)
         {
            this._nextBtn.dispose();
         }
         this._nextBtn = null;
         if(this._registerBtn)
         {
            this._registerBtn.dispose();
         }
         this._registerBtn = null;
         if(this._addBigBtn)
         {
            this._addBigBtn.dispose();
         }
         this._addBigBtn = null;
         if(this._searchBtn)
         {
            this._searchBtn.dispose();
         }
         this._searchBtn = null;
         if(this._femaleBtn)
         {
            this._femaleBtn.dispose();
         }
         this._femaleBtn = null;
         if(this._maleBtn)
         {
            this._maleBtn.dispose();
         }
         this._maleBtn = null;
         if(this._rightViewBg)
         {
            ObjectUtils.disposeObject(this._rightViewBg);
            this._rightViewBg = null;
         }
         if(this._bg)
         {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
         }
         if(this._nameTitle)
         {
            ObjectUtils.disposeObject(this._nameTitle);
            this._nameTitle = null;
         }
         if(this._levelTitle)
         {
            ObjectUtils.disposeObject(this._levelTitle);
            this._levelTitle = null;
         }
         if(this._stateTitle)
         {
            ObjectUtils.disposeObject(this._stateTitle);
            this._stateTitle = null;
         }
         if(this._searchBG)
         {
            ObjectUtils.disposeObject(this._searchBG);
            this._searchBG = null;
         }
         if(this._searchTxt)
         {
            ObjectUtils.disposeObject(this._searchTxt);
            this._searchTxt = null;
         }
         if(this._pageTxt)
         {
            ObjectUtils.disposeObject(this._pageTxt);
            this._pageTxt = null;
         }
         if(this._menberList)
         {
            ObjectUtils.disposeObject(this._menberList);
            this._menberList = null;
         }
      }
      
      public function init() : void
      {
         this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.civil.RightViewFirstBG");
         addChild(this._bg);
         this._rightViewBg = ComponentFactory.Instance.creatBitmap("asset.civil.rightViewBgAsset");
         addChild(this._rightViewBg);
         this._nameTitle = ComponentFactory.Instance.creatBitmap("asset.civil.name2Title");
         addChild(this._nameTitle);
         this._levelTitle = ComponentFactory.Instance.creatBitmap("asset.civil.levelTitle");
         addChild(this._levelTitle);
         this._stateTitle = ComponentFactory.Instance.creatBitmap("asset.civil.stateTitle");
         addChild(this._stateTitle);
         this._searchBG = ComponentFactory.Instance.creatBitmap("asset.civil.search_bgAsset");
         addChild(this._searchBG);
         this._searchTxt = ComponentFactory.Instance.creat("civil.searchText");
         this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         addChild(this._searchTxt);
         this._pageTxt = ComponentFactory.Instance.creat("civil.page");
         addChild(this._pageTxt);
         this._menberList = ComponentFactory.Instance.creatCustomObject("civil.view.CivilPlayerInfoList");
         this._menberList.model = this._model;
         addChild(this._menberList);
      }
      
      private function initButton() : void
      {
         this._civilGenderGroup = new SelectedButtonGroup();
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.searchBtn");
         addChild(this._searchBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.preBtn");
         addChild(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.nextBtn");
         addChild(this._nextBtn);
         this._registerBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.registerBtn");
         addChild(this._registerBtn);
         this._addBigBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.addBigBtn");
         addChild(this._addBigBtn);
         this._civilGenderContainer = ComponentFactory.Instance.creatComponentByStylename("civil.GenderBtnContainer");
         this._maleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.maleButton");
         this._femaleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.civil.femaleButton");
         this._civilGenderContainer.addChild(this._maleBtn);
         this._civilGenderContainer.addChild(this._femaleBtn);
         this._civilGenderGroup.addSelectItem(this._maleBtn);
         this._civilGenderGroup.addSelectItem(this._femaleBtn);
         addChild(this._civilGenderContainer);
         var _loc1_:Point = ComponentFactory.Instance.creatCustomObject("civil.register.RegisterPos");
         this._registerEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT,this._registerBtn,"asset.civil.registerGlowAsset",_loc1_);
      }
      
      private function initEvnet() : void
      {
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._registerBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._addBigBtn.addEventListener(MouseEvent.CLICK,this.__addBtnClick);
         this._searchTxt.addEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         this._menberList.addEventListener(CivilEvent.SELECTED_CHANGE,this.__memberSelectedChange);
         this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__updateView);
         this._model.addEventListener(CivilEvent.REGISTER_CHANGE,this.__onRegisterChange);
      }
      
      private function removeEvent() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._searchTxt.removeEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         this._menberList.removeEventListener(CivilEvent.SELECTED_CHANGE,this.__memberSelectedChange);
         this._registerBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._addBigBtn.removeEventListener(MouseEvent.CLICK,this.__addBtnClick);
         this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__updateView);
         this._model.removeEventListener(CivilEvent.REGISTER_CHANGE,this.__onRegisterChange);
      }
      
      private function __onRegisterChange(param1:CivilEvent) : void
      {
         if(!this._model.registed)
         {
            this._registerEffect.play();
         }
         else
         {
            this._registerEffect.stop();
         }
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.Register();
      }
      
      private function __addBtnClick(param1:MouseEvent) : void
      {
         if(this._controller.currentcivilInfo && this._controller.currentcivilInfo.info)
         {
            SoundManager.instance.play("008");
            IMController.Instance.addFriend(this._controller.currentcivilInfo.info.NickName);
         }
      }
      
      private function __sexBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentPage = 1;
         if(param1.currentTarget == this._femaleBtn)
         {
            this._sex = false;
            if(this._sex == this._model.sex)
            {
               return;
            }
            this._model.sex = false;
         }
         else
         {
            this._sex = true;
            if(this._sex == this._model.sex)
            {
               return;
            }
            this._model.sex = true;
         }
         this._sex = this._model.sex;
         this._controller.loadCivilMemberList(this._currentPage,this._model.sex);
         if(this._searchTxt.text != LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
         else
         {
            this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         }
         this._seachKey = "";
      }
      
      private function __leafBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._loadMember)
         {
            return;
         }
         if(this._isBusy)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this._preBtn:
               this._currentPage = --this._currentPage;
               break;
            case this._nextBtn:
               this._currentPage = ++this._currentPage;
               break;
            case this._searchBtn:
               if(this._searchTxt.text == "" || this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.view.CivilRightView.info"));
               }
               else
               {
                  this._seachKey = this._searchTxt.text;
                  this._currentPage = 1;
                  this._controller.loadCivilMemberList(this._currentPage,this._sex,this._seachKey);
                  this._loadMember = true;
               }
               return;
         }
         this._isBusy = true;
         this._controller.loadCivilMemberList(this._currentPage,this._sex,this._seachKey);
      }
      
      private function __searchTxtClick(param1:MouseEvent) : void
      {
         if(this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
      }
      
      private function __memberSelectedChange(param1:CivilEvent) : void
      {
         if(param1.data)
         {
            this._addBigBtn.enable = this._menberList.selectedItem.info.UserId == PlayerManager.Instance.Self.ID ? Boolean(Boolean(false)) : Boolean(Boolean(true));
         }
      }
      
      private function updateButton() : void
      {
         if(this._model.TotalPage == 1)
         {
            this.setButtonState(false,false);
         }
         else if(this._model.TotalPage == 0)
         {
            this.setButtonState(false,false);
         }
         else if(this._currentPage == 1)
         {
            this.setButtonState(false,true);
         }
         else if(this._currentPage == this._model.TotalPage && this._currentPage != 0)
         {
            this.setButtonState(true,false);
         }
         else
         {
            this.setButtonState(true,true);
         }
         if(!this._model.TotalPage)
         {
            this._pageTxt.text = String(1) + " / " + String(1);
         }
         else
         {
            this._pageTxt.text = String(this._currentPage) + " / " + String(this._model.TotalPage);
         }
         this._addBigBtn.enable = this._addBigBtn.enable && this._model.civilPlayers.length > 0 ? Boolean(Boolean(true)) : Boolean(Boolean(false));
         this.updateSex();
      }
      
      private function updateSex() : void
      {
         if(this._model.sex)
         {
            this._civilGenderGroup.selectIndex = 0;
         }
         else
         {
            this._civilGenderGroup.selectIndex = 1;
         }
         this._sex = this._model.sex;
      }
      
      private function __updateRegisterGlow(param1:CivilEvent) : void
      {
      }
      
      private function setButtonState(param1:Boolean, param2:Boolean) : void
      {
         this._preBtn.mouseChildren = param1;
         this._preBtn.enable = param1;
         this._nextBtn.mouseChildren = param2;
         this._nextBtn.enable = param2;
      }
      
      private function __updateView(param1:CivilEvent) : void
      {
         this._isBusy = false;
         this.updateButton();
         this._loadMember = false;
      }
   }
}
