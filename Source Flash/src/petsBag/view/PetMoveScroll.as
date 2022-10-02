package petsBag.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.manager.SoundManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import pet.date.PetInfo;
   import petsBag.controller.PetBagController;
   import petsBag.view.item.PetSmallItem;
   
   public class PetMoveScroll extends Sprite implements Disposeable
   {
      
      public static const PET_MOVE:String = "PetMove";
       
      
      private var itemContainer:HBox;
      
      private const SPACE:int = 5;
      
      private const SHOW_PET_COUNT:int = 5;
      
      private var _currentShowIndex:int = 0;
      
      private var _isMove:Boolean = false;
      
      private var _petsImgVec:Vector.<PetSmallItem>;
      
      public var currentPet:PetSmallItem;
      
      private var _leftBtn:SimpleBitmapButton;
      
      private var _rightBtn:SimpleBitmapButton;
      
      private var _petBg:Sprite;
      
      private var _petBg2:DisplayObject;
      
      private var _petBg0:DisplayObject;
      
      private var _infoPlayer:PlayerInfo;
      
      private var _selectedIndex:int = -1;
      
      private var _currentPage:int;
      
      private var _totlePage:int;
      
      public function PetMoveScroll()
      {
         super();
         this._petsImgVec = new Vector.<PetSmallItem>();
         this.initView();
         this.initEvent();
      }
      
      public function set infoPlayer(param1:PlayerInfo) : void
      {
         this._infoPlayer = param1;
         if(!this._infoPlayer)
         {
            return;
         }
         this.upCells(this._currentPage);
         this.updateSelect();
      }
      
      public function refreshPetInfo(param1:PetInfo, param2:int = 0) : void
      {
         if(param2 == 0 || param2 == 1)
         {
            this._infoPlayer.pets[param1.Place] = param1;
         }
         this.upCells(this._currentPage);
         if(param2 == 2)
         {
            this.removePetPageUpdate();
         }
         this.updateSelect();
      }
      
      private function removePetPageUpdate() : void
      {
         var _loc2_:PetSmallItem = null;
         var _loc1_:int = 0;
         for each(_loc2_ in this._petsImgVec)
         {
            if(_loc2_.info)
            {
               _loc1_++;
            }
         }
         if(_loc1_ == 0)
         {
            this._currentPage = this._currentPage - 1 < 0 ? int(int(0)) : int(int(this._currentPage - 1));
            //this._totlePage = this._infoPlayer.pets.length % 5 == 0 ? int(int(this._infoPlayer.pets.length / 5 - 1)) : int(int(this._infoPlayer.pets.length / 5));
			this._totlePage = 4;
            this.upCells(this._currentPage);
         }
      }
      
      private function initView() : void
      {
         var _loc2_:PetSmallItem = null;
         this._petBg0 = ComponentFactory.Instance.creat("petsBag.petMoveScroll.bottomBg0");
         addChild(this._petBg0);
         this._petBg2 = ComponentFactory.Instance.creat("petsBag.petMoveScroll.bottomBg");
         addChild(this._petBg2);
         this._petBg = ComponentFactory.Instance.creat("petsBag.sprite.moveScroll");
         addChild(this._petBg);
         this._leftBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.left");
         this._leftBtn.transparentEnable = true;
         addChild(this._leftBtn);
         this._rightBtn = ComponentFactory.Instance.creatComponentByStylename("petsBag.button.right");
         addChild(this._rightBtn);
         this.itemContainer = ComponentFactory.Instance.creatComponentByStylename("petsBag.petItemContainer");
         addChild(this.itemContainer);
         this.itemContainer.strictSize = 74;
         var _loc1_:int = 0;
         while(_loc1_ < this.SHOW_PET_COUNT)
         {
            _loc2_ = new PetSmallItem();
            this._petsImgVec.push(this.itemContainer.addChild(_loc2_));
            _loc1_++;
         }
      }
      
      private function initEvent() : void
      {
         var _loc1_:PetSmallItem = null;
         this._leftBtn.addEventListener(MouseEvent.CLICK,this.__left);
         this._rightBtn.addEventListener(MouseEvent.CLICK,this.__right);
         for each(_loc1_ in this._petsImgVec)
         {
            _loc1_.addEventListener(MouseEvent.CLICK,this.__onClick);
         }
      }
      
      private function __onClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:PetSmallItem = param1.currentTarget as PetSmallItem;
         if(_loc2_.info)
         {
            PetBagController.instance().petModel.currentPetInfo = _loc2_.info;
            this._selectedIndex = this._petsImgVec.indexOf(_loc2_);
         }
      }
      
      public function updateSelect() : void
      {
         var _loc2_:PetSmallItem = null;
         var _loc1_:PetInfo = PetBagController.instance().petModel.currentPetInfo;
         for each(_loc2_ in this._petsImgVec)
         {
            if(_loc2_.info)
            {
               _loc2_.selected = _loc1_ && _loc1_.ID == _loc2_.info.ID;
               if(_loc2_.selected)
               {
                  this._selectedIndex = this._petsImgVec.indexOf(_loc2_);
               }
            }
         }
      }
      
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function get currentPage() : int
      {
         return this._currentPage;
      }
      
      private function removeEvent() : void
      {
         this._leftBtn.removeEventListener(MouseEvent.CLICK,this.__left);
         this._rightBtn.removeEventListener(MouseEvent.CLICK,this.__right);
      }
      
      private function __left(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         //this._totlePage = this._infoPlayer.pets.length % 5 == 0 ? int(int(this._infoPlayer.pets.length / 5 - 1)) : int(int(this._infoPlayer.pets.length / 5));
		 this._totlePage = 4;
         this._currentPage = this._currentPage - 1 < 0 ? int(int(0)) : int(int(this._currentPage - 1));
         this.upCells(this._currentPage);
      }
      
      private function __right(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         //this._totlePage = this._infoPlayer.pets.length % 5 == 0 ? int(int(this._infoPlayer.pets.length / 5 - 1)) : int(int(this._infoPlayer.pets.length / 5));
		 this._totlePage = 4;
         this._currentPage = this._currentPage + 1 > this._totlePage ? int(int(this._totlePage)) : int(int(this._currentPage + 1));
         this.upCells(this._currentPage);
      }
      
      private function upCells(param1:int = 0) : void
      {
         this._currentPage = param1;
         var _loc2_:int = param1 * 5;
         var _loc3_:int = 0;
         while(_loc3_ < 5)
         {
            if(this._infoPlayer.pets[_loc3_ + _loc2_])
            {
               this._petsImgVec[_loc3_].info = this._infoPlayer.pets[_loc3_ + _loc2_];
            }
            else
            {
               this._petsImgVec[_loc3_].info = null;
            }
            _loc3_++;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this.currentPet)
         {
            ObjectUtils.disposeObject(this.currentPet);
            this.currentPet = null;
         }
         if(this._leftBtn)
         {
            ObjectUtils.disposeObject(this._leftBtn);
            this._leftBtn = null;
         }
         if(this._rightBtn)
         {
            ObjectUtils.disposeObject(this._rightBtn);
            this._rightBtn = null;
         }
         if(this._petBg)
         {
            ObjectUtils.disposeObject(this._petBg);
            this._petBg = null;
         }
         if(this._petBg2)
         {
            ObjectUtils.disposeObject(this._petBg2);
            this._petBg2 = null;
         }
         if(this._petBg0)
         {
            ObjectUtils.disposeObject(this._petBg0);
            this._petBg0 = null;
         }
         this._infoPlayer = null;
         ObjectUtils.disposeAllChildren(this);
      }
   }
}
